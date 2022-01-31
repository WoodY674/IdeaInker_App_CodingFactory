import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);
  static const String route = 'Chat';


  @override
  _Chat createState() => _Chat();

}

class _Chat extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text('bonjour')
        )
    );
  }
}