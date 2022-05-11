import 'package:flutter/material.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _Profil createState() => _Profil();
}

class _Profil extends State<Profil> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text("Profil"),
        )
    );
  }
}