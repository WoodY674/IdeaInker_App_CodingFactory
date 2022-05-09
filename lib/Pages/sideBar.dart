import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:thebestatoo/Pages/profil.dart';
import 'home.dart';
import 'main.dart';
import 'map.dart';
import 'menu.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

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


class SideBar extends StatelessWidget {
  late Future<UserProfil> futureUser = fetchUser();
  @override
  Widget build(BuildContext context) {
    return PreferenceBuilder<String>(
        preference: preferences.getString('token', defaultValue: ''),
        builder: (context, String tokenPref) {
          return Drawer(
              child: FutureBuilder<UserProfil>(
                  future: futureUser,
                  builder: (BuildContext context, AsyncSnapshot<UserProfil> snapshot) {
                    if (snapshot.hasData) {
                      UserProfil? user = snapshot.data;
                      return ListView(
                        // Remove padding
                        padding: EdgeInsets.zero,
                        children: [
                          UserAccountsDrawerHeader(
                            accountName: Text(user!.lastName + " " + user.firstName),
                            accountEmail: Text(user.email),
                            currentAccountPicture: user.email != '' ? const CircleAvatar(
                              backgroundImage: AssetImage("assets/noProfile.png"),
                            ):const CircleAvatar(
                              backgroundImage: AssetImage("assets/noProfile.png"),
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.deepPurple,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/logoProfile.jpg')),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.home),
                            title: Text('Accueil'),
                            onTap: () {Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const Home()));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.map),
                            title: Text('Carte'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const MyMap()));
                            },
                          ),
                          tokenPref != '' ? ListTile(
                            leading: Icon(Icons.verified_user),
                            title: Text('Mon Profil'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const Menu()));
                            },
                          ): Text(''),
                          const Divider(),
                          tokenPref != '' ? ListTile(
                            title: const Text('Se déconnecter'),
                            leading: const Icon(Icons.login_outlined),
                            onTap: () {
                              Disconnect();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Home()));
                            },
                          ): ListTile(
                            title: const Text('Se Connecter'),
                            leading: const Icon(Icons.login_outlined),
                            onTap: () {Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const Profil()));
                            },
                          ),
                        ],
                      );
                    } else {
                      return ListView(
                        // Remove padding
                        padding: EdgeInsets.zero,
                        children: [
                          const UserAccountsDrawerHeader(
                            accountName: Text(''),
                            accountEmail: Text(''),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage('assets/logoProfile.jpg')),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.home),
                            title: Text('Accueil'),
                            onTap: () {Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const Home()));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.map),
                            title: Text('Carte'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const MyMap()));
                            },
                          ),
                          tokenPref != '' ? ListTile(
                            leading: Icon(Icons.verified_user),
                            title: Text('Mon Profil'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const Menu()));
                            },
                          ): Text(''),
                          const Divider(),
                          tokenPref != '' ? ListTile(
                            title: const Text('Se déconnecter'),
                            leading: const Icon(Icons.login_outlined),
                            onTap: () {
                              Disconnect();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Home()));
                            },
                          ): ListTile(
                            title: const Text('Se Connecter'),
                            leading: const Icon(Icons.login_outlined),
                            onTap: () {Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const Profil()));
                            },
                          ),
                        ],
                      );
                    }
                  }
              )
          );
        }
    );
  }
}