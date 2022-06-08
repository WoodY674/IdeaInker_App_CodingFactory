library toggle_bar;
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thebestatoo/Classes/Shop.dart';
import 'package:thebestatoo/Classes/User.dart';

class InformationsSalon extends StatelessWidget {
  final dynamic user;
  const InformationsSalon( this.user, {Key? key}) : super(key: key);

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

              Text("Nom"),
              SizedBox(height: 4,),
              Text(user.firstName!, style: _style(),),
              Divider(color: Colors.deepPurple,),
              SizedBox(height: 16,)
            ],
          ),
        )
      ],
    );
  }
}
