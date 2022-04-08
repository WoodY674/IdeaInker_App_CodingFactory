import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thebestatoo/chat/chat.dart';

class Messages extends StatefulWidget {
  Messages({Key? key}) : super(key: key);

  @override
  _Messages createState() => _Messages();
}

class _Messages extends State<Messages> {
  final List messages = [
    {
      'senderProfilePic' : './assets/woody.jpg',
      'senderName' : 'Woody',
      'message' : 'Bonjour',
      'unread' : 0,
      'date' : '16:35',
    },
    {
      'senderProfilePic' : './assets/woody.jpg',
      'senderName' : 'Lana Rhoades',
      'message' : 'Oui',
      'unread' : 1,
      'date' : '12:57',
    },
    {
      'senderProfilePic' : './assets/woody.jpg',
      'senderName' : 'Mia khalifa',
      'message' : 'Je suis chanteuse',
      'unread' : 3,
      'date' : '13:15',
    },
    {
      'senderProfilePic' : './assets/woody.jpg',
      'senderName' : 'Gérard Depardieu',
      'message' : 'Vodka Russie',
      'unread' : 1,
      'date' : '13:15',
    },
     {
      'senderProfilePic' : './assets/woody.jpg',
      'senderName' : 'Woody',
      'message' : 'Bonjour',
      'unread' : 0,
      'date' : '16:35',
    },
    {
      'senderProfilePic' : './assets/woody.jpg',
      'senderName' : 'Lana Rhoades',
      'message' : 'Oui',
      'unread' : 1,
      'date' : '12:57',
    },
    {
      'senderProfilePic' : './assets/woody.jpg',
      'senderName' : 'Mia khalifa',
      'message' : 'Je suis chanteuse',
      'unread' : 3,
      'date' : '13:15',
    },
    {
      'senderProfilePic' : './assets/woody.jpg',
      'senderName' : 'Gérard Depardieu',
      'message' : 'Vodka Russie',
      'unread' : 1,
      'date' : '13:15',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: messages.map((message) {
          return InkWell(
            onTap: () =>
            {Navigator.pushNamed(context, Chat.route)},
              child: Container(
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(message['senderProfilePic'],
                            ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['senderName'],
                                    style: TextStyle(
                                        color: Colors.grey[700]
                                    ),
                                  ),
                                  Wrap(
                                    children: [
                                      Text(
                                        message['message'],
                                        style: TextStyle(
                                          color: Colors.grey[500]
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(message['date']),
                                  message['unread'] != 0
                                      ? Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                                      child : Text(
                                          message['unread'].toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ))

                                      )
                                      : Container(),
                                ],
                              ),
                              ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            color: Colors.grey[400],
                            height: 0.5,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ),
          );
        }).toList(),

      ),
    );

  }
}