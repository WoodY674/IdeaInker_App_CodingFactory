import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../main.dart';

final String url = urlSite +"salon/";
List<Shop> parseShop(String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var salons = list.map((e) => Shop.fromJson(e)).toList();
  return salons;
}

Future<Shop> fetchShopIndividual(idShop) async {
  final token = preferences.getString('token', defaultValue: '').getValue();
  final response = await http
      .get(Uri.parse('http://ideainker.fr' + idShop),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Shop.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<List<Shop>> fetchShop() async {

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
    return compute(parseShop,response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}

class Shop {
  int? id;
  String? name;
  String? address;
  String? zipCode;
  String? city;
  String? createdAt;
  String? updatedAt;
  String? latitude;
  String? longitude;
  SalonImage? salonImage;
  Manager? manager;

  Shop(
      {this.id,
        this.name,
        this.address,
        this.zipCode,
        this.city,
        this.createdAt,
        this.updatedAt,
        this.latitude,
        this.longitude,
        this.salonImage,
        this.manager});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    zipCode = json['zipCode'];
    city = json['city'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    salonImage = json['salon_image'] != null
        ? new SalonImage.fromJson(json['salon_image'])
        : null;
    manager =
    json['manager'] != null ? new Manager.fromJson(json['manager']) : null;
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
    if (this.salonImage != null) {
      data['salon_image'] = this.salonImage!.toJson();
    }
    if (this.manager != null) {
      data['manager'] = this.manager!.toJson();
    }
    return data;
  }
}

class SalonImage {
  int? id;
  String? imageName;
  String? updatedAt;
  String? imagePath;

  SalonImage({this.id, this.imageName, this.updatedAt, this.imagePath});

  SalonImage.fromJson(Map<String, dynamic> json) {
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

class Manager {
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

  Manager(
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

  Manager.fromJson(Map<String, dynamic> json) {
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