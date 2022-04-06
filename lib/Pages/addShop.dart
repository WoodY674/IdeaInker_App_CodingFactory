import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:thebestatoo/Classes/Salon.dart';

class AddShop extends StatefulWidget {
  static String route = 'addShop';
  const AddShop({Key? key}) : super(key: key);

  @override
  _AddShop createState() => _AddShop();
}

class _AddShop extends State<AddShop> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  late Salon salon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du salon'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Ajout Salon de Tatouage',
                  style: TextStyle(fontSize: 20),
                )
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nom du salon',
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Adresse',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Ville',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: zipCodeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Code Postal',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                child: ElevatedButton(
                  child: const Text('Register'),
                  onPressed: () {
                    addShop(nameController.text, addressController.text,cityController.text,zipCodeController.text);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
  Future<void> addShop(String name, String address, String city, String zipCode) async {
    final now = DateTime.now();
    final responseSalon = await http.post(
      Uri.parse('http://k7-stories.com/api/salons'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'address': address,
        'zipCode': zipCode,
        'city': city,
        'createdAt': now.toString(),
        'name': name,
      }),
    );

    if (responseSalon.statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      log("salon creer");
      Map map = json.decode(responseSalon.body);
      setState(() {
        salon = Salon(map);
      });
      GeoCode geoCode = GeoCode();
      final query = salon.address + ", " + salon.city + ", " + salon.zip_code;
      try {
        Coordinates coordinates = await geoCode.forwardGeocoding(address: query);
        if(coordinates.latitude != null && coordinates.longitude != null){
          final responseCoordinate = await http.post(
            Uri.parse('http://k7-stories.com/api/coordinate_stores'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'company': salon.name,
              'latitude':coordinates.latitude.toString(),
              'longitude':coordinates.longitude.toString(),
              'salon': 'http://k7-stories.com/api/salons/' + salon.id.toString(),
            }),
          );
          if (responseCoordinate.statusCode == 201) {
            // If the server did return a 201 CREATED response,
            // then parse the JSON.
            log("coordinates creer");

            Fluttertoast.showToast(
                msg: "Coordinates added with Success!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
            );
            Navigator.pop(context);
          }else {
            // If the server did not return a 201 CREATED response,
            // then throw an exception.
            Fluttertoast.showToast(
                msg: "Failed Add Coordinates",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Failed Add Coordinates",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(
          msg: "Failed Add Shop",
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
