import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thebestatoo/Classes/User.dart';
import 'package:thebestatoo/main.dart';
import 'package:thebestatoo/Pages/sideBar.dart';
import '../Classes/Token.dart';
import 'createaccount.dart';
import 'home.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';


class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);
  static String route = 'profil';

  @override
  _Profil createState() => _Profil();
}

class _Profil extends State<Profil> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Token token;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/IdeaInkerBanderole.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child:Form(
          key: _formKey,
          child:ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-mail',
                  ),
                  key: const Key('email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez renseigner ce champ';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  key: const Key('password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez renseigner ce champ';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: ElevatedButton(
                    key: const Key('btn'),
                    child: const Text('Login'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        Login(emailController.text, passwordController.text);
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                    ),
                  )
              ),
              Row(
                children: <Widget>[
                  const Text('Does not have account?'),
                  TextButton(
                    child: const Text(
                      'Create an account',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreateAccount()),
                      );
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ),
      ),

    );
  }
  /*
  La fonction Login récupère l'email et le mot de passe de l'utilisateur.
  Elle attend ensuite la réponse da la requête Http post dans laquelle nous récupérons l'image de profil de l'utilisateur
  et son token d'authentification.
  Si nous recevons un code 200, un message confirmant notre connexion nous est envoyé "Login Success!"
  avant d'être renvoyé à la page d'accueil.
  Dans le cas d'une connexion échouée nous recevons le message "Failed Login".
  */
  /// Connecte un utilisateur
  /// Récupère l'URL de l'image et le token d'authentification
  /// Toast affiché en fonction du résultat de la requête (Succès/Échec)
  Future<void> Login(String email, String password) async {
    final response = await http.post(
      Uri.parse(urlImage + 'authentication_token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    WidgetsFlutterBinding.ensureInitialized();
    final preferences = await StreamingSharedPreferences.instance;
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Fluttertoast.showToast(
          msg: "Login Success!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Map map = json.decode(response.body);
      setState(() {
        token = Token(map);
      });
      preferences.setString('token', token.token);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(
          msg: "Failed Login",
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