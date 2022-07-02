import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../main.dart';

Future<User> fetchUser() async {
  final token = preferences.getString('token', defaultValue: '').getValue();
  final response = await http
      .get(Uri.parse(urlSite + 'users/me'),
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
  String? address;
  Null? zipCode;
  String? city;
  Null? birthday;
  String? createdAt;
  String? pseudo;
  Null? profileImage;
  List<Salons>? salons;

  User(
      {this.id,
        this.email,
        this.roles,
        this.password,
        this.lastName,
        this.firstName,
        this.address,
        this.zipCode,
        this.city,
        this.birthday,
        this.createdAt,
        this.pseudo,
        this.profileImage,
        this.salons});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    roles = json['roles'].cast<String>();
    password = json['password'];
    lastName = json['lastName'];
    firstName = json['firstName'];
    address = json['address'];
    zipCode = json['zipCode'];
    city = json['city'];
    birthday = json['birthday'];
    createdAt = json['createdAt'];
    pseudo = json['pseudo'];
    profileImage = json['profile_image'];
    if (json['salons'] != null) {
      salons = <Salons>[];
      json['salons'].forEach((v) {
        salons!.add(new Salons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['roles'] = this.roles;
    data['password'] = this.password;
    data['lastName'] = this.lastName;
    data['firstName'] = this.firstName;
    data['address'] = this.address;
    data['zipCode'] = this.zipCode;
    data['city'] = this.city;
    data['birthday'] = this.birthday;
    data['createdAt'] = this.createdAt;
    data['pseudo'] = this.pseudo;
    data['profile_image'] = this.profileImage;
    if (this.salons != null) {
      data['salons'] = this.salons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Salons {
  int? id;
  String? name;
  String? address;
  String? zipCode;
  String? city;
  String? createdAt;
  String? updatedAt;
  String? latitude;
  String? longitude;
  Null? salonImage;

  Salons(
      {this.id,
        this.name,
        this.address,
        this.zipCode,
        this.city,
        this.createdAt,
        this.updatedAt,
        this.latitude,
        this.longitude,
        this.salonImage});

  Salons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    zipCode = json['zipCode'];
    city = json['city'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    salonImage = json['salon_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['zipCode'] = this.zipCode;
    data['city'] = this.city;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['salon_image'] = this.salonImage;
    return data;
  }
}