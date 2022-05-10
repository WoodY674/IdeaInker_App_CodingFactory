import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE2NTIwODkyMDQsImV4cCI6MTY1MjExOTgwNCwicm9sZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJuYW1lIjoiYW50b2luZS1oYWxsZXJAb3V0bG9vay5mciJ9.kNlI_PZ7k0fhUXvKTHclM64_cBFxw-QoahMEqgY_KwsVUdtMnOIBpG6eKYSMmMbLj2fXxObnSpyFTK6ol38lGUdkVabBZx9T3zYLOcxluVL9gKIGqIv1hoQ3V1-T6R-Ke65tW_LRuGEJkKQDcjs8lBkG0PIy1edWMjPfi-SSklvHZ2Ad-Zus2mgANQDq6rwhtHpgyrjkTylmuyoVG6ftcs49kIH_qU_SOtDt_Y5PIwAfL2Mi7kxVFYdcPSavsornlGicXcnCe13pS-XR86ezjvBEcgz9PpoQcNm_F6HdvhNIYMHas8X8TEajvPtQyJlr4pjeTVLW_clTImFEEH7PQw';


Future<ChatMessage> fetchChannel() async {
  final response = await http

      .get(Uri.parse('http://localhost:8000/api/messages/1'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return ChatMessage.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class ChatMessage extends StatefulWidget{



  @override
  _ChatMessageState createState() => _ChatMessageState();


  final String message;
  final String sender;

  ChatMessage({
    required this.message,
    required this.sender,
    Key? key,
  }) : super(key: key);






  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    print(json['message']);
    return ChatMessage(
      message: json['message'],
      sender: json['sendBy'],
    );
  }



}

class _ChatMessageState extends State<ChatMessage> {

  late Future<ChatMessage> futureChatMessage;

  @override
  void initState() {
    super.initState();
    futureChatMessage = fetchChannel();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<ChatMessage>(
      future: futureChatMessage,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data!.message);
          return Text(snapshot.data!.message);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}

// Stream <List<ChatMessage>> get streamMessages => Stream.value(
//   chatMessages.map((e) => ChatMessage(text: 'text', isSender: true)).toList()
// );
