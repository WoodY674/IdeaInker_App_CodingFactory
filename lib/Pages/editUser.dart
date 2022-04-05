import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EditUser extends StatefulWidget {
  static String route = 'editUser';
  const EditUser({Key? key}) : super(key: key);

  @override
  _EditUser createState() => _EditUser();
}

class _EditUser extends State<EditUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Text("A VOUS DE JOUER !!!"),
    );
  }
}
