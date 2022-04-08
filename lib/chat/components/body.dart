import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thebestatoo/chat/components/inputFieldController.dart';
import 'package:thebestatoo/chat/models/chatMessage.dart';

class Body extends StatelessWidget {

  
  @override
  Widget build (BuildContext context){
    return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (context, index) => Message(message: chatMessages[index]),
              ),
          ),
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
    return StreamBuilder(
      initialData: 'Loading...',
      stream: streamMessages,
      builder: (context, snapshot) {
        return Row(
          mainAxisAlignment: message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: message.isSender ? BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(40)) : BoxDecoration(color: Colors.purple[300], borderRadius: BorderRadius.circular(40)),
              child: Text(
                message.text,
                //snapshot.data.toString(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            
          ],
      );
    },
     
    );
  }
}


