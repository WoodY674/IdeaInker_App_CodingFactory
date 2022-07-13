import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:thebestatoo/Pages/ProfilSalon.dart';
import 'package:thebestatoo/Pages/addShop.dart';
import 'package:thebestatoo/Pages/sideBar.dart';
import 'package:thebestatoo/main.dart';
import 'dart:io';
import '../Classes/Shop.dart';

class ListShopUsers extends StatefulWidget {
  const ListShopUsers({Key? key}) : super(key: key);
  static String route = 'listShop';

  @override
  _ListShopUsers createState() => _ListShopUsers();
}

class _ListShopUsers extends State<ListShopUsers> {
  TextEditingController searchController = TextEditingController();
  late Future<List<Shop>> futureShop;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Text("Liste des salons"),
    ],
  );
  late Shop salonToDelete;

  @override
  void initState() {
    super.initState();
    futureShop = fetchShop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: customSearchBar,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    leading: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Recherche',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        onSubmitted: (String value){
                          _filter(value);
                        }
                    ),
                  );                } else {
                  searchController.text = "";
                  setState(() {
                    _filter("");
                  });
                  customIcon = const Icon(Icons.search);
                  customSearchBar = Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/IdeaInkerBanderole.png',
                        fit: BoxFit.contain,
                        height: 40,
                      ),
                    ],
                  );
                }
              });
            },
            icon: customIcon,
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder<List<Shop>>(
          future: futureShop,
          builder: (BuildContext context, AsyncSnapshot<List<Shop>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    Shop currentSalon = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilSalon(currentSalon.id)),
                        );
                      },
                      child: Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: currentSalon.salonImage?.imagePath != null ?
                              Container(
                                width: 100,
                                height: 150,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(urlImage + currentSalon.salonImage!.imagePath.toString()),
                                ),
                              ):
                              Container(
                                width: 100,
                                height: 150,
                                child: const CircleAvatar(
                                  backgroundImage: AssetImage('assets/noProfile.png'),
                                ),
                              )
                              ,
                              title: Text(currentSalon.name!),
                              subtitle: Text(currentSalon.address! + ' ' + currentSalon.zipCode! + ' ' + currentSalon.city!),
                              isThreeLine: true,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }
      ),
    );
  }

  Future<void> _filter(String searchQuery) async {
    setState(() {
      futureShop = getFutureFiltered(searchQuery);
    });
  }

  Future<List<Shop>> getFutureFiltered(String searchQuery) async {
    var postsToGet = fetchShop();
    List<Shop> shopFiltered =  await postsToGet;
    shopFiltered = shopFiltered.where((element) => element.name!.contains(searchQuery)).toList();
    return shopFiltered;
  }
}
