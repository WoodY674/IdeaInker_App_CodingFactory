import 'dart:convert';
import 'dart:developer';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class CreateAvis extends StatefulWidget {
  static String route = 'register';
  const CreateAvis({Key? key}) : super(key: key);

  @override
  _CreateAvis createState() => _CreateAvis();
}

class _CreateAvis extends State<CreateAvis> {
  late double stars = 0;
  TextEditingController commentController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donnez-nous votre avis'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[

            Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Laisser un commentaire',
                  ),
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
                    CreateAvis(stars, commentController.text);
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

  }
  Future<void> CreateAvis(double star, String comment) async {
    final response = await http.post(
      Uri.parse('http://ideainker.fr/api/notices'),// route pour laisser un avis
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "stars": star.toString(),
        "comment": comment,
        "userNoted": "api/users/29",
        "userNoting": "api/users/6",
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
    }
  }
}
