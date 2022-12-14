import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thebestatoo/Classes/User.dart';
import 'package:thebestatoo/Pages/ProfilUserPage.dart';
import 'package:thebestatoo/main.dart';
import '../Classes/ImageTo64.dart';

class EditUserInformations extends StatefulWidget {
  static String route = 'editUser';
  const EditUserInformations({Key? key}) : super(key: key);

  @override
  _EditUserInformations createState() => _EditUserInformations();
}

class _EditUserInformations extends State<EditUserInformations> {
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  TextEditingController pseudoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  late User user;
  String imagePath = "";
  final picker = ImagePicker();
  File imageFile = File("");
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier mon Profil'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<User>(
          future: futureUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              pseudoController.text = snapshot.data!.pseudo.toString();
              firstNameController.text = snapshot.data!.firstName.toString();
              lastNameController.text = snapshot.data!.lastName.toString();
              emailController.text = snapshot.data!.email.toString();
              snapshot.data!.address != null ?
              addressController.text = snapshot.data!.address.toString() : addressController.text = "";
              snapshot.data!.zipCode != null ?
              zipCodeController.text = snapshot.data!.zipCode.toString() : zipCodeController.text = "";
              snapshot.data!.city != null ?
              cityController.text = snapshot.data!.city.toString(): cityController.text = "";
              snapshot.data!.birthday != null ?
              birthdayController.text = snapshot.data!.birthday.toString(): birthdayController.text = "";
              snapshot.data!.profileImage != null ?
                  imageController.text = snapshot.data!.profileImage!.id.toString() : imageController.text ="";
              return Form(
                  key: _formKey,
                  child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text( 'Modification de mon profil',
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
                            // getImage ?? ??t?? remplac?? par pickImage ?
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
                          // Si l'image choisi n'est pas ??gale ?? null, fait un setState de imagePath = pickedFile.path;
                        },
                        child: const Text("Supprimer la photo")
                    ),
                  ): Container(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: TextFormField(
                        controller: pseudoController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pseudo',
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
                    child: Center(
                      child: TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nom',
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
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Pr??nom',
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
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
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
                      controller: cityController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ville',
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
                                firstNameController.text,
                                lastNameController.text,
                                emailController.text,
                                addressController.text,
                                zipCodeController.text,
                                cityController.text,
                                birthdayController.text,
                                pseudoController.text,
                                fileInBase64,
                                snapshot.data!.id!,
                                imageController.text
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
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  /// Modifie les informations d'un compte sur l'API
  /// Toast affich?? en fonction du r??sultat de la requ??te (Succ??s/??chec)
  Future<void> editAccount(String firstName, String lastName, String email, String address, String zipCode, String city, String birthday, String pseudo, String image64, int idUser, String image) async {
    late Response response = http.Response("", 400);
    if(image64 != ""){
      response = await http.patch(
        Uri.parse(urlSite + 'users/' + idUser.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'pseudo': pseudo,
          'email': email,
          'last_name': lastName,
          'first_name': firstName,
          'zip_code': zipCode,
          'city': city,
          'address': address,
          'profile_image' : image64
        }),
      );
    }else{
      response = await http.patch(
        Uri.parse(urlSite + 'users/' + idUser.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'pseudo': pseudo,
          'email': email,
          'last_name': lastName,
          'first_name': firstName,
          'zip_code': zipCode,
          'city': city,
          'address': address,
          'profile_image' : image
        }),
      );
    }
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Fluttertoast.showToast(
          msg: "Profil mis a jour",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilUserPage()));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(
          msg: "Mise a jour Impossible",
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


