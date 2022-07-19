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
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(vertical: 30),
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height / 2,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(35),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text(
                                            "Share to",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 17,
                                          ),
                                          SizedBox(
                                            height: 100.0,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: sharePosts.length,
                                              itemBuilder: (context, index) {
                                                return SizedBox(
                                                  width: 90,
                                                  child: Column(children: [
                                                    CircleAvatar(
                                                      radius: 35,
                                                      backgroundImage: AssetImage(
                                                        'assets/${sharePosts[index]
                                                            .imageUrl}',
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Text(
                                                      sharePosts[index].id,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500),
                                                    )
                                                  ]),
                                                );
                                              },
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 7, horizontal: 15),
                                            child: Divider(
                                              color: Colors.grey,
                                              height: 5,
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: const [
                                                Text(
                                                  "This Pin was inspired by your recent activity",
                                                  style: TextStyle(fontSize: 14),
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "Hide",
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Text(
                                                  "Report",
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight: FontWeight.w600),
                                                )
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 20, horizontal: 26),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(30),
                                                  color: Colors.grey.shade300),
                                              child: const Text("Close",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600)),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Icon(Icons.more_horiz),
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

class Post {
  final String id;
  final String imageUrl;
  final String title;

  Post(
      this.id,
      this.imageUrl,
      this.title,
      );
}

final List<Post> sharePosts = [
  Post(
    'WhatsApp',
    'whatsapp.png',
    '',
  ),
  Post(
    'Messenger',
    'messenger.png',
    '',
  ),
  Post(
    'Messages',
    'messages.png',
    '',
  ),
];
