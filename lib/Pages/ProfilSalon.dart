import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:thebestatoo/Pages/ArtistesLies.dart';
import 'package:thebestatoo/Pages/informationsSalon.dart';
import 'package:thebestatoo/Pages/toggleBar.dart';
import '../Classes/Shop.dart';
import '../Classes/User.dart';
import 'Creations.dart';
import 'editUser.dart';
import 'favoritesPage.dart';
import 'informationsUser.dart';
import 'main.dart';

class ProfilSalon extends StatefulWidget {
  static String route = 'ProfilArtiste';

  const ProfilSalon({Key? key}) : super(key: key);

  @override
  _ProfilSalon createState() => _ProfilSalon();
}

class _ProfilSalon extends State<ProfilSalon> {
  late User user;
  late Future<User> futureUser;
  late double stars = 0;
  List<String> labels = ["Créations","Informations","Artistes liés"];
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
        title: const Text('Profil Salon'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            user = snapshot.data!;
            return NestedScrollView(headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        color: Colors.deepPurple,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            snapshot.data!.profileImage != null ?
                            Container(
                              width: 200,
                              height: 200,
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit),
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
                            Container(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: RatingBar.builder(itemBuilder: (context,_)=>
                                      Icon(Icons.star,color:Colors.yellow),
                                      itemSize: 50,
                                      onRatingUpdate: (rating){
                                        setState(() {
                                          stars = rating;
                                        });
                                      }) ,
                                )
                            ),
                            Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  ToggleBar(
                                    labels: labels,
                                    backgroundColor: Colors.grey.withOpacity(0.1),
                                    backgroundBorder: Border.all(color: Colors.deepPurple),
                                    onSelectionUpdated: (index) =>
                                        setState(() => currentIndex = index),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
              body: Container(
                child: LayoutBuilder(builder: (context, constraints) {
                  if (currentIndex == 0) {
                    return FavoritesPage(user);
                  }
                  else if (currentIndex == 1) {
                    return InformationsSalon(user);
                  }
                  else if (currentIndex == 2) {
                    return ArtistesLies(user);
                  }else{
                    return const CircularProgressIndicator();
                  }
                }
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}