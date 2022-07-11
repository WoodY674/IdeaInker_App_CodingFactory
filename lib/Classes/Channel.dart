import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../main.dart';
import 'User.dart';

final String url = urlSite +"channel";
List<Channel> parseChannel(String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var channels = list.map((e) => Channel.fromJson(e)).toList();
  print(channels);
  return channels;
}



Future<List<Channel>> fetchChannel() async {
  final preferences = await StreamingSharedPreferences.instance;
  final token = preferences.getString('token', defaultValue: '').getValue();
  final http.Response response = await http.get(Uri.parse(url),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return Salon.fromJson(jsonDecode(response.body));
    print(token);
    print(response.body);
    return compute(parseChannel,response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.

    print('Connection Failed');
    print(response.statusCode);
    print(url);
    throw Exception(response.statusCode);
  }
}

class Channel {
  int? id;
  List? usersInside;
  List? messages;


  Channel(
      {
        this.id,
        this.usersInside,
        this.messages
      });

  factory Channel.fromJson(Map<String, dynamic> json) {
    print(json);
    return Channel(
      id: json["id"],
      usersInside: json["usersInside"],
      messages: json["messages"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['usersInside'] = this.usersInside;
    data['messages'] = this.messages;

    return data;
  }
}