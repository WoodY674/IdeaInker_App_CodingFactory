import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:thebestatoo/Pages/sideBar.dart';


import '../Classes/Salon.dart';
import '../Classes/ShopMap.dart';
import 'main.dart';

final String url = "http://ideainker.fr/api/salons";

List<ShopMap> parseShop(String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var salons = list.map((e) => ShopMap.fromJson(e)).toList();
  return salons;
}

Future<List<ShopMap>> fetchShop() async {
  final http.Response response = await http.get(Uri.parse(url));
  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return Salon.fromJson(jsonDecode(response.body));
    print(response.body);
    return compute(parseShop,response.body);
  } else {
    print("marche pas");
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}

class MyMap extends StatelessWidget {
  const MyMap({Key? key}) : super(key: key);
  static String route = 'map';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyGoogleMap(),
    );
  }
}

class MyGoogleMap extends StatefulWidget {
  const MyGoogleMap({Key? key}) : super(key: key);

  @override
  _MyGoogleMapState createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  late Future<List<ShopMap>> futureShop;

  List<ShopMap> parseShop(String responseBody){
    var list = json.decode(responseBody) as List<dynamic>;
    var salons = list.map((e) => ShopMap.fromJson(e)).toList();
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
    List<ShopMap> shopsMarkers = parseShop(googleOffices.body.toString());
    setState(() {
      _markers.clear();
      for (final office in shopsMarkers) {
        final marker = Marker(
          markerId: MarkerId("${office.id}"),
          position: LatLng(double.parse(office.latitude), double.parse(office.longitude)),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address + "\n" + office.zip_code + " " + office.city,
          ),
        );
        _markers["${office.id}"] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    CameraPosition _initialCameraPosition = const CameraPosition(target: LatLng(20.5937, 78.9629));
    GoogleMapController googleMapController;

    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/IdeaInkerBanderole.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
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
      ),
    );
  }
}