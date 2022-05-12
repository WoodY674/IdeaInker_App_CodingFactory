import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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

class CreateAvis extends StatefulWidget {
  static String route = 'register';
  const CreateAvis({Key? key}) : super(key: key);

  @override
  _CreateAvis createState() => _CreateAvis();
}

class _CreateAvis extends State<CreateAvis> {
  late double stars = 0;
  TextEditingController commentController = TextEditingController();
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
        title: const Text('Donnez-nous votre avis'),
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
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: TextFormField(
                          controller: commentController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Laisser un commentaire',
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
                        child: Align(
                          alignment: Alignment.center,
                          child: RatingBar.builder(itemBuilder: (context,_)=>
                              Icon(Icons.star,color:Colors.amber),
                              itemSize: 30,
                              onRatingUpdate: (rating){
                                print(rating);
                                setState(() {
                                  stars = rating;
                                });
                              }) ,
                        )
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                        child: ElevatedButton(
                          child: const Text('Soumettre un avis'),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              CreateAvis(stars, commentController.text, snapshot.data!.id);
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
  Future<void> CreateAvis(double star, String comment, int idUser) async {
    final response = await http.post(
      Uri.parse('http://ideainker.fr/api/notices'),// route pour laisser un avis
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "stars": star.toString(),
        "comment": comment,
        "userNoted": "api/users/29",
        "userNoting": "api/users/" + idUser.toString(),
      }),
    );
    log(response.body);
    if (response.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Fluttertoast.showToast(
          msg: "L'avis à bien été crée!",
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
          msg: "Echec de la création d'un avis",
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
