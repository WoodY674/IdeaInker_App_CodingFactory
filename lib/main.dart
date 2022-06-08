import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:thebestatoo/Channel.dart';
import 'package:thebestatoo/Pages/ProfilSalon.dart';
import 'package:thebestatoo/Pages/ProfilUser.dart';
import 'package:thebestatoo/Pages/Avis.dart';
import 'package:thebestatoo/Pages/addShop.dart';
import 'package:thebestatoo/Pages/createaccount.dart';
import 'package:thebestatoo/Pages/editUser.dart';
import 'package:thebestatoo/Pages/listShop.dart';
import 'package:thebestatoo/Pages/menu.dart';
import 'package:thebestatoo/Pages/postsPage.dart';
import 'package:thebestatoo/Pages/profil.dart';
import 'package:thebestatoo/Pages/map.dart';
import 'package:thebestatoo/Pages/home.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'ProfilArtiste.dart';
late final StreamingSharedPreferences preferences;
late final String urlSite;
late final String urlImage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await StreamingSharedPreferences.instance;
  urlSite = "http://ideainker.fr/api/";
  urlImage = "http://ideainker.fr/";
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return const MainPage();
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Widget currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = const Home();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Home.route: (context) => const Home(),
        MyMap.route: (context) => const MyMap(),
        CreateAccount.route: (context) => const CreateAccount(),
        Menu.route: (context) => const Menu(),
        EditUser.route: (context) => const EditUser(),
        AddShop.route: (context) => const AddShop(),
        ListShop.route: (context) => const ListShop(),
        ProfilUser.route: (context) => const ProfilUser(),
        ProfilSalon.route: (context) => const ProfilSalon(),
        ProfilArtiste.route: (context) => const ProfilArtiste(),
        Profil.route: (context) => const Profil(),
        Channel.route: (context) => Channel(),
        PostsPage.route:(context) => const PostsPage(),
      },
      home: Scaffold(
        body: currentPage,
      ),
    );
  }
}

Future<void> Disconnect() async{
  WidgetsFlutterBinding.ensureInitialized();
  preferences.setString('token', '');
}

