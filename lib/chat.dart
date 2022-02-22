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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('nom du destinataire'),
        leading: IconButton (
          icon:const Icon(Icons.arrow_back),
          onPressed:() {Navigator.pop(context);}
        ),
      ),
        backgroundColor: Colors.white,
        body: const Center(
          child: Text('bonjour')
        )
    );
  }
}