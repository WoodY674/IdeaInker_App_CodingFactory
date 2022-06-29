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
    return ListView(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),

              Text("Pseudo"),
              SizedBox(height: 4,),
              Text(users.pseudo!, style: _style(),),
              Divider(color: Colors.deepPurple,),
              SizedBox(height: 16,)
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),

              Text("Prénom"),
              SizedBox(height: 4,),
              Text(users.firstName!, style: _style(),),
              Divider(color: Colors.deepPurple,),
              SizedBox(height: 16,)
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),

              Text("Nom"),
              SizedBox(height: 4,),
              Text(users.lastName!, style: _style(),),
              Divider(color: Colors.deepPurple,),
              SizedBox(height: 16,)
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),

              Text("Adresse"),
              SizedBox(height: 4,),
              Text(users.address!, style: _style(),),
              Divider(color: Colors.deepPurple,),
              SizedBox(height: 16,)
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),

              Text("Ville"),
              SizedBox(height: 4,),
              Text(users.city!, style: _style(),),
              Divider(color: Colors.deepPurple,),
              SizedBox(height: 16,)
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),

              Text("Code Postal"),
              SizedBox(height: 4,),
              Text(users.zipCode ?? "", style: _style(),),
              Divider(color: Colors.deepPurple,),
              SizedBox(height: 16,)
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),

              Text("Date d'anniversaire"),
              SizedBox(height: 4,),
              Text(users.birthday ?? "", style: _style(),),
              Divider(color: Colors.deepPurple,),
              SizedBox(height: 16,)
            ],
          ),
        ),
      ],
    );
  }
}
