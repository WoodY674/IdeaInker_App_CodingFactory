import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../Classes/User.dart';
import 'main.dart';

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
                          child: RatingBar.builder(itemBuilder: (context,_)=>
                              Icon(Icons.star,color:Colors.amber),
                              itemSize: 30,
                              onRatingUpdate: (rating){
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
