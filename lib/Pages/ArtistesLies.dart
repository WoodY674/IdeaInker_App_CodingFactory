library toggle_bar;
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thebestatoo/Classes/User.dart';
import 'package:thebestatoo/Pages/ProfilArtiste.dart';

import '../Classes/Shop.dart';
import '../main.dart';
import 'ProfilArtisteId.dart';

class ArtistesLies extends StatelessWidget {
  final dynamic artistes;
  const ArtistesLies( this.artistes, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        artistes != null ?
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: artistes.length,
          itemBuilder: (context ,index){
            Artists user = artistes![index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilArtisteId(user.id)),
                );
              },
              child: Card(
                child: Column(
                  children: [
                    user.profileImage != null ?
                    ListTile(
                      leading: Container(
                        width: 100,
                        height: 50,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(urlImage + user.profileImage!.imagePath.toString()),
                        ),
                      ),
                      title: Text(user.pseudo!),
                      subtitle: const Text(""),
                      isThreeLine: true,
                    )
                        :
                    ListTile(
                      leading: Image.asset('assets/noProfile.png',
                        height: 100,
                        width: 50,
                      ),
                      title: Text(user.pseudo!),
                      subtitle: const Text(""),
                      isThreeLine: true,
                    )
                  ],
                ),
              ),
            );
          },
        ) : Container()
      ],
    );
  }
}
