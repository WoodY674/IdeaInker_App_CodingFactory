// @dart=2.9;
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:thebestatoo/Pages/ChannelPage.dart';
import 'package:thebestatoo/Pages/ProfilShopPage.dart';
import 'package:thebestatoo/Pages/ProfilUserPage.dart';
import 'package:thebestatoo/Pages/CreateNoticesArtist.dart';
import 'package:thebestatoo/Pages/AddShopPage.dart';
import 'package:thebestatoo/Pages/CreateAccountPage.dart';
import 'package:thebestatoo/Pages/EditUserInformations.dart';
import 'package:thebestatoo/Pages/Admin/ListShopAdmin.dart';
import 'package:thebestatoo/Pages/PostsPage.dart';
import 'package:thebestatoo/Pages/LoginPage.dart';
import 'package:thebestatoo/Pages/MapPage.dart';
import 'package:thebestatoo/Pages/HomePage.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:thebestatoo/Pages/ProfilArtistePage.dart';
import 'package:thebestatoo/chat/chatAppBar.dart';
late final StreamingSharedPreferences preferences;
late final String urlSite;
late final String urlImage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await StreamingSharedPreferences.instance;
  late String token = preferences.getString('token', defaultValue: '').getValue();
  if(token != ""){
    bool isTokenExpired = JwtDecoder.isExpired(token);
    if(isTokenExpired == true){
      Disconnect();
    }
  }
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
    currentPage = const HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        HomePage.route: (context) => const HomePage(),
        MapPage.route: (context) => const MapPage(),
        CreateAccountPage.route: (context) => const CreateAccountPage(),
        EditUserInformations.route: (context) => const EditUserInformations(),
        AddShopPage.route: (context) => const AddShopPage(),
        ListShopAdmin.route: (context) => const ListShopAdmin(),
        ProfilUserPage.route: (context) => const ProfilUserPage(),
        ProfilArtistePage.route: (context) => const ProfilArtistePage(),
        LoginPage.route: (context) => const LoginPage(),
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

