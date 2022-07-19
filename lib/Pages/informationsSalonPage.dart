library toggle_bar;
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thebestatoo/Classes/Shop.dart';
import 'package:thebestatoo/Classes/User.dart';

class InformationsSalon extends StatelessWidget {
  final dynamic shop;
  const InformationsSalon( this.shop, {Key? key}) : super(key: key);

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

              Text("Nom"),
              SizedBox(height: 4,),
              Text(shop.name!, style: _style(),),
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
              Text(shop.address!, style: _style(),),
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
              Text(shop.city!, style: _style(),),
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
              Text(shop.zipCode!, style: _style(),),
              Divider(color: Colors.deepPurple,),
              SizedBox(height: 16,)
            ],
          ),
        )
      ],
    );
  }
}
