import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'dart:convert';

import '../../main.dart';


final String url = urlSite +"messages/";

List<ChatMessage> parseChatMessage(String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var messages = list.map((e) => ChatMessage.fromJson(e)).toList();
  return messages;
}
Future<List<ChatMessage>> fetchChatMessage(channelId) async {
  final preferences = await StreamingSharedPreferences.instance;
  final token = preferences.getString('token', defaultValue: '').getValue();
  final http.Response response = await http.get(Uri.parse(url + channelId.toString()),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('response body :');
    print(response.body);
    print(channelId);
    return compute(parseChatMessage,response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

final token = preferences.getString('token', defaultValue: '').getValue();
Future<http.Response> createMessage(String message, channelId) {
  print('message in chatMessage');
  print(message);
  print(channelId);
  return http.post(Uri.parse(url + channelId.toString()),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer $token",
    },
    body: jsonEncode(<String, String>{
      'message': message,
      'recipient': '48',
      'channel' : channelId.toString(),
    }),
  );
}

class ChatMessage{

  String? message;
  String? idRecipient;
  int? id;

  ChatMessage({
    this.message,
    this.idRecipient,
    this.id,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    print(json);
    return ChatMessage(
      id: json["id"],
      idRecipient: json["recipient"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['recipient'] = this.idRecipient;
    data['message'] = this.message;

    return data;
  }

}


