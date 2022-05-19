library toggle_bar;
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thebestatoo/Classes/User.dart';

class ArtistesLies extends StatelessWidget {
  final dynamic users;
  const ArtistesLies( this.users, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Identité : " + users.firstName! + users.lastName!)
      ],
    );
  }
}
