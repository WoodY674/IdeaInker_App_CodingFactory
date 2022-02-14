import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  static String route = 'register';
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccount createState() => _CreateAccount();
}

class _CreateAccount extends State<CreateAccount> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 20),
                )
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: CupertinoTextField(
                  controller: firstNameController,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: CupertinoTextField(
                controller: lastNameController,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: CupertinoTextField(
                controller: emailController,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: CupertinoTextField(
                obscureText: true,
                controller: passwordController,
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                child: CupertinoButton(
                  child: const Text('Register',style: TextStyle(color: Colors.black),),
                  onPressed: () {
                  },
                )
            ),
          ],
        ),
      ),
    );
  }
}
