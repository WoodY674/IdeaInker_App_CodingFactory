import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:thebestatoo/Pages/ArtistesLies.dart';
import 'package:thebestatoo/Pages/informationsSalon.dart';
import 'package:thebestatoo/Pages/toggleBar.dart';
import '../../Classes/Shop.dart';
import '../../Classes/User.dart';
import '../Creations.dart';
import '../editShop.dart';
import '../editUser.dart';
import '../favoritesPage.dart';
import '../informationsUser.dart';
import '../../main.dart';
import '../postsPage.dart';

class ProfilSalonAdmin extends StatefulWidget {
  static String route = 'ProfilArtiste';
  final dynamic shop;
  const ProfilSalonAdmin(this.shop,{Key? key}) : super(key: key);
  @override
  _ProfilSalonAdmin createState() => _ProfilSalonAdmin();
}

class _ProfilSalonAdmin extends State<ProfilSalonAdmin> {
  late double stars = 0;
  List<String> labels = ["Créations","Informations","Artistes liés"];
  int currentIndex = 0;
  late Shop shop;

  @override
  void initState() {
    super.initState();
    shop = widget.shop;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Salon'),
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
      body:NestedScrollView(headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        color: Colors.deepPurple,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            shop.salon_image_id != null ?
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
                                          MaterialPageRoute(builder: (context) =>  EditShop(shop)),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    height: 200,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(shop.salon_image_id!),
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
                                            MaterialPageRoute(builder: (context) =>  EditShop(shop)),
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
                              child: Text(shop.name,
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
                    return FavoritesPage(shop);
                  }
                  else if (currentIndex == 1) {
                    return InformationsSalon(shop);
                  }
                  else if (currentIndex == 2) {
                    return ArtistesLies(shop);
                  }else{
                    return const CircularProgressIndicator();
                  }
                }
                ),
              ),
            ),
      );
  }
}