import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:thebestatoo/Classes/ImageTo64.dart';
import 'package:thebestatoo/Classes/Salon.dart';
import 'dart:io';
import '../Classes/CoordinatesStore.dart';
import 'main.dart';

final token = preferences.getString('token', defaultValue: '').getValue();

Future<UserEdit> fetchUser() async {
  final response = await http
      .get(Uri.parse('http://ideainker.fr/api/me'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return UserEdit.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class UserEdit {
  final int id;
  final String email;
  final String password;
  final String? adress;
  final String? zipCode;
  final String? city;
  final String lastName;
  final String firstName;
  final String? profileImage;
  final String? birthday;
  final String? pseudo;


  const UserEdit({
    required this.id,
    required this.email,
    required this.password,
    required this.adress,
    required this.zipCode,
    required this.city,
    required this.lastName,
    required this.firstName,
    required this.profileImage,
    required this.birthday,
    required this.pseudo,
  });

  factory UserEdit.fromJson(Map<String, dynamic> json) {
    return UserEdit(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      adress: json['adress'],
      zipCode: json['zipCode'],
      city: json['city'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      profileImage: json['profileImage'],
      birthday: json['birthday'],
      pseudo: json['pseudo'],
    );
  }
}

class Posts extends StatefulWidget {
  static String route = 'addPost';
  const Posts({Key? key}) : super(key: key);

  @override
  _Posts createState() => _Posts();
}

class _Posts extends State<Posts> {
  TextEditingController contentController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  String imagePath = "";
  final picker = ImagePicker();
  File imageFile = File("");
  final _formKey = GlobalKey<FormState>();
  late Future<UserEdit> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Post'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<UserEdit>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child:ListView(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Créer un Post',
                          style: TextStyle(fontSize: 20),
                        )
                    ),
                    imageFile.path != "" ?
                    // Affichage de l'image
                    Image.file(imageFile)
                        : Container(),
                    Container(
                      child:
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black)),
                          onPressed: () async {
                            if (await Permission.photos.request().isGranted) {
                              // Either the permission was already granted before or the user just granted it.
                              final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                              // getImage à été remplacé par pickImage ?
                              if (pickedFile != null) {
                                setState(() {
                                  imageFile = File(pickedFile.path);
                                });
                              }
                            }else{
                              Map<Permission, PermissionStatus> statuses = await [
                                Permission.photos,
                              ].request();
                              //print(statuses[Permission.photos]); print status accés photos
                            }
                          },
                          child: imageFile.path != "" ? // C'est le if
                          const Text("Modifier la photo")
                              : const Text("Ajouter une photo") // : = else
                      ),
                    ),
                    imageFile.path != "" ?
                    Container(
                      child:
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black)),
                          onPressed: () {
                            setState(() {
                              imageFile = File("");
                            });
                            // Si l'image choisi n'est pas égale à null, fait un setState de imagePath = pickedFile.path;
                          },
                          child: const Text("Supprimer la photo")
                      ),
                    ): Container(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: TextFormField(
                          controller: contentController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Content',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez renseigner ce champ';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                        child: ElevatedButton(
                          child: const Text('Register'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              String fileInBase64 = "";
                              if(imageFile.path != ""){
                                fileInBase64 = imageTo64(imageFile);
                              }
                              if(fileInBase64 != ""){
                                addPost(contentController.text, fileInBase64,snapshot.data!.id);
                              }else{
                                Fluttertoast.showToast(
                                    msg: "Veuillez insérer une image",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                          ),
                        )
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
  Future<void> addPost(String content, String image64, int userId) async {
    final responsePost = await http.post(
      Uri.parse('http://ideainker.fr/api2/post/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(<String, String>{
        'content': content,
        'image': image64,
        'createdBy': userId.toString()
      }),
    );
    if (responsePost.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Fluttertoast.showToast(
          msg: "Post added with Success!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pop(context);
    }else{
      Fluttertoast.showToast(
          msg: "Failed create Post",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
}
