import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thebestatoo/chat/chatAppBar.dart';
import 'package:thebestatoo/chat/models/chatMessage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE2NTIyNTQ1MDAsImV4cCI6MTY1MjI4NTEwMCwicm9sZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJuYW1lIjoiYW50b2luZS1oYWxsZXJAb3V0bG9vay5mciJ9.Osp_-MS6gpkBLlZXglbLglQynoeJTn4kkrUkMhi3WmuvTlLtK5uEKx-u6eEr13P9YWK2E0gMn4MRiq-8PNb_VPTgRHW0Uo5DVvyAbIt1V7V7QYJe-mSSoyApzdSaay3lDcrfOF3q--LqEAV1UNq7KL6wfInL8w47oNUK7EAGbBwk25331p_iAgW-h7nspj4y0sZU3ln8YnBczV_7ADLZ2jL7fiRV_r-J1m9-eEhhYQ9FHsRFG5EdyXag_cEsCAM-BrFDERwiTaO2JDTVHcZsBMo9XBeXvPSNEn63Fdk2Mh-6HudtpI5k0JJSDAj14UE0h2H91O0C87fK0v3fIWyppg';

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

  static String route = 'channel';
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
          print(snapshot.data?.usersInside?.map((email) => email.email));
          List<String?>? emails = snapshot.data?.usersInside?.map((email) => email.email).toList();
          return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: emails?.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => {Navigator.pushNamed(context, Chat.route)},
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      height: 50,
                      color: Colors.amber,
                      child: Center(child: Text('${emails?[index]}')),
                    ),
                );

              });
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





