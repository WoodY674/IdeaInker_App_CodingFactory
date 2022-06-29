import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thebestatoo/Classes/Channel.dart';
import 'package:thebestatoo/Classes/User.dart';
import 'package:thebestatoo/chat/components/body.dart';
import 'package:thebestatoo/main.dart';
import 'package:thebestatoo/Pages/sideBar.dart';
import '../../Classes/Token.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';


class ChannelPage extends StatefulWidget {
  const ChannelPage({Key? key}) : super(key: key);
  static String route = 'channel';

  @override
  _ChannelPage createState() => _ChannelPage();
}

class _ChannelPage extends State<ChannelPage> {
  TextEditingController messageInputController = TextEditingController();
  late Future<List<Channel>> futureChannel;
  late Token token;
  final _formKey = GlobalKey<FormState>();
  late Channel channel;
  late String recipient;


  @override
  void initState() {
    super.initState();
    futureChannel = fetchChannel();
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
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    Channel currentChannel = snapshot.data![index];
                    print(currentChannel.usersInside.runtimeType);

                    Future<User> myUser = fetchUser();
                    print(myUser);
                    return Card(
                      margin: const EdgeInsets.all(8),

                      color: Colors.amber,
                      child: Center(

                          child: FutureBuilder<User>(
                            future: myUser,
                              builder: (context, snapshotUser){
                              if(snapshotUser.hasData){
                                currentChannel.usersInside?.forEach((element) {
                                  channel = snapshot.data![index];
                                  String myChannel = element.toString();
                                  List<String> myUser = [];
                                  myUser.add(myChannel.split(" ")[1]);
                                  myUser.add(myUser[0].split("}")[0]);
                                  if(myUser[1] != snapshotUser.data?.email){
                                   recipient = myUser[1];
                                  }
                                });
                                return GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => ProfilSalon(currentSalon)),
                                    // );
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [

                                        ListTile(
                                          title: Text(recipient),
                                          subtitle: Text('Dernier message'),
                                          isThreeLine: true,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }else{
                                return const CircularProgressIndicator();                              }
                              }
                          ),
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

