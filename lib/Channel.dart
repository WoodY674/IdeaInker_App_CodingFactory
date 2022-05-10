import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thebestatoo/chat/chatAppBar.dart';
import 'package:thebestatoo/chat/models/chatMessage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE2NTIxNjcxMjIsImV4cCI6MTY1MjE5NzcyMiwicm9sZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJuYW1lIjoiYW50b2luZS1oYWxsZXJAb3V0bG9vay5mciJ9.eE2bWVm-zpuuKq1ji3l_lwnbJfD60jFbEpFjAxalAm7SWkTuyQ8t2G7cXDFhwnv5aBkxfnphUYt8SQYNBk50aCtGd43lsf7VUImfsvHZu5OcLbCP5d7aOg0uRqwy8K1uLSPY4wHq6sJ9033TrCbIUTOsvAjo-jGlO0QXxlMxMR_3IMqvrbsG-g1HcOZ486CKLh6GvUDWFgU47vHi5oTyaKNiV2V3GAc_ua3_PsHq8fDRwFCk8AXcBHG5Qgrt27xrNvvI2oj8p5ygJ3S68t8AhAr54M8UgoAS0hdK7Mhi8KS6Qx3LCGqYCMoiZHkzh378FwMifUQp5ZIaNBk9OxjTRA';

Future<Channel> fetchChannel() async {
  final response = await http

      .get(Uri.parse('http://localhost:8000/api/channels'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.

    final jsonResponse = json.decode(response.body);
    print('response :');
    print(response.body);
    return Channel.fromJson(jsonResponse[0]);
    //return Channel.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }

}

class Channel extends StatefulWidget{

  @override
  _ChannelState createState() => _ChannelState();

  int? id;
  List<UsersInside>? usersInside;
  List<Null>? messages;


  Channel({this.id, this.usersInside, this.messages});


  Channel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['usersInside'] != null) {
      usersInside = <UsersInside>[];
      json['usersInside'].forEach((v) {
        usersInside!.add(new UsersInside.fromJson(v));
      });
    }
    // if (json['messages'] != null) {
    //   messages = <Null>[];
    //   json['messages'].forEach((v) {
    //     messages!.add(new Null.fromJson(v));
    //   });
    // }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.usersInside != null) {
      data['usersInside'] = this.usersInside!.map((v) => v.toJson()).toList();
    }
    // if (this.messages != null) {
    //   data['messages'] = this.messages!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}





class _ChannelState extends State<Channel> {

  late Future<Channel> futureChannel;

  @override
  void initState() {
    super.initState();
    futureChannel = fetchChannel();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<Channel>(
      future: futureChannel,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data?.usersInside?.elementAt(0).email);
          return Text(snapshot.data!.id.toString());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}


class UsersInside {
  String? email;

  UsersInside({this.email});

  UsersInside.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}





// return SingleChildScrollView(
// child: Column(
// children: messages.map((message) {
// return InkWell(
// onTap: () =>
// {Navigator.pushNamed(context, Chat.route)},
// child: Container(
// padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
// child: Row(
// children: [
// Container(
// width: 62,
// height: 62,
// margin: const EdgeInsets.only(right: 20),
// decoration: BoxDecoration(
// color: Colors.purple,
// shape: BoxShape.circle,
// image: DecorationImage(
// fit: BoxFit.fill,
// image: AssetImage(message['senderProfilePic'],
// ),
// ),
// ),
// ),
// Expanded(
// child: Column(
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text(
// message['senderName'],
// style: TextStyle(
// color: Colors.grey[700]
// ),
// ),
// Wrap(
// children: [
// Text(
// message['message'],
// style: TextStyle(
// color: Colors.grey[500]
// ),
// ),
// ],
// ),
// ],
// ),
// Column(
// children: [
// Text(message['date']),
// message['unread'] != 0
// ? Container(
// padding: const EdgeInsets.all(5),
// decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
// child : Text(
// message['unread'].toString(),
// style: const TextStyle(
// color: Colors.white,
// ))
//
// )
//     : Container(),
// ],
// ),
// ],
// ),
// const SizedBox(height: 20),
// Container(
// color: Colors.grey[400],
// height: 0.5,
// ),
// ],
// ),
// ),
// ],
// )
// ),
// );
// }).toList(),
//
// ),
// );