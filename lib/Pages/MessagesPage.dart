import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thebestatoo/Classes/Channel.dart';
import 'package:thebestatoo/Classes/User.dart';
import 'package:thebestatoo/chat/chatAppBar.dart';
import 'package:thebestatoo/chat/components/body.dart';
import 'package:thebestatoo/chat/components/inputField.dart';
import 'package:thebestatoo/chat/components/inputFieldController.dart';
import 'package:thebestatoo/chat/models/chatMessage.dart';
import 'package:thebestatoo/main.dart';
import 'package:thebestatoo/Pages/sideBar.dart';
import '../../Classes/Token.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';


class MessagePage extends StatefulWidget {


  final dynamic  channelId;
  const MessagePage(this.channelId,{Key? key}) : super(key: key);

  @override
  _MessagePage createState() => _MessagePage();
}

class _MessagePage extends State<MessagePage> {

  TextEditingController messageInputController = TextEditingController();
  late Future<List<ChatMessage>> futureChatMessage;

  @override
  void initState() {
    super.initState();
    futureChatMessage = fetchChatMessage(widget.channelId);
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
      body:
        FutureBuilder<List<ChatMessage>>(
              future: futureChatMessage,
              builder: (BuildContext context, AsyncSnapshot<List<ChatMessage>> snapshot) {

                if (snapshot.hasData) {
                  print('snap data messages');
                  print(snapshot.data);
                  //snapshot.data?.reversed.toList();
                  return Container(
                    color: Colors.pink,

                      child: ListView.builder(

                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration:BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(40)) ,
                              child: Text(
                                snapshot.data![index].message.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
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


