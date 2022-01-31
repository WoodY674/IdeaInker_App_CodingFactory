import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:thebestatoo/profil.dart';
import 'package:thebestatoo/map.dart';
import 'package:thebestatoo/home.dart';
import 'package:thebestatoo/chat.dart';
import 'package:thebestatoo/messages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(title: 'Find My Tattoo',),
      routes: {
        Chat.route : (context) => Chat(),
      },
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
  List<Widget> listWidgets = [const Map(),const Home(),const Profil(), Messages(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: listWidgets[selectedIndex],
      bottomNavigationBar: ConvexAppBar.badge({3: '21+'},
        items: const [
          TabItem(icon: Icons.map, title: 'Map'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.verified_user, title: 'Profil'),
          TabItem(icon: Icons.chat_rounded, title: 'Messages'),
        ],
        onTap: onItemTapped,
        activeColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        initialActiveIndex: 1,
      ),
    );
  }

  void onItemTapped(int index){
    setState(() {
      selectedIndex = index;
    });
  }

}