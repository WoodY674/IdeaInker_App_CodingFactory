import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Pages/main.dart';

Future<User> fetchUser() async {
  final token = preferences.getString('token', defaultValue: '').getValue();
  final response = await http
      .get(Uri.parse(urlSite + 'me'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return User.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class User {
  int? id;
  String? email;
  List<String>? roles;
  String? password;
  String? lastName;
  String? firstName;
  String? zipCode;
  String? city;
  String? birthday;
  String? createdAt;
  String? deletedAt;
  List<String>? messages;
  List<String>? salons;
  String? profileImage;
  List<String>? posts;
  String? pseudo;
  String? userIdentifier;
  String? username;
  String? salt;
  String? adress;

  User(
      {this.id,
        this.email,
        this.roles,
        this.password,
        this.lastName,
        this.firstName,
        this.zipCode,
        this.city,
        this.birthday,
        this.createdAt,
        this.deletedAt,
        this.messages,
        this.salons,
        this.profileImage,
        this.posts,
        this.pseudo,
        this.userIdentifier,
        this.username,
        this.salt,
        this.adress});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    roles = json['roles'].cast<String>();
    password = json['password'];
    lastName = json['lastName'];
    firstName = json['firstName'];
    zipCode = json['zipCode'];
    city = json['city'];
    birthday = json['birthday'];
    createdAt = json['createdAt'];
    deletedAt = json['deletedAt'];
    messages = json['messages'].cast<String>();
    salons = json['salons'].cast<String>();
    profileImage = json['profileImage'];
    posts = json['posts'].cast<String>();
    pseudo = json['pseudo'];
    userIdentifier = json['userIdentifier'];
    username = json['username'];
    salt = json['salt'];
    adress = json['adress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['roles'] = this.roles;
    data['password'] = this.password;
    data['lastName'] = this.lastName;
    data['firstName'] = this.firstName;
    data['zipCode'] = this.zipCode;
    data['city'] = this.city;
    data['birthday'] = this.birthday;
    data['createdAt'] = this.createdAt;
    data['deletedAt'] = this.deletedAt;
    data['messages'] = this.messages;
    data['salons'] = this.salons;
    data['profileImage'] = this.profileImage;
    data['posts'] = this.posts;
    data['pseudo'] = this.pseudo;
    data['userIdentifier'] = this.userIdentifier;
    data['username'] = this.username;
    data['salt'] = this.salt;
    data['adress'] = this.adress;
    return data;
  }
}