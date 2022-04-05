import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:thebestatoo/Pages/createaccount.dart';
import 'package:thebestatoo/Pages/menu.dart';
import 'package:thebestatoo/Pages/profil.dart';
import 'package:thebestatoo/Pages/map.dart';
import 'package:thebestatoo/Pages/home.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class MyAppSettings {
  MyAppSettings(StreamingSharedPreferences preferences)
      : token = preferences.getString('token', defaultValue: '');

  final Preference<String> token;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain instance to streaming shared preferences, create MyAppSettings, and
  // once that's done, run the app.
  final preferences = await StreamingSharedPreferences.instance;
  final settings = MyAppSettings(preferences);

  runApp(MyApp(settings));
}

class MyApp extends StatelessWidget {
  MyApp(this.settings);
  final MyAppSettings settings;

  @override
  Widget build(BuildContext context) {
    return PreferenceBuilder<String>(
        preference: settings.token,
        builder: (BuildContext context, String token) {
          if(token.isEmpty){
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: MainPage(title: 'Find My Tattoo',),
            );
          }else{
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: MainPageLog(title: 'Find My Tattoo',),
            );
          }
        }
    );
  }
}

//Not Log
class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int selectedIndex = 1;
  List<Widget> listWidgets = [
    Map(),
    const Home(),
    const Profil()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        CreateAccount.route: (context) => const CreateAccount(),
        Menu.route: (context) => const Menu(),
      },
      home: Scaffold(
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
        body: listWidgets[selectedIndex],
        bottomNavigationBar: ConvexAppBar.badge({3: '21+'},
          items: const [
            TabItem(icon: Icons.map, title: 'Map'),
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.verified_user, title: 'Login'),
          ],
          onTap: onItemTapped,
          activeColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          initialActiveIndex: 1,
        ),
      ),
    );
  }

  void onItemTapped(int index){
    setState(() {
      selectedIndex = index;
    });
  }

}

//Log Done
//Not Log
class MainPageLog extends StatefulWidget {
  const MainPageLog({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MainPageLogState createState() => _MainPageLogState();
}

class _MainPageLogState extends State<MainPageLog> {

  int selectedIndex = 1;
  List<Widget> listWidgets = [
    Map(),
    const Home(),
    const Menu()
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        CreateAccount.route: (context) => const CreateAccount(),
        Menu.route: (context) => const Menu(),
      },
      home: Scaffold(
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
        body: listWidgets[selectedIndex],
        bottomNavigationBar: ConvexAppBar.badge({3: '21+'},
          items: const [
            TabItem(icon: Icons.map, title: 'Map'),
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.verified_user, title: 'Mon Profil'),
          ],
          onTap: onItemTapped,
          activeColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          initialActiveIndex: 1,
        ),
      ),
    );
  }

  void onItemTapped(int index){
    setState(() {
      selectedIndex = index;
    });
  }

}