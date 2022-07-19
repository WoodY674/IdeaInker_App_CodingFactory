import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thebestatoo/Classes/Shop.dart';
import 'package:thebestatoo/Classes/User.dart';
import 'package:thebestatoo/main.dart';
import '../Classes/ImageTo64.dart';
import 'Admin/ProfilShopAdmin.dart';

class EditShopInformations extends StatefulWidget {
  static String route = 'editShop';
  final dynamic shop;
  final dynamic id;
  const EditShopInformations(this.shop,this.id,{Key? key}) : super(key: key);

  @override
  _EditShopInformations createState() => _EditShopInformations();
}

class _EditShopInformations extends State<EditShopInformations> {
  late Shop futureShop;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureShop = widget.shop;
    nameController.text = futureShop.name!;
    addressController.text = futureShop.address!;
    zipCodeController.text = futureShop.zipCode!;
    cityController.text = futureShop.city!;
    if(futureShop.salonImage != null){
      imageController.text = futureShop.salonImage!.imagePath!;
    }else{
      imageController.text = "";
    }
  }

  late User user;
  String imagePath = "";
  final picker = ImagePicker();
  File imageFile = File("");
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modification'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child:
        Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text( 'Modification du profil de mon salon',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              imageFile.path != "" ?
              // Affichage de l'image
              CircleAvatar(
                backgroundImage: FileImage(imageFile),
                radius: 100,
              )
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
                        print(pickedFile);
                        if (pickedFile != null) {
                          setState(() {
                            imageFile = File(pickedFile.path);
                          });
                        }
                      }else{
                        Map<Permission, PermissionStatus> statuses = await [
                          Permission.photos,
                        ].request();
                        //print(statuses[Permission.photos]); print status accés photos
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
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: zipCodeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Code Postal',
                  ),
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
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: ElevatedButton(
                    child: const Text('Enregistrer'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        String fileInBase64 = "";
                        if(imageFile.path != ""){
                          fileInBase64 = imageTo64(imageFile);
                        }
                        editAccount(
                            nameController.text,
                            addressController.text,
                            zipCodeController.text,
                            cityController.text,
                            fileInBase64,
                            futureShop.id!,
                            widget.id
                        );
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

  /// Modifie les informations d'un compte sur l'API
  /// Toast affiché en fonction du résultat de la requête (Succès/Échec)
  Future<void> editAccount(String name, String address, String zipCode, String city, String image64, int idShop,int idUser) async {
    late Response response = http.Response("", 400);
    if(image64 != ""){
      response = await http.patch(
        Uri.parse(urlSite + 'salon/' + idShop.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'zip_code': zipCode,
          'city': city,
          'address': address,
          'salon_image' : image64
        }),
      );
    }else{
      response = await http.patch(
        Uri.parse(urlSite + 'salon/' + idShop.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'zip_code': zipCode,
          'city': city,
          'address': address,
          'salon_image' : imageController.text
        }),
      );
    }

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Fluttertoast.showToast(
          msg: "Modification réussie",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilShopAdmin(idUser)));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(
          msg: "Modification impossible",
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


