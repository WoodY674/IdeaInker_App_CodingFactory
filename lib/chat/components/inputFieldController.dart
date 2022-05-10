// Define a custom Form widget.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thebestatoo/chat/models/chatMessage.dart';
import 'package:http/http.dart' as http;

class MyCustomInput extends StatefulWidget {
  const MyCustomInput({Key? key}) : super(key: key);

  @override
  _MyCustomInputState createState() => _MyCustomInputState();


}


class _MyCustomInputState extends State<MyCustomInput> {

  final myController = TextEditingController();

  String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE2NTIwODkyMDQsImV4cCI6MTY1MjExOTgwNCwicm9sZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJuYW1lIjoiYW50b2luZS1oYWxsZXJAb3V0bG9vay5mciJ9.kNlI_PZ7k0fhUXvKTHclM64_cBFxw-QoahMEqgY_KwsVUdtMnOIBpG6eKYSMmMbLj2fXxObnSpyFTK6ol38lGUdkVabBZx9T3zYLOcxluVL9gKIGqIv1hoQ3V1-T6R-Ke65tW_LRuGEJkKQDcjs8lBkG0PIy1edWMjPfi-SSklvHZ2Ad-Zus2mgANQDq6rwhtHpgyrjkTylmuyoVG6ftcs49kIH_qU_SOtDt_Y5PIwAfL2Mi7kxVFYdcPSavsornlGicXcnCe13pS-XR86ezjvBEcgz9PpoQcNm_F6HdvhNIYMHas8X8TEajvPtQyJlr4pjeTVLW_clTImFEEH7PQw';

  Future<http.Response> createMessage(String message) {
  print(message);
    return http.post(
      Uri.parse('http://localhost:8000/api/messages'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'message': message,
        'sendBy': 'http://localhost:8000/api/users/1',
        'recipient' : 'http://localhost:8000/api/users/1'
      }),
    );
  }

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
                //chatMessages.add(ChatMessage(text: myController.text, isSender: true));
                createMessage(myController.text);
                print(myController.text);
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