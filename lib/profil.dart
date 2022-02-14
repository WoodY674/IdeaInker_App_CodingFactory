import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'createaccount.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _Profil createState() => _Profil();
}

class _Profil extends State<Profil> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(child:
  SafeArea(
    child: Center(
      child: ListView(
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
            child: CupertinoTextField(
              controller: emailController,
              prefix: Icon(CupertinoIcons.person),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: CupertinoTextField(
              controller: passwordController,
            ),
          ),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                },
              )
          ),
          Row(
            children: <Widget>[
              const Text('Does not have account?'),
              CupertinoButton(
                child: const Text(
                  'Create an account',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context)=> const CreateAccount())
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