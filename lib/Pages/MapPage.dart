import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:thebestatoo/Pages/ProfilShopPage.dart';
import 'package:thebestatoo/Pages/SideBarPage.dart';
import '../Classes/Shop.dart';
import 'Admin/ListShopAdmin.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);
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
  late Future<List<Shop>> futureShop;

  @override
  void initState() {
    super.initState();
    futureShop = fetchShop();
  }

  final Map<String, Marker> _markers = {};
  ///Retourne la liste des shops sous forme de points sur la carte
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices =  await http.get(Uri.parse(url));
    List<Shop> shopsMarkers = parseShop(googleOffices.body.toString());
    setState(() {
      _markers.clear();
      for (final office in shopsMarkers) {
        final marker = Marker(
          markerId: MarkerId("${office.id}"),
          position: LatLng(double.parse(office.latitude!), double.parse(office.longitude!)),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address! + " " + office.zipCode! + " " + office.city!,
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ProfilShopPage(office.id)));
            }
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
      drawer: SideBarPage(),
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