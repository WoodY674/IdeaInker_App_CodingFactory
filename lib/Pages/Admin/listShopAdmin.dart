import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:thebestatoo/Pages/addShop.dart';
import 'package:thebestatoo/Pages/sideBar.dart';
import 'package:thebestatoo/main.dart';
import 'dart:io';
import '../../Classes/Shop.dart';
import '../ProfilSalon.dart';

class ListShopAdmin extends StatefulWidget {
  const ListShopAdmin({Key? key}) : super(key: key);
  static String route = 'listShop';

  @override
  _ListShopAdmin createState() => _ListShopAdmin();
}

class _ListShopAdmin extends State<ListShopAdmin> {
  late Future<List<Shop>> futureShop;
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
        title: const Text('Liste des salons'),
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddShop()),
              );
            },
          )
        ],
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
                              trailing: IconButton(onPressed: () {
                                deleteShop(currentSalon.id);
                              }, icon: const Icon(Icons.delete)),
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
  Future<void> deleteShop(int? id) async {
    log(id.toString());
    final responseSalon = await http.delete(
      Uri.parse(urlSite + 'salon/'+id.toString()),
    );

    if (responseSalon.statusCode == 204) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      log("salon deleted with Success=");
      Fluttertoast.showToast(
          msg: "Salon deleted with Success!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        futureShop = fetchShop();
      });
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(
          msg: "Failed deleted Salon",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
}