import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../Classes/User.dart';

Future<UserProfil> fetchUser() async {
  final response = await http
      .get(Uri.parse('http://k7-stories.com/api/users/28'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return UserProfil.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class UserProfil {
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


  const UserProfil({
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

  factory UserProfil.fromJson(Map<String, dynamic> json) {
    return UserProfil(
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

class ProfilUser extends StatefulWidget {
  static String route = 'ProfilUser';

  const ProfilUser({Key? key}) : super(key: key);

  @override
  _ProfilUser createState() => _ProfilUser();
}

class _ProfilUser extends State<ProfilUser> {
  late User user;
  late Future<UserProfil> futureUser;

  String imagePath = "";
  final picker = ImagePicker();


  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mon profil'),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
        ),
        body: Container(
            child: Column(
                children: [
                  Container(
                    color: Colors.deepPurple,
                    padding: EdgeInsets.all(15),
                    width: double.infinity,
                    child: FutureBuilder<UserProfil>(
                      future: futureUser,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: <Widget>[
                              Container(
                                child:
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(Colors.black)),
                                  onPressed: () async {
                                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                    // getImage à été remplacé par pickImage ?
                                    if (pickedFile != null) {
                                      setState(() {
                                        imagePath = pickedFile.path;
                                      });
                                      // Si l'image choisi n'est pas égale à null, fait un setState de imagePath = pickedFile.path;
                                    }
                                  },
                                  child: Text('Choisi une photo'),
                                ),
                              ),
                              imagePath != "" ?
                              // Affichage de l'image
                              Container(
                                color: Colors.deepPurple,
                                //width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Image.file(File(imagePath)),
                              )
                                  : Container(),

                              Container(
                                child: Text(snapshot.data!.firstName + snapshot.data!.lastName),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        // By default, show a loading spinner.
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ],
            ),
        ),
    );
  }

  Future<void> getUserInfos() async {
    final response = await http.get(
      Uri.parse('http://k7-stories.com/api/users/28'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {

      // If the server did return a 200,
      // then parse the JSON.
      Map map = json.decode(response.body);
      setState(() {
        user = User(map);
        log(user.firstName);
        log(user.lastName);
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
