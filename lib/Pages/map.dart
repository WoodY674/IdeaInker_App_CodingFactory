import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


import '../Classes/Salon.dart';

final String url = "http://k7-stories.com/api/salons";

List<Shop> parseShop(String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var salons = list.map((e) => Shop.fromJson(e)).toList();
  return salons;
}

Future<List<Shop>> fetchShop() async {
  final http.Response response = await http.get(Uri.parse(url));

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
  final int? salon_image_id;
  final String address;
  final String zip_code;
  final String city;
  final String created_at;
  final String? updated_at;
  final String? deleted_at;
  final String name;
  final String? coordinateStore;
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
    required this.updated_at,
    required this.deleted_at,
    required this.name,
    required this.coordinateStore,
    required this.latitude,
    required this.longitude,
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
    data['updatedAt'] = this.updated_at;
    data['deletedAt'] = this.deleted_at;
    data['name'] = this.name;
    data['coordinateStore'] = this.coordinateStore;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class MyMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyGoogleMap(),
    );
  }
}

class MyGoogleMap extends StatefulWidget {
  @override
  _MyGoogleMapState createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  late Future<List<Shop>> futureShop;

  List<Shop> parseShop(String responseBody){
    var list = json.decode(responseBody) as List<dynamic>;
    var salons = list.map((e) => Shop.fromJson(e)).toList();
    return salons;
  }

  @override
  void initState() {
    super.initState();
    futureShop = fetchShop();
  }

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices =  await http.get(Uri.parse(url));
    List<Shop> shopsMarkers = parseShop(googleOffices.body.toString());
    print(shopsMarkers);
    setState(() {
      _markers.clear();
      for (final office in shopsMarkers) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(double.parse(office.latitude), double.parse(office.longitude)),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    CameraPosition _initialCameraPosition = CameraPosition(target: LatLng(20.5937, 78.9629));
    GoogleMapController googleMapController;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _initialCameraPosition ,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: _onMapCreated,
              markers: _markers.values.toSet(),
            ),
          ],
        ),
      ),
    );
  }
}