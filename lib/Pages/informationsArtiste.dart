library toggle_bar;
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thebestatoo/Classes/User.dart';

class InformationsArtiste extends StatelessWidget {
  final dynamic users;
  const InformationsArtiste( this.users, {Key? key}) : super(key: key);

  TextStyle _style(){
    return TextStyle(
        fontWeight: FontWeight.bold
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),

              Text("Surnom"),
              SizedBox(height: 4,),
              Text(users.pseudo!, style: _style(),),
              Divider(color: Colors.deepPurple,),
              SizedBox(height: 16,)
            ],
          ),
        )
      ],
    );
  }
}
