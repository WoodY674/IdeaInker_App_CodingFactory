library toggle_bar;
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thebestatoo/Classes/Shop.dart';
import 'package:thebestatoo/Classes/User.dart';

class InformationsSalon extends StatelessWidget {
  final dynamic user;
  const InformationsSalon( this.user, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Nom : " + user.pseudo!)
      ],
    );
  }
}
