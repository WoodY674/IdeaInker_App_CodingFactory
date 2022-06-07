import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../main.dart';

final String url = urlSite +"salons";
List<Shop> parseShop(String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var salons = list.map((e) => Shop.fromJson(e)).toList();
  print(salons);
  return salons;
}

Future<List<Shop>> fetchShop() async {
  print(url);

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
  final int id;
  final int? manager_id;
  final String? salon_image_id;
  final String address;
  final String zip_code;
  final String city;
  final String created_at;
  final String name;
  final String latitude;
  final String longitude;

  const Shop({
    required this.id,
    required this.manager_id,
    required this.salon_image_id,
    required this.address,
    required this.zip_code,
    required this.city,
    required this.created_at,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    print(json);
    return Shop(
      id: json["id"],
      manager_id: json["manager"],
      salon_image_id: json["salonImage"],
      address: json["address"],
      zip_code: json["zipCode"],
      city: json["city"],
      name: json["name"],
      created_at: json["createdAt"],
      latitude: json["latitude"],
      longitude: json["longitude"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['manager'] = this.manager_id;
    data['salonImage'] = this.salon_image_id;
    data['address'] = this.address;
    data['zipCode'] = this.zip_code;
    data['city'] = this.city;
    data['createdAt'] = this.created_at;
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}