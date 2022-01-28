import 'package:thebestatoo/home.dart';
import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FindMyTattoo',
      routes: {},
      debugShowCheckedModeBanner: false,

      theme: ThemeData(

        primarySwatch: Colors.red,
      ),
      home: Home(),
    );
  }
}