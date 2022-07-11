import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:thebestatoo/Pages/ArtistesLies.dart';
import 'package:thebestatoo/Pages/informationsSalon.dart';
import 'package:thebestatoo/Pages/listAvis.dart';
import 'package:thebestatoo/Pages/postsPage.dart';
import 'package:thebestatoo/Pages/sideBar.dart';
import 'package:thebestatoo/Pages/toggleBar.dart';
import '../Classes/Notice.dart';
import '../Classes/Shop.dart';
import '../Classes/User.dart';
import 'Creations.dart';
import 'editUser.dart';
import '../main.dart';
import 'favoritesPage.dart';
import 'informationsArtiste.dart';
import 'informationsUser.dart';
import '../main.dart';

class ProfilArtisteId extends StatefulWidget {
  static String route = 'ProfilArtisteId';
  final dynamic id;
  const ProfilArtisteId(this.id,{Key? key}) : super(key: key);

  @override
  _ProfilArtisteId createState() => _ProfilArtisteId();
}

class _ProfilArtisteId extends State<ProfilArtisteId> {
  late User user;
  late Future<User> futureUser;
  late double stars = 0;
  List<String> labels = ["Créations","Informations"];
  int currentIndex = 0;
  late double meanStars = 0.0;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUserIndividual(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text('Profil Artiste'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            user = snapshot.data!;
            if(user.notices != null){
              meanStars = double.parse(user.notices!.average.toString());
            }
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
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ListAvis(snapshot.data!.notices,snapshot.data!.id,"Artist")),
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: SmoothStarRating(
                                      rating: meanStars,
                                      isReadOnly: true,
                                      size: 50,
                                      filledIconData: Icons.star,
                                      halfFilledIconData: Icons.star_half,
                                      defaultIconData: Icons.star_border,
                                      color: Colors.yellow,
                                      borderColor: Colors.yellow,
                                      starCount: 5,
                                      allowHalfRating: false,
                                      spacing: 2.0,
                                    ),
                                  ),
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
                  child: currentIndex == 0 ?
                  FavoritesPage(user) :
                  InformationsArtiste(user)
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