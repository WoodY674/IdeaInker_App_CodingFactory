// import 'package:flutter/material.dart';
// import 'package:thebestatoo/chat/components/body.dart';
//
// class Chat extends StatefulWidget {
//   int? id;
//
//   Chat(
//       {
//         this.id,
//       });
//
//   @override
//   _Chat createState() => _Chat();
//
// }
//
// class _Chat extends State<Chat> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildAppBar(),
//       body: Body(),
//     );
//   }
//
//   AppBar buildAppBar(){
//     return AppBar(
//         backgroundColor: Colors.deepPurple,
//         title: Row(
//           children: [
//             CircleAvatar(backgroundImage: AssetImage("assets/woody.jpg"),),
//             Text('nom du destinataire'),
//
//           ],
//         ),
//         leading: IconButton (
//           icon:const Icon(Icons.arrow_back),
//           onPressed:() {Navigator.pop(context);}
//         ),
//       );
//
//   }
// }