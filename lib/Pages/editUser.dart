import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:thebestatoo/Classes/User.dart';
import 'main.dart';

final token = preferences.getString('token', defaultValue: '').getValue();

Future<UserEdit> fetchUser() async {
  final preferences = await StreamingSharedPreferences.instance;
  final token = preferences.getString('token', defaultValue: '').getValue();
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

class EditUser extends StatefulWidget {
  static String route = 'editUser';
  const EditUser({Key? key}) : super(key: key);

  @override
  _EditUser createState() => _EditUser();
}

class _EditUser extends State<EditUser> {
  late Future<UserEdit> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  TextEditingController pseudoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  late User user;
  String imagePath = "";
  final picker = ImagePicker();
  File imageFile = File("");
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier mon Profil'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<UserEdit>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              pseudoController.text = snapshot.data!.pseudo.toString();
              firstNameController.text = snapshot.data!.firstName.toString();
              lastNameController.text = snapshot.data!.lastName.toString();
              emailController.text = snapshot.data!.email.toString();
              snapshot.data!.adress != null ?
              addressController.text = snapshot.data!.adress.toString() : addressController.text = "";
              snapshot.data!.zipCode != null ?
              zipCodeController.text = snapshot.data!.zipCode.toString() : zipCodeController.text = "";
              snapshot.data!.city != null ?
              cityController.text = snapshot.data!.city.toString(): cityController.text = "";
              snapshot.data!.birthday != null ?
              birthdayController.text = snapshot.data!.birthday.toString(): birthdayController.text = "";
              return Form(
                  key: _formKey,
                  child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text( 'Modification de mon profil',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  imageFile.path != "" ?
                  // Affichage de l'image
                  CircleAvatar(
                    backgroundImage: FileImage(imageFile),
                    radius: 100,
                  )
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
                            print(pickedFile);
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
                        controller: pseudoController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pseudo',
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
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: TextFormField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nom',
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
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Prénom',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez renseigner ce champ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez renseigner ce champ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adresse',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ville',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: zipCodeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Code Postal',
                      ),
                    ),
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                      child: ElevatedButton(
                        child: const Text('Register'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            String fileInBase64 = "";
                            if(imageFile.path != ""){
                              List<int> fileInByte = imageFile.readAsBytesSync();
                              fileInBase64 = base64Encode(fileInByte);
                            }
                            editAccount(
                                firstNameController.text,
                                lastNameController.text,
                                emailController.text,
                                addressController.text,
                                zipCodeController.text,
                                cityController.text,
                                birthdayController.text,
                                pseudoController.text,
                                fileInBase64,
                                snapshot.data!.id
                            );
                          }
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                        ),
                      )
                  ),
                ],
                  ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<void> editAccount(String firstName, String lastName, String email, String address, String zipCode, String city, String birthday, String pseudo, String image64, int idUser) async {
    late Response response = http.Response("", 400);
    if(image64 != ""){
      print("photo detected");
      response = await http.put(
        Uri.parse('http://ideainker.fr/api/users/' + idUser.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'pseudo': pseudo,
          'email': email,
          'lastName': lastName,
          'firstName': firstName,
          'zip code': zipCode,
          'city': city,
          'address': address,
          'profileImage' : image64
        }),
      );
    }else{
      print("no photo");
      response = await http.put(
        Uri.parse('http://ideainker.fr/api/users/' + idUser.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'pseudo': pseudo,
          'email': email,
          'lastName': lastName,
          'firstName': firstName,
          'zip code': zipCode,
          'city': city,
          'address': address,
        }),
      );
    }

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Fluttertoast.showToast(
          msg: "Edit successful !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pop(context);
    } else {
      print(response.body);
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(
          msg: "Edit Failed !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  Future<void> getUserInfos() async {
    final response = await http.get(
      Uri.parse('http://ideainker.fr/api/me'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {

      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Map map = json.decode(response.body);
      setState(() {
        user = User(map);
        log(user.firstName);
      });

      Fluttertoast.showToast(
          msg: "Informations trouvés !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pop(context);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(
          msg: "Recherche échouée",
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


