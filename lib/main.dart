import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:thebestatoo/createaccount.dart';
import 'package:thebestatoo/profil.dart';
import 'package:thebestatoo/map.dart';
import 'package:thebestatoo/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(title: 'Find My Tattoo',),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int selectedIndex = 1;
  List<Widget> listWidgets = [
    const Map(),
    const Home(),
    const Profil()
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Best Tattoo',
          style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.map),label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.verified_user),label: 'Profil')
          ],
          backgroundColor: Colors.deepPurple,
          activeColor: Colors.white,
        ),
        tabBuilder: (BuildContext context, index){
          return listWidgets[index];
        },
      ),
    );
  }
}