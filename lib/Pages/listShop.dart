import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'dart:io';
import '../Classes/Salon.dart';

final String url = "http://ideainker.fr/api/salons";

List<Shop> parseShop(String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var salons = list.map((e) => Shop.fromJson(e)).toList();
  return salons;
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
  final int? id;
  final int? manager_id;
  final String? salon_image_id;
  final String address;
  final String zip_code;
  final String city;
  final String created_at;
  final String? updated_at;
  final String? deleted_at;
  final String name;
  final String? coordinateStore;

  const Shop({
    required this.id,
    required this.manager_id,
    required this.salon_image_id,
    required this.address,
    required this.zip_code,
    required this.city,
    required this.created_at,
    required this.updated_at,
    required this.deleted_at,
    required this.name,
    required this.coordinateStore,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json["id"],
      manager_id: json["manager"],
      salon_image_id: json["salonImage"],
      address: json["address"],
      zip_code: json["zipCode"],
      city: json["city"],
      created_at: json["createdAt"],
      updated_at: json["updatedAt"],
      deleted_at: json["deletedAt"],
      name: json["name"],
      coordinateStore: json["coordinateStore"],
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
    data['updatedAt'] = this.updated_at;
    data['deletedAt'] = this.deleted_at;
    data['name'] = this.name;
    data['coordinateStore'] = this.coordinateStore;
    return data;
  }
}
class ListShop extends StatefulWidget {
  const ListShop({Key? key}) : super(key: key);
  static String route = 'listShop';

  @override
  _ListShop createState() => _ListShop();
}

class _ListShop extends State<ListShop> {
  late Future<List<Shop>> futureShop;
  late Salon salonToDelete;

  @override
  void initState() {
    super.initState();
    futureShop = fetchShop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des salons'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Shop>>(
          future: futureShop,
          builder: (BuildContext context, AsyncSnapshot<List<Shop>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    Shop currentSalon = snapshot.data![index];
                    return Card(
                      child: Column(
                        children: [
                          currentSalon.salon_image_id != "" ?
                          Image.asset('assets/IdeaInkerBanderole.png'):
                          Image.network(currentSalon.salon_image_id!),
                          ListTile(
                            title: Text(currentSalon.name),
                            subtitle: Text(currentSalon.address + ' ' + currentSalon.zip_code + ' ' + currentSalon.city),
                            trailing: IconButton(onPressed: () {
                              deleteShop(currentSalon.id);
                            }, icon: const Icon(Icons.delete)),
                            isThreeLine: true,
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }
      ),
    );
  }
  Future<void> deleteShop(int? id) async {
    log(id.toString());
    final responseSalon = await http.delete(
      Uri.parse('http://ideainker.fr/api/salons/'+id.toString()),
    );

    if (responseSalon.statusCode == 204) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      log("salon deleted with Success=");
      Fluttertoast.showToast(
          msg: "Salon deleted with Success!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        futureShop = fetchShop();
      });
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(
          msg: "Failed deleted Salon",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
}
