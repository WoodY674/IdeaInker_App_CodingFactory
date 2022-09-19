import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../main.dart';

final String url = urlSite +"channel/";
List<Channel> parseChannel(String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var channels = list.map((e) => Channel.fromJson(e)).toList();
  return channels;
}



Future<List<Channel>> fetchChannel(userId) async {
  final preferences = await StreamingSharedPreferences.instance;
  final token = preferences.getString('token', defaultValue: '').getValue();
  final http.Response response = await http.get(Uri.parse(url + userId.toString()),
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
    throw Exception(response.statusCode);
  }
}

class Channel {
  int? id;
  List? usersInside;
  String? message;


  Channel(
      {
        this.id,
        this.usersInside,
        this.message
      });

  factory Channel.fromJson(Map<String, dynamic> json) {
    print(json);
    return Channel(
      id: json["id"],
      usersInside: json["user_inside"],
      message: json["last_message"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_inside'] = this.usersInside;
    data['last_message'] = this.message;

    return data;
  }
}