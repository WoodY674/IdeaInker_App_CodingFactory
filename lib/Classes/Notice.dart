import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

final String url = "http://ideainker.fr/api/notices";

List<Notice> parseNotice(String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var notices = list.map((e) => Notice.fromJson(e)).toList();
  return notices;
}

Future<List<Notice>> fetchNotice() async {
  final http.Response response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return Salon.fromJson(jsonDecode(response.body));
    return compute(parseNotice,response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}

class Notice {
  final int? id;
  final int stars;
  final String comment;
  final String userNoted;
  final String userNoting;

  const Notice({
    required this.id,
    required this.stars,
    required this.comment,
    required this.userNoted,
    required this.userNoting,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
        id: json["id"],
        stars: json["stars"],
        comment: json["comment"],
        userNoted: json["userNoted"],
        userNoting: json["userNoting"]
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stars'] = stars;
    data['comment'] = comment;
    data['userNoted'] = userNoted;
    data['userNoting'] = userNoting;
    return data;
  }
}