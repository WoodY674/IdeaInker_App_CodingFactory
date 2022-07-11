import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:thebestatoo/Classes/Shop.dart';
import 'package:thebestatoo/Pages/CreateAvisArtist.dart';

import '../Classes/Notice.dart';
import 'CreateAvisSalon.dart';

class ListAvis extends StatefulWidget {
  final dynamic notices;
  final dynamic id;
  final dynamic role;
  const ListAvis(this.notices,this.id,this.role, {Key? key}) : super(key: key);
  static String route = 'listAvis';

  @override
  _ListAvis createState() => _ListAvis();
}

class _ListAvis extends State<ListAvis> {
  late Notices notices;

  @override
  void initState() {
    super.initState();
    notices = widget.notices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des avis'),
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              if(widget.role == "Artist"){
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAvisArtist(widget.id)),
                );
              }else if(widget.role == "Shop"){
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateAvisSalon(widget.id)),
                );
              }
            },
          )
        ],
      ),
      body: Container(
        child: notices != null ? ListView.builder(
            itemCount: notices.allNotices?.length,
            itemBuilder: (context, index) {
              AllNotices currentNotice = notices.allNotices![index];
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
                        child: Text(currentNotice.comment.toString()),
                      ),
                      isThreeLine: true,
                    )
                  ],
                ),
              );
            }
        ): Container(),
      ),
    );
  }
}
