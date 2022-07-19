import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:thebestatoo/Pages/Admin/ProfilShopAdmin.dart';
import 'package:thebestatoo/Pages/ProfilArtistePage.dart';
import 'package:thebestatoo/Pages/ProfilShopPage.dart';
import 'package:thebestatoo/Pages/ProfilUserPage.dart';
import 'package:thebestatoo/Pages/Admin/ListShopAdmin.dart';
import 'package:thebestatoo/Pages/listShopUsers.dart';
import 'package:thebestatoo/Pages/LoginPage.dart';
import 'package:thebestatoo/Pages/ChannelPage.dart';
import '../Classes/Shop.dart';
import '../Classes/User.dart';
import 'Admin/ProfileArtisteAdmin.dart';
import 'HomePage.dart';
import '../main.dart';
import 'MapPage.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class SideBarPage extends StatelessWidget {
  late Future<User> futureUser = fetchUser();
  late Future<Shop> futureShop;
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
                            currentAccountPicture: user.profileImage != null ?  CircleAvatar(
                              backgroundImage: NetworkImage(urlImage + user.profileImage!.imagePath!.toString()),
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
                                MaterialPageRoute(builder: (context) => const HomePage()));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.map),
                            title: Text('Carte'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const MapPage()));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.chat_rounded),
                            title: Text('Messages'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ChannelPage(user.id, user.pseudo)));
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
                                MaterialPageRoute(builder: (context) => ChannelPage(user.id, user.pseudo)));
                            },
                          ):Container(),
                          user.roles![0] == "ROLE_SHOP" ?
                          ListTile(
                            leading: Icon(Icons.verified_user),
                            title: Text('Mon Profil'),
                            onTap: (){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ProfilSalonAdmin(user.salons![0].id)));
                            },
                          ):Container(),
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
                                MaterialPageRoute(builder: (context) => const ProfilUserPage()));
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
                                  MaterialPageRoute(builder: (context) => const HomePage()));
                            },
                          ): ListTile(
                            title: const Text('Se Connecter'),
                            leading: const Icon(Icons.login_outlined),
                            onTap: () {Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()));
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
                                MaterialPageRoute(builder: (context) => const HomePage()));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.map),
                            title: Text('Carte'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const MapPage()));
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.shop),
                            title: Text('Liste des shops'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const ListShopUsers()));
                            },
                          ),
                          tokenPref != '' ? ListTile(
                            leading: Icon(Icons.verified_user),
                            title: Text('Mon Profil'),
                            onTap: (){Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const ProfilUserPage()));
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
                                  MaterialPageRoute(builder: (context) => const HomePage()));
                            },
                          ): ListTile(
                            title: const Text('Se Connecter'),
                            leading: const Icon(Icons.login_outlined),
                            onTap: () {Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()));
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