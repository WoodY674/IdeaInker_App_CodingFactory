import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:thebestatoo/Pages/ProfilUser.dart';
import 'package:thebestatoo/Pages/sideBar.dart';
import 'ProfilArtiste.dart';
import 'addShop.dart';
import 'editUser.dart';
import 'listShop.dart';


class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);
  static String route = 'menu';

  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: ElevatedButton(
                    child: const Text('Mon Profil Utilisateur'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilUser()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                    ),
                  )
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: ElevatedButton(
                    child: const Text('Mon Profil Artiste'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilArtiste()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                    ),
                  )
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: ElevatedButton(
                    child: const Text('Modifier mon profil'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditUser()),
                      );
                      },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                    ),
                  )
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: ElevatedButton(
                    child: const Text('Ajouter salon de tatouage'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddShop()),
                      );
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                    ),
                  )
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: ElevatedButton(
                    child: const Text('Liste salons de tatouage'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ListShop()),
                      );
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
}