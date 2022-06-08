import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

final String url = "http://ideainker.fr/api/" + "posts";

List<Posts> parsePosts(String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var salons = list.map((e) => Posts.fromJson(e)).toList();
  return salons;
}

Future<List<Posts>> fetchPosts() async {
  final http.Response response = await http.get(Uri.parse(url),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return Salon.fromJson(jsonDecode(response.body));
    return compute(parsePosts,response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}

class Posts {
  int? id;
  String? content;
  String? createdAt;
  Images? image;
  String? createdBy;

  Posts(
      {this.id, this.content, this.createdAt, this.image, this.createdBy});

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    createdAt = json['createdAt'];
    image = json['image'] != null ? new Images.fromJson(json['image']) : null;
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    data['createdBy'] = this.createdBy;
    return data;
  }
}

class Images {
  String? imagePath;

  Images({this.imagePath});

  Images.fromJson(Map<String, dynamic> json) {
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imagePath'] = this.imagePath;
    return data;
  }
}
