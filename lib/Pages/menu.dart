import 'package:flutter/material.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

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
    return Padding(
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
                  child: const Text('Mon Profil'),
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditUser.route);
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
                    Navigator.of(context).pushNamed(AddShop.route);
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
                    Navigator.of(context).pushNamed(ListShop.route);
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
                  child: const Text('Se déconnecter'),
                  onPressed: () {
                    Disconnect();
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> Disconnect() async{
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await StreamingSharedPreferences.instance;
  preferences.setString('token', '');
  print('disconnect');
}