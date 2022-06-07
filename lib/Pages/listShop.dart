import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:thebestatoo/Pages/addShop.dart';
import 'package:thebestatoo/main.dart';
import 'dart:io';
import '../Classes/Shop.dart';

class ListShop extends StatefulWidget {
  const ListShop({Key? key}) : super(key: key);
  static String route = 'listShop';

  @override
  _ListShop createState() => _ListShop();
}

class _ListShop extends State<ListShop> {
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
                    return Card(
                      child: Column(
                        children: [
                          currentSalon.salon_image_id != "" ?
                          Image.asset('assets/photo-salon.png'):
                          Image.network(currentSalon.salon_image_id!),
                          ListTile(
                            title: Text(currentSalon.name),
                            subtitle: Text(currentSalon.address + ' ' + currentSalon.zip_code + ' ' + currentSalon.city),
                            trailing: IconButton(onPressed: () {
                              deleteShop(currentSalon.id);
                            }, icon: const Icon(Icons.delete)),
                            isThreeLine: true,
                          )
                        ],
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
      Uri.parse(urlSite + 'salons/'+id.toString()),
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
