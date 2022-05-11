import 'package:flutter/material.dart';

class InputField extends StatelessWidget{
  const InputField({
    Key? key ,
  }) : super(key: key);
  @override

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30 ),
      decoration: BoxDecoration(
        color: Colors.white),
      child: SafeArea(
        child: Row(
          children: [
              SizedBox(width: 100),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Type message',
                    border: InputBorder.none
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}