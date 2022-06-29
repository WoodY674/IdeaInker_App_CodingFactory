import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

final String url = urlSite + "post";

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
  CreatedBy? createdBy;

  Posts(
      {this.id, this.content, this.createdAt, this.image, this.createdBy});

  Posts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    createdAt = json['createdAt'];
    image = json['image'] != null ? new Images.fromJson(json['image']) : null;
    createdBy = json['created_by'] != null
        ? new CreatedBy.fromJson(json['created_by'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy!.toJson();
    }
    return data;
  }
}

class Images {
  int? id;
  String? imageName;
  String? updatedAt;
  String? imagePath;

  Images({this.id, this.imageName, this.updatedAt, this.imagePath});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageName = json['imageName'];
    updatedAt = json['updatedAt'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imageName'] = this.imageName;
    data['updatedAt'] = this.updatedAt;
    data['imagePath'] = this.imagePath;
    return data;
  }
}

class CreatedBy {
  int? id;
  String? email;
  String? lastName;
  String? firstName;
  String? address;
  Null? zipCode;
  String? city;
  Null? birthday;
  String? createdAt;
  String? pseudo;
  Null? profileImage;

  CreatedBy(
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

  CreatedBy.fromJson(Map<String, dynamic> json) {
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