import 'package:flutter/material.dart';
import 'package:thebestatoo/chat/models/chatMessage.dart';
import 'package:thebestatoo/Pages/sideBar.dart';

class MessagePage2 extends StatefulWidget {

  final dynamic channelId;
  final dynamic userId;
  const MessagePage2(this.channelId, this.userId, {Key? key}) : super(key: key);

  @override
  _MessagePage createState() => _MessagePage();
}

class _MessagePage extends State<MessagePage2> {

  final myController = TextEditingController();
  late Future<List<ChatMessage>> futureChatMessage;

  @override
  void initState() {
    super.initState();
    futureChatMessage = fetchChatMessage(widget.channelId);
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
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
              return Column(
              children: [
                        SizedBox(
                          width: 500,
                          height: 500,
                          child: ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                            return Row(
                              mainAxisAlignment:
                                snapshot.data![index].sendBy?.pseudo == widget.userId ? MainAxisAlignment.start : MainAxisAlignment.end,
                                children: [
                                  Container(
                                    constraints: const BoxConstraints(maxWidth: 250),
                                    margin: const EdgeInsets.only(top: 10),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    decoration:
                                      BoxDecoration(
                                          color:
                                            snapshot.data![index].sendBy?.pseudo == widget.userId ? Colors.deepPurpleAccent : Colors.purple,
                                          borderRadius: BorderRadius.circular(40)
                                      ),
                                    child: Text(
                                      snapshot.data![index].message.toString(),
                                      style:
                                        const TextStyle(color: Colors.white),
                                        softWrap: true,
                                        maxLines: 10,
                                    ),
                                  ),
                                ],
                            );
                          },
                        ),
                  ),

                  Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5 ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        const SizedBox(
                            width: 100
                        ),
                        Expanded(

                          child: TextField(
                            controller: myController,
                            decoration: InputDecoration(
                              hintText: 'Type message',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            createMessage(myController.text, 1);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MessagePage2(widget.channelId, widget.userId),
                                ));
                          },
                          tooltip: 'Send',
                          icon: Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ),
                      ],
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


