import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class AddShop extends StatefulWidget {
  static String route = 'addShop';
  const AddShop({Key? key}) : super(key: key);

  @override
  _AddShop createState() => _AddShop();
}

class _AddShop extends State<AddShop> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du salon'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            /*Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Ajout Salon de Tatouage',
                  style: TextStyle(fontSize: 20),
                )
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '',
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                child: ElevatedButton(
                  child: const Text('Register'),
                  onPressed: () {
                    createAccount(firstNameController.text, lastNameController.text,emailController.text,passwordController.text);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                  ),
                )
            ),*/
          ],
        ),
      ),
    );
  }
  Future<void> createAccount(String firstName, String lastName, String email, String password) async {
    final now = DateTime.now();
    final response = await http.post(
      Uri.parse('http://k7-stories.com/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'lastName': lastName,
        'firstName': firstName,
        'createdAt': now.toString(),
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Fluttertoast.showToast(
          msg: "Account created with Success!",
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
          msg: "Failed Create Account",
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
