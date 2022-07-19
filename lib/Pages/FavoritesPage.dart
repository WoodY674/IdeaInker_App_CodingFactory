library toggle_bar;
import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Classes/Posts.dart';
import '../main.dart';

late List<Posts> posts = [];

class FavoritesPage extends StatelessWidget {
  final dynamic users;
  const FavoritesPage( this.users,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    parsePostsImages();
    return StreamBuilder<List<Posts>>(
      initialData: posts,
      builder: (BuildContext context, AsyncSnapshot<List<Posts>> snapshot) {
        return StreamBuilder<List<Posts>>(
          key: ValueKey(snapshot.data),
          initialData: snapshot.data,
          stream: _stream,
          builder:
              (BuildContext context, AsyncSnapshot<List<Posts>> snapshot) {
            return MasonryGridView.count(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                Posts currentSalon = snapshot.data![index];
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        urlImage+currentSalon.image!.imagePath!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentSalon.content!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ],
                    )
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  /// Récupère les images postées
  void parsePostsImages() async {
    var postsToGet = fetchPosts();
    posts =  await postsToGet;
    _streamController.sink.add(filteredPosts(posts));
  }

  /// Filtre les posts sous forme de liste
  List<Posts> filteredPosts(List<Posts> posts) {
    List<Posts> postFiltered = posts.where((element) => element.createdBy?.id! == users.id).toList();
    return postFiltered;
  }
}

StreamController<List<Posts>> _streamController = StreamController<List<Posts>>.broadcast();
Stream<List<Posts>> get _stream => _streamController.stream;
