// Define a custom Form widget.
import 'package:flutter/material.dart';
import 'package:thebestatoo/chat/models/chatMessage.dart';

class MyCustomInput extends StatefulWidget {
  const MyCustomInput({Key? key}) : super(key: key);

  @override
  _MyCustomInputState createState() => _MyCustomInputState();
}


class _MyCustomInputState extends State<MyCustomInput> {

  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5 ),
      decoration: BoxDecoration(
        color: Colors.white),
      child: SafeArea(
        child: Row(
          children: [
            SizedBox(width: 100),
            Expanded(
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                  hintText: 'Type message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                chatMessages.add(ChatMessage(text: myController.text, isSender: true));
              },
              tooltip: 'Send',
              icon: Icon(Icons.send),
              //child: const Icon(Icons.text_fields),
            ),
          ],
        ),
      ),
    );
  }
}