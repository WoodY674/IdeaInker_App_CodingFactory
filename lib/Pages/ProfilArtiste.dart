import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../Classes/User.dart';

Future<UserProfil> fetchUser() async {
  final preferences = await StreamingSharedPreferences.instance;
  final token = preferences.getString('token', defaultValue: '').getValue();
  print(token);
  print("coucou");
  final response = await http
      .get(Uri.parse('http://ideainker.fr/api/me'),
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
    },
  );

  print(response.statusCode);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print(response.body);
    print("dfghjfghj");
    return UserProfil.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class UserProfil {
  final int id;
  final String email;
  final String password;
  final String? adress;
  final String? zipCode;
  final String? city;
  final String lastName;
  final String firstName;
  final String? profileImage;
  final String? birthday;
  final String? pseudo;


  const UserProfil({
    required this.id,
    required this.email,
    required this.password,
    required this.adress,
    required this.zipCode,
    required this.city,
    required this.lastName,
    required this.firstName,
    required this.profileImage,
    required this.birthday,
    required this.pseudo,
  });

  factory UserProfil.fromJson(Map<String, dynamic> json) {
    return UserProfil(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      adress: json['adress'],
      zipCode: json['zipCode'],
      city: json['city'],
      lastName: json['lastName'],
      firstName: json['firstName'],
      profileImage: json['profileImage'],
      birthday: json['birthday'],
      pseudo: json['pseudo'],
    );
  }
}

class ProfilArtiste extends StatefulWidget {
  static String route = 'ProfilArtiste';

  const ProfilArtiste({Key? key}) : super(key: key);

  @override
  _ProfilArtiste createState() => _ProfilArtiste();
}

class _ProfilArtiste extends State<ProfilArtiste> {
  late User user;
  late Future<UserProfil> futureUser;
  late double stars = 0;

  late File imageFile = File("");
  final picker = ImagePicker();
  String image64 = "";


  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mon profil'),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
        ),
        body: Container(
            child: Column(
                children: [
                  Container(
                    color: Colors.deepPurple,
                    padding: EdgeInsets.all(15),
                    width: double.infinity,
                    child: FutureBuilder<UserProfil>(
                      future: futureUser,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data);
                          return ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: <Widget>[
                              imageFile.path != "" ?
                              // Affichage de l'image
                              Container(
                                color: Colors.deepPurple,
                                //width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Image.file(imageFile, width: 100, height: 100),
                              )
                                  : Container(),
                              Container(
                                child:
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>(Colors.black)),
                                  onPressed: () async {
                                    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                    if (pickedFile != null) {
                                      setState(() {
                                        imageFile = File(pickedFile.path);
                                        print(imageFile);
                                        List<int> fileInByte = imageFile.readAsBytesSync();
                                        String fileInBase64 = base64Encode(fileInByte);
                                        image64 = fileInBase64;
                                        print("base64 donne");
                                        print(image64);
                                      });
                                    }
                                  },
                                  child: imageFile.path != "" ? // C'est le if
                                      Text("Modifier la photo")
                                      : Text("Ajouter une photo") // : = else
                                ),
                              ),

                              Container(
                                child:
                                    imageFile.path != "" ?
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(Colors.black)),
                                    onPressed: () {
                                        setState(() {
                                          imageFile = File("");
                                        });
                                    },
                                    child: Text("Supprimer la photo")
                                ) : Container(),
                              ),

                              Container(
                                child:
                                imageFile.path != "" ?
                                ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(Colors.black)),
                                    onPressed: ()  {
                                    },
                                    child:
                                    Text("Enregistrer")
                                ) : Container(),
                              ),


                              Container(
                                child: Text(snapshot.data!.firstName + " " + snapshot.data!.lastName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 2,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              Container(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: RatingBar.builder(itemBuilder: (context,_)=>
                                        Icon(Icons.star,color:Colors.yellow),
                                        itemSize: 50,
                                        onRatingUpdate: (rating){
                                          print(rating);
                                          setState(() {
                                            stars = rating;
                                          });
                                        }) ,
                                  )
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        // By default, show a loading spinner.
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 25.0),
                    height: 125.0,
                    child: ListView(
                      // This next line does the trick.
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        Container(
                          width: 150.0,
                          margin: const EdgeInsets.only(right: 10.0, left: 5.0),
                          color: Colors.red,
                        ),
                        Container(
                          width: 150.0,
                          margin: const EdgeInsets.only(right: 10.0, left: 15.0),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
            ),
        ),
    );
  }
}