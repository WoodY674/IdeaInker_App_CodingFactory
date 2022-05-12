import 'package:flutter/material.dart';
import 'package:thebestatoo/Pages/Avis.dart';
import 'package:thebestatoo/Pages/ProfilUser.dart';
import 'package:thebestatoo/Pages/listAvis.dart';
import 'package:thebestatoo/Pages/posts.dart';
import 'package:thebestatoo/Pages/sideBar.dart';
import 'ProfilArtiste.dart';
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
              Image.asset('assets/admin.png'),
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
                    child: const Text('Profil Artiste/Salon'),
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
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: ElevatedButton(
                    child: const Text('Créer un post'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Posts()),
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
                    child: const Text('Liste des avis'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ListAvis()),
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