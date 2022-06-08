import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:thebestatoo/Pages/Avis.dart';
import '../../Classes/Notice.dart';

class ListAvisAdmin extends StatefulWidget {
  final dynamic id;
  const ListAvisAdmin(this.id, {Key? key}) : super(key: key);
  static String route = 'listAvis';

  @override
  _ListAvisAdmin createState() => _ListAvisAdmin();
}

class _ListAvisAdmin extends State<ListAvisAdmin> {
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
      ),
      body: FutureBuilder<List<Notice>>(
          future: futureNotice,
          builder: (BuildContext context, AsyncSnapshot<List<Notice>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data!.where((element) => element.userNoting.contains(widget.id.toString())).length,
                  itemBuilder: (context, index) {
                    Notice currentNotice = snapshot.data![index];
                    return Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Align(
                              alignment: Alignment.center,
                              child: SmoothStarRating(
                                rating: double.parse(currentNotice.stars.toString()),
                                isReadOnly: true,
                                size: 30,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                defaultIconData: Icons.star_border,
                                color: Colors.yellow,
                                borderColor: Colors.deepPurple,
                                starCount: 5,
                                allowHalfRating: false,
                                spacing: 2.0,
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
