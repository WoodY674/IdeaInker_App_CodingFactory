import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';


import '../../main.dart';


final String url = urlSite +"messages/";

List<ChatMessage> parseChatMessage(String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  list = list.reversed.toList();
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
    return compute(parseChatMessage,response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

final token = preferences.getString('token', defaultValue: '').getValue();
Future<http.Response> createMessage(String message, channelId) {
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
  SendBy? sendBy;

  ChatMessage({
    this.message,
    this.idRecipient,
    this.id,
    this.sendBy,
  });

  ChatMessage.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      message = json['message'];
      sendBy =
      json['send_by'] != null ? new SendBy.fromJson(json['send_by']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    if (this.sendBy != null) {
      data['send_by'] = this.sendBy!.toJson();
    }
    return data;
  }

}

class SendBy {
  int? id;
  String? email;
  String? lastName;
  String? firstName;
  Null? address;
  Null? zipCode;
  Null? city;
  Null? birthday;
  String? createdAt;
  String? pseudo;
  Null? profileImage;

  SendBy(
      {this.id,
        this.email,
        this.lastName,
        this.firstName,
        this.address,
        this.zipCode,
        this.city,
        this.birthday,
        this.createdAt,
        this.pseudo,
        this.profileImage});

  SendBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    lastName = json['lastName'];
    firstName = json['firstName'];
    address = json['address'];
    zipCode = json['zipCode'];
    city = json['city'];
    birthday = json['birthday'];
    createdAt = json['createdAt'];
    pseudo = json['pseudo'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['lastName'] = this.lastName;
    data['firstName'] = this.firstName;
    data['address'] = this.address;
    data['zipCode'] = this.zipCode;
    data['city'] = this.city;
    data['birthday'] = this.birthday;
    data['createdAt'] = this.createdAt;
    data['pseudo'] = this.pseudo;
    data['profile_image'] = this.profileImage;
    return data;
  }
}


