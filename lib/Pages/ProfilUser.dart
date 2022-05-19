import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thebestatoo/Pages/informations.dart';
import 'package:thebestatoo/Pages/toggleBar.dart';
import '../Classes/User.dart';
import 'editUser.dart';
import 'favoritesPage.dart';
import 'main.dart';


class ProfilUser extends StatefulWidget {
  static String route = 'ProfilUser';

  const ProfilUser({Key? key}) : super(key: key);

  @override
  _ProfilUser createState() => _ProfilUser();
}

class _ProfilUser extends State<ProfilUser> {
  late User user;
  late Future<User> futureUser;
  List<String> labels = ["Favoris","Informations"];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon profil'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.deepPurple,
                    padding: EdgeInsets.all(15),
                    width: double.infinity,
                    child: FutureBuilder<User>(
                      future: futureUser,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          user = snapshot.data!;
                          return ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: <Widget>[
                              snapshot.data!.profileImage != null ?
                              Container(
                                width: 200,
                                height: 200,
                                child: Stack(
                                  children: <Widget>[
                                     Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const EditUser()),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 200,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(snapshot.data!.profileImage!),
                                      ),
                                    ),
                                  ],
                                ),
                              ) :
                              Center(
                                child: Container(
                                  width: 210,
                                  height: 200,
                                  child: Stack(
                                    children: <Widget>[
                                       Align(
                                        alignment: Alignment.bottomRight,
                                        child: IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const EditUser()),
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        height: 200,
                                        child: const CircleAvatar(
                                          backgroundImage: AssetImage("noProfile.png"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(snapshot.data!.firstName! + " " + snapshot.data!.lastName!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 2,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        // By default, show a loading spinner.
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                  ToggleBar(
                    labels: labels,
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    backgroundBorder: Border.all(color: Colors.deepPurple),
                    onSelectionUpdated: (index) =>
                        setState(() => currentIndex = index),
                  )
                ],
              ),
            ),
            if(currentIndex == 0)
               const FavoritesPage()
            else if(currentIndex == 1)
               Informations(user)
          ],
        ),
      ),
    );
  }
}