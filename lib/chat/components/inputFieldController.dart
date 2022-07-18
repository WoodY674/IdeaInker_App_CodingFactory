// // Define a custom Form widget.
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:thebestatoo/chat/models/chatMessage.dart';
// import 'package:http/http.dart' as http;
//
// import '../../main.dart';
//
// class MyCustomInput extends StatefulWidget {
//   const MyCustomInput({Key? key}) : super(key: key);
//
//   @override
//   _MyCustomInputState createState() => _MyCustomInputState();
// }
//
// class _MyCustomInputState extends State<MyCustomInput> {
//
//   final myController = TextEditingController();
//   final String url = urlSite +"messages/";
//   final token = preferences.getString('token', defaultValue: '').getValue();
//   Future<http.Response> createMessage(String message) {
//   print(message);
//     return http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode(<String, String>{
//         'message': message,
//         'sendBy': '47',
//         'channel' : '1'
//       }),
//     );
//   }
//
//   @override
//   void dispose() {
//     myController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5 ),
//       decoration: BoxDecoration(
//         color: Colors.white),
//       child: SafeArea(
//         child: Row(
//           children: [
//             SizedBox(width: 100),
//             Expanded(
//               child: TextField(
//                 controller: myController,
//                 decoration: InputDecoration(
//                   hintText: 'Type message',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(40),
//                   ),
//                 ),
//               ),
//             ),
//             IconButton(
//               onPressed: () {
//                 //chatMessages.add(ChatMessage(text: myController.text, isSender: true));
//                 createMessage(myController.text);
//                 print(myController.text);
//               },
//               tooltip: 'Send',
//               icon: Icon(Icons.send),
//               //child: const Icon(Icons.text_fields),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }