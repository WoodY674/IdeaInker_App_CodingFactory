import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thebestatoo/main.dart';
import 'dart:io';
import '../Classes/CoordinatesStore.dart';
import '../Classes/ImageTo64.dart';
import '../Classes/Shop.dart';

class AddShopPage extends StatefulWidget {
  static String route = 'addShop';
  const AddShopPage({Key? key}) : super(key: key);

  @override
  _AddShopPage createState() => _AddShopPage();
}

class _AddShopPage extends State<AddShopPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  late CoordinatesStore coordinatesStore;
  String imagePath = "";
  final picker = ImagePicker();
  File imageFile = File("");
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du salon'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child:ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Ajout Salon de Tatouage',
                    style: TextStyle(fontSize: 20),
                  )
              ),
              imageFile.path != "" ?
              // Affichage de l'image
              Image.file(imageFile)
                  : Container(),
              Container(
                child:
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black)),
                    onPressed: () async {
                      if (await Permission.photos.request().isGranted) {
                        // Either the permission was already granted before or the user just granted it.
                        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                        // getImage à été remplacé par pickImage ?
                        if (pickedFile != null) {
                          setState(() {
                            imageFile = File(pickedFile.path);
                          });
                        }
                      }else{
                        Map<Permission, PermissionStatus> statuses = await [
                          Permission.photos,
                        ].request();
                      }
                    },
                    child: imageFile.path != "" ? // C'est le if
                    const Text("Modifier la photo")
                        : const Text("Ajouter une photo") // : = else
                ),
              ),
              imageFile.path != "" ?
              Container(
                child:
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black)),
                    onPressed: () {
                      setState(() {
                        imageFile = File("");
                      });
                      // Si l'image choisi n'est pas égale à null, fait un setState de imagePath = pickedFile.path;
                    },
                    child: const Text("Supprimer la photo")
                ),
              ): Container(),
              Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nom du salon',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez renseigner ce champ';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Adresse',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez renseigner ce champ';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Ville',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez renseigner ce champ';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  controller: zipCodeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Code Postal',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez renseigner ce champ';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: ElevatedButton(
                    child: const Text('Register'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        String fileInBase64 = "";
                        if(imageFile.path != ""){
                          fileInBase64 = imageTo64(imageFile);
                        }
                        addShop(nameController.text, addressController.text,cityController.text,zipCodeController.text,fileInBase64);
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ajoute un salon sur l'API
  /// Fait une requête de Geocoding vers un serveur tier pour récupérer la latitude/longitude avant la création du shop
  /// Toast affiché en fonction du résultat de la requête (Succès/Échec)
  Future<void> addShop(String name, String address, String city, String zipCode, String image64) async {
    final now = DateTime.now();
    GeoCode geoCode = GeoCode();
    final query = address + ", " + city + ", " + zipCode;
    try {
      Coordinates coordinates = await geoCode.forwardGeocoding(address: query);
      late Response responseSalon = http.Response("", 400);
      if(image64 != ""){
        responseSalon = await http.post(
          Uri.parse(urlSite + 'salon'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'address': address,
            'zip_code': zipCode,
            'city': city,
            'name': name,
            'latitude': coordinates.latitude.toString(),
            'longitude': coordinates.longitude.toString(),
            'salon_image': image64,
          }),
        );
      }else{
          responseSalon = await http.post(
          Uri.parse(urlSite + 'salon'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'address': address,
            'zip_code': zipCode,
            'city': city,
            'name': name,
            'latitude': coordinates.latitude.toString(),
            'longitude': coordinates.longitude.toString(),
          }),
        );
      }

      if (responseSalon.statusCode == 201) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        Fluttertoast.showToast(
            msg: "Salon ajouté",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.pop(context);
      }else{
        Fluttertoast.showToast(
            msg: "Création impossible",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }
    catch(e){
      Fluttertoast.showToast(
          msg: "Failed get Geolocalisation of shop",
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
