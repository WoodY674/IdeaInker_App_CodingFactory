import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thebestatoo/Classes/Channel.dart';
import 'package:thebestatoo/Classes/User.dart';
import 'package:thebestatoo/chat/chatAppBar.dart';
import 'package:thebestatoo/chat/components/body.dart';
import 'package:thebestatoo/chat/models/chatMessage.dart';
import 'package:thebestatoo/main.dart';
import 'package:thebestatoo/Pages/sideBar.dart';
import '../../Classes/Token.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'MessagesPage.dart';
import 'MessagesPage2.dart';


class ChannelPage extends StatefulWidget {


  final dynamic  userId;
  const ChannelPage(this.userId,{Key? key}) : super(key: key);

  @override
  _ChannelPage createState() => _ChannelPage();
}

class _ChannelPage extends State<ChannelPage> {

  TextEditingController messageInputController = TextEditingController();
  late Future<List<Channel>> futureChannel;
  late Token token;
  late Future<User> myUser;
  late Channel channel;
  late int myUserId;



  @override
  void initState() {
    super.initState();
    futureChannel = fetchChannel(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/IdeaInkerBanderole.png',
              fit: BoxFit.contain,
              height: 40,
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Channel>>(
          future: futureChannel,
          builder: (BuildContext context, AsyncSnapshot<List<Channel>> snapshot) {

            if (snapshot.hasData) {
              print(snapshot.data);
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.all(8),
                      color: Colors.amber,
                      child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MessagePage2(snapshot.data?[index]?.id),
                              ));
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(snapshot.data?[index]?.usersInside?[1]),
                                    subtitle: Text(snapshot.data![index].message.toString()),
                                    isThreeLine: true,
                                  )
                                ],
                              ),
                            ),
                          ),
                      ),
                    );
                  },
                ),


              );
            } else {
              print('no data, loading');
              return const CircularProgressIndicator();
            }
          }
      ),
    );
  }

}


