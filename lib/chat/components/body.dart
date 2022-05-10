import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thebestatoo/chat/components/inputFieldController.dart';
import 'package:thebestatoo/chat/models/chatMessage.dart';

class Body extends StatelessWidget {

  
  @override
  Widget build (BuildContext context){
    return Column(
        children: [
          ChatMessage(message: '', sender: ''),
          const MyCustomInput(),
        ]
    );
  }
}


class Message extends StatelessWidget{
  const Message ({
    Key? key,
    required this.message,
  }) :super(key : key);

  final ChatMessage message;
  


 @override
  Widget build(BuildContext context) {
    return Container();
  }
}


// StreamBuilder(
// initialData: 'Loading...',
// //stream: streamMessages,
// builder: (context, snapshot) {
// return Row(
// mainAxisAlignment: MainAxisAlignment.end,
// children: [
// Container(
// margin: const EdgeInsets.only(top: 10),
// padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// decoration:BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(40)) ,
// child: Text(
// //message.text,
// 'bonjour',
// //snapshot.data.toString(),
// style: const TextStyle(color: Colors.white),
// ),
// ),
//
// ],
// );
// },
//
// );


