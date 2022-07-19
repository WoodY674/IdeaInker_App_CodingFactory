library toggle_bar;
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Classes/Posts.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;

late List<Posts> posts = [];

class FavoritesAdminPageShop extends StatelessWidget {
  final dynamic users;
  const FavoritesAdminPageShop( this.users,{Key? key}) : super(key: key);

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
                        GestureDetector(
                          child: const Icon(Icons.close,
                            color: Colors.red,
                          ),
                          onTap: (){
                            deletePost(currentSalon.image!.id!);
                          },
                        )
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

  deletePost(int id) async {
    final response = await http.delete(
      Uri.parse(urlSite + 'post/' + id.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
      }),
    );
    WidgetsFlutterBinding.ensureInitialized();
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Fluttertoast.showToast(
          msg: "Post supprimé",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
      parsePostsImages();
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(
          msg: "Impossible de supprimer le post",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  ///Récupére une liste de Posts
  void parsePostsImages() async {
    var postsToGet = fetchPosts();
    posts =  await postsToGet;
    _streamController.sink.add(filteredPosts(posts));
  }
  /// Filtre une liste de Posts via un id
  List<Posts> filteredPosts(List<Posts> posts) {
    List<Posts> postFiltered = posts.where((element) => element.createdBySalon?.id == users.id).toList();
    return postFiltered;
  }
}

StreamController<List<Posts>> _streamController = StreamController<List<Posts>>.broadcast();
Stream<List<Posts>> get _stream => _streamController.stream;
