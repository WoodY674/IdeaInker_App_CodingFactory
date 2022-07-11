import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../Classes/User.dart';
import '../main.dart';

class CreateAvisArtist extends StatefulWidget {
  static String route = 'register';
  final dynamic id;
  const CreateAvisArtist(this.id,{Key? key}) : super(key: key);

  @override
  _CreateAvisArtist createState() => _CreateAvisArtist();
}

class _CreateAvisArtist extends State<CreateAvisArtist> {
  var rating = 0.0;
  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Future<User> futureUser;

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
      body: FutureBuilder<User>(
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
                          child: SmoothStarRating(
                            rating: rating,
                            isReadOnly: false,
                            size: 50,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star_border,
                            color: Colors.yellow,
                            borderColor: Colors.deepPurple,
                            starCount: 5,
                            allowHalfRating: false,
                            spacing: 2.0,
                            onRated: (value) {
                              setState(() {
                                rating = value;
                              });
                            },
                          ) ,
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
                              CreateAvis(rating, commentController.text, snapshot.data!.id!);
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
      Uri.parse(urlSite + 'notice/'),// route pour laisser un avis
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "stars": star.toString(),
        "comment": comment,
        "user_noted": widget.id.toString(),
        "user_noting": idUser.toString(),
      }),
    );
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
      print(response.body);
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
