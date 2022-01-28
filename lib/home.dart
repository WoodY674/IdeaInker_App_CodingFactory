import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Center(
          child: Text(
          "Find Your Tattoo"
        ),)
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    posts[index].imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      posts[index].title,
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
                              height: MediaQuery.of(context).size.height / 2,
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
                                                'assets/${sharePosts[index].imageUrl}',
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
        ),
      ),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.deepPurpleAccent,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.map, title: 'Discovery'),
            TabItem(icon: Icons.add, title: 'Add'),
            TabItem(icon: Icons.message, title: 'Message'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: 2,//optional, default as 0
          onTap: (int i) => print('click index=$i'),
        )
    );
  }
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

final List<Post> posts = [
  Post(
    'id0',
    'https://i0.wp.com/www.tattoo-mistika.fr/wp-content/uploads/2018/10/31351293_1850598344992042_5738909438235876539_n.jpg?ssl=1',
    'IntTattoo',
  ),
  Post(
    'id1',
    'https://astucesdefilles.com/medias/2021/06/24_100-top-idees-de-tatouages-lion.jpg',
    'InkTattoo1',
  ),
  Post(
    'id2',
    'https://i.pinimg.com/originals/45/86/09/45860947bb65b922ab12e768e5b595b9.jpg',
    'InkTattoo2',
  ),
  Post(
    'id3',
    'https://image.jimcdn.com/app/cms/image/transf/dimension=1920x1024:format=jpg/path/s6e3bb4a7f0125942/image/i7c73e8295e77ca4d/version/1635157430/image.jpg',    'InkTattoo3',
  ),
  Post(
    'id4',
    'https://inkin.fr/wp-content/sabai/File/files/l_b1d89c65367922e734a6091be807fec2.jpg',
    'InkTattoo4',
  ),
  Post(
    'id5',
    'https://i.pinimg.com/originals/ca/95/9a/ca959a97fc661b4e4430a223a3c0c593.jpg',
    'InkTattoo5',
  ),
  Post(
    'id6',
    'https://i.pinimg.com/736x/d7/b7/88/d7b7887b643ad9a9e1addc43a93c913a.jpg',
    'InkTattoo6',
  ),
  Post(
    'id7',
    'https://cdn.shopify.com/s/files/1/0243/6058/3202/files/tatouage-horloge_e7863279-3753-4b37-8b13-c4ba0debd00a.jpg?v=1626011176',
    'InkTattoo7',
  ),
  Post(
    'id8',
    'http://www.lesaffaires.com/uploads/images/normal/f1e8952b379d84d7dc3d8f0e4722c2d4.jpg',
    'InkTattoo8',
  ),
  Post(
    'id9',
    'https://www.mon-tatoueur.fr/assets/tatoueurs/monsieur_berdah-1003/2509789351851906731.jpg',
    'InkTattoo9',
  ),
];

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
