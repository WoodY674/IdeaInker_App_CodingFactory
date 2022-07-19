import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thebestatoo/main.dart';
import 'package:thebestatoo/Pages/SideBarPage.dart';
import 'package:http/http.dart' as http;
import '../Classes/Posts.dart';

late List<Posts> posts = [];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String route = 'home';

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  late Future<List<Posts>> futurePost;
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'assets/IdeaInkerBanderole.png',
        fit: BoxFit.contain,
        height: 40,
      ),
    ],
  );

  @override
  void initState() {
    parsePostsImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: SideBarPage(),
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
        backgroundColor: Colors.white,
        body: StreamBuilder<List<Posts>>(
          // StreamBuilder<QuerySnapshot> in your code.
          initialData: posts, // you won't need this. (dummy data).
          // stream: Your querysnapshot stream.
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
        )

    );
  }

  /// Récupère les images postées
  void parsePostsImages() async {
    var postsToGet = fetchPosts();
    posts =  await postsToGet;
    setState(() {
      _streamController.sink.add(posts);
    });
  }
}

StreamController<List<Posts>> _streamController = StreamController<List<Posts>>.broadcast();
Stream<List<Posts>> get _stream => _streamController.stream;

///Filtre les posts via le contenu de la barre de recherche
_filter(String searchQuery) {
  List<Posts> _filteredList = posts
      .where((Posts user) => user.content!.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();
  _streamController.sink.add(_filteredList);
}
