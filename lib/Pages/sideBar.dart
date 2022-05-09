import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:thebestatoo/Pages/profil.dart';
import 'home.dart';
import 'main.dart';
import 'map.dart';
import 'menu.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PreferenceBuilder<String>(
        preference: preferences.getString('token', defaultValue: ''),
        builder: (context, String tokenPref) {
          return Drawer(
            child: ListView(
              // Remove padding
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text('Oflutter.com'),
                  accountEmail: Text('example@gmail.com'),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
                    ),
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
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
            ),
          );
        }
    );
  }
}