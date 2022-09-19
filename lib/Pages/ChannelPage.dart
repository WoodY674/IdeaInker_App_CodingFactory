import 'package:flutter/material.dart';
import 'package:thebestatoo/Classes/Channel.dart';
import 'package:thebestatoo/Classes/User.dart';
import 'package:thebestatoo/Pages/sideBar.dart';
import '../../Classes/Token.dart';
import 'MessagesPage.dart';
import 'MessagesPage2.dart';


class ChannelPage extends StatefulWidget {


  final dynamic userId;
  final dynamic userPseudo;

  const ChannelPage(this.userId, this.userPseudo, {Key? key}) : super(key: key);

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
  late String myUserPseudo;


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
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    Channel currentChannel = snapshot.data![index];
                    if(snapshot.data?[index]?.usersInside?[1] == widget.userPseudo){
                      myUserPseudo = snapshot.data?[index]?.usersInside?[0];
                    }else{
                      myUserPseudo = snapshot.data?[index]?.usersInside?[1];
                    }
                    return Card(
                      margin: const EdgeInsets.all(8),
                      color: Colors.purple,
                      child: Center(
                          child: GestureDetector(
                            onTap: () {
                              if(snapshot.data?[index]?.usersInside?[1] == widget.userPseudo){
                                myUserPseudo = snapshot.data?[index]?.usersInside?[0];
                              }else{
                                myUserPseudo = snapshot.data?[index]?.usersInside?[1];
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MessagePage2(
                                        currentChannel.id, myUserPseudo
                                    ),
                              ));
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        myUserPseudo
                                    ),
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


