import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:thebestatoo/Classes/infosUser.dart';

class EditUser extends StatefulWidget {
  static String route = 'editUser';
  const EditUser({Key? key}) : super(key: key);


  @override
  _EditUser createState() => _EditUser();
}

class _EditUser extends State<EditUser> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  // faire une fonction qui fait une requête où on met notre id en dur pou récup nos infos
  late infosUser user;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text( 'Modification de mon profil',
              style: TextStyle(fontSize: 20),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: TextField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First Name',
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
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: adressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'City Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: zipCodeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Zip Code',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: birthdayController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Birthday',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                child: ElevatedButton(
                  child: const Text('Register'),
                  onPressed: () {
                    editAccount(
                        firstNameController.text,
                        lastNameController.text,
                        emailController.text,
                        passwordController.text,
                        adressController.text,
                        zipCodeController.text,
                        cityController.text,
                        birthdayController.text,
                    );
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                  ),
                )
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                child: ElevatedButton(
                  child: const Text('Get infos user'),
                  onPressed: () {
                    getUserInfos();
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

  Future<void> editAccount(String firstName, String lastName, String email, String password, String address, String zipCode, String city, String birthday) async {
    final response = await http.put(
      Uri.parse('http://k7-stories.com/api/users/28'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'lastName': lastName,
        'firstName': firstName,
        'zip code': zipCode,
        'city': city,
        'birthday': birthday,
        'address': address,
      }),
    );

    if (response.statusCode == 201) {
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
        Uri.parse('http://k7-stories.com/api/users/28'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {

        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        Map map = json.decode(response.body);
        setState(() {
           user = infosUser(map);
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


