import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:thebestatoo/Pages/Avis.dart';
import 'package:thebestatoo/Pages/addShop.dart';
import 'dart:io';
import '../Classes/Salon.dart';
import 'main.dart';

final String url = "http://ideainker.fr/api/notices";

List<Notice> parseNotice(String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var notices = list.map((e) => Notice.fromJson(e)).toList();
  return notices;
}

Future<List<Notice>> fetchNotice() async {
  final http.Response response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return Salon.fromJson(jsonDecode(response.body));
    return compute(parseNotice,response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception(response.statusCode);
  }
}

class Notice {
  final int? id;
  final int stars;
  final String comment;
  final String userNoted;
  final String userNoting;

  const Notice({
    required this.id,
    required this.stars,
    required this.comment,
    required this.userNoted,
    required this.userNoting,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return Notice(
      id: json["id"],
      stars: json["stars"],
      comment: json["comment"],
      userNoted: json["userNoted"],
      userNoting: json["userNoting"]
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stars'] = stars;
    data['comment'] = comment;
    data['userNoted'] = userNoted;
    data['userNoting'] = userNoting;
    return data;
  }
}
class ListAvis extends StatefulWidget {
  const ListAvis({Key? key}) : super(key: key);
  static String route = 'listAvis';

  @override
  _ListAvis createState() => _ListAvis();
}

class _ListAvis extends State<ListAvis> {
  late Future<List<Notice>> futureNotice;

  @override
  void initState() {
    super.initState();
    futureNotice = fetchNotice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des avis'),
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateAvis()),
              );
              setState(() {
                futureNotice = fetchNotice();
              });
            },
          )
        ],
      ),
      body: FutureBuilder<List<Notice>>(
          future: futureNotice,
          builder: (BuildContext context, AsyncSnapshot<List<Notice>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Notice currentNotice = snapshot.data![index];
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Align(
                              alignment: Alignment.center,
                              child: RatingBar.builder(
                                  initialRating: double.parse(currentNotice.stars.toString()),
                                  itemBuilder: (context,_)=>
                                  const Icon(Icons.star,color:Colors.amber),
                                  itemSize: 30,
                                  onRatingUpdate: (double value) {
                                  },
                              ) ,
                            ),
                            subtitle: Align(
                              alignment: Alignment.center,
                              child: Text(currentNotice.comment),
                            ),
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
}
