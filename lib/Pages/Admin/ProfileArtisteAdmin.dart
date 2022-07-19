import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:thebestatoo/Pages/ArtistesFromShopPage.dart';
import 'package:thebestatoo/Pages/informationsSalonPage.dart';
import 'package:thebestatoo/Pages/NoticesListPage.dart';
import 'package:thebestatoo/Pages/SideBarPage.dart';
import 'package:thebestatoo/Pages/ToggleBarPage.dart';
import '../../Classes/Notice.dart';
import '../../Classes/Shop.dart';
import '../../Classes/User.dart';
import '../Creations.dart';
import '../EditUserInformations.dart';
import '../../main.dart';
import '../FavoritesPage.dart';
import '../informationsArtistePage.dart';
import '../informationsUserPage.dart';
import '../../main.dart';
import '../PostsPage.dart';

class ProfilArtisteAdmin extends StatefulWidget {
  static String route = 'ProfilArtiste';

  const ProfilArtisteAdmin({Key? key}) : super(key: key);

  @override
  _ProfilArtisteAdmin createState() => _ProfilArtisteAdmin();
}

class _ProfilArtisteAdmin extends State<ProfilArtisteAdmin> {
  late User user;
  late Future<User> futureUser;
  late double stars = 0;
  List<String> labels = ["Créations","Informations"];
  int currentIndex = 0;
  late double meanStars = 0.0;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBarPage(),
      appBar: AppBar(
        title: Text('Profil Artiste'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PostsPage()),
            );
          },
              icon: const Icon(Icons.add))
        ],
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
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const EditUserInformations()),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    height: 200,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(urlImage + snapshot.data!.profileImage!.imagePath.toString()),
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
                                            MaterialPageRoute(builder: (context) => const EditUserInformations()),
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
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => NoticesListPage(user.notices,user.id,"Artist")),
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
                                    )  ,
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
                  InformationsArtistePage(user)
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