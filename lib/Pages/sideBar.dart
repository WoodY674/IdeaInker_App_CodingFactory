import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:thebestatoo/Pages/ProfilArtiste.dart';
import 'package:thebestatoo/Pages/ProfilSalon.dart';
import 'package:thebestatoo/Pages/ProfilUser.dart';
import 'package:thebestatoo/Pages/Admin/listShopAdmin.dart';
import 'package:thebestatoo/Pages/listShopUsers.dart';
import 'package:thebestatoo/Pages/profil.dart';
import 'package:thebestatoo/Pages/ChannelPage.dart';
import 'ChannelPage.dart';
import '../Classes/User.dart';
import 'Admin/ProfilArtisteAdmin.dart';
import 'home.dart';
import '../main.dart';
import 'map.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class SideBar extends StatelessWidget {
  late Future<User> futureUser = fetchUser();
  @override
  Widget build(BuildContext context) {
    return PreferenceBuilder<String>(
        preference: preferences.getString('token', defaultValue: ''),
        builder: (context, String tokenPref) {
          return Drawer(
              child: FutureBuilder<User>(
                  future: futureUser,
                  builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                    if (snapshot.hasData) {
                      User? user = snapshot.data;
                      print(user!.roles![0]);
                      return ListView(
                        // Remove padding
                        padding: EdgeInsets.zero,
                        children: [
                          UserAccountsDrawerHeader(
                            accountName: Text(user.lastName! + " " + user.firstName!),
                            accountEmail: Text(user.email!),
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
                          ListTile(
                            leading: Icon(Icons.chat_bubble),
                            title: Text('Messages'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ChannelPage()));
                            },
                          ),
                          user.roles![0] == "ROLE_ADMIN" ?
                          ListTile(
                            leading: Icon(Icons.shop),
                            title: Text('Liste des shops'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const ListShopAdmin()));
                            },
                          ): ListTile(
                            leading: Icon(Icons.shop),
                            title: Text('Liste des shops'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const ListShopUsers()));
                            },
                          ),
                          user.roles![0] == "ROLE_ADMIN" ?
                          ListTile(
                            leading: Icon(Icons.chat_rounded),
                            title: Text('Messages'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ChannelPage()));
                            },
                          ):Container(),
                          user.roles![0] == "ROLE_SHOP" ?
                          ListTile(
                            leading: Icon(Icons.verified_user),
                            title: Text('Mon Profil'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ProfilSalon(user)));
                            },
                          )
                              :Container(),
                          user.roles![0] == "ROLE_ARTIST" ?
                          ListTile(
                            leading: Icon(Icons.verified_user),
                            title: Text('Mon Profil'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ProfilArtisteAdmin()));
                            },
                          )
                              :Container(),
                          user.roles![0] == "ROLE_USER" || user.roles![0] == "ROLE_ADMIN" ?
                          ListTile(
                            leading: Icon(Icons.verified_user),
                            title: Text('Mon Profil'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const ProfilUser()));
                            },
                          )
                          : Container(),
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
                                MaterialPageRoute(builder: (context) => const ProfilUser()));
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