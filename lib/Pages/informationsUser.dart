library toggle_bar;
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thebestatoo/Classes/User.dart';

class Informations extends StatelessWidget {
  final dynamic users;
  const Informations( this.users, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Surnom : " + users.pseudo!)
      ],
    );
  }
}
