import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Classes/User.dart';
import 'editUser.dart';
import 'main.dart';


class ProfilUser extends StatefulWidget {
  static String route = 'ProfilUser';

  const ProfilUser({Key? key}) : super(key: key);

  @override
  _ProfilUser createState() => _ProfilUser();
}

class _ProfilUser extends State<ProfilUser> {
  late User user;
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon profil'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.deepPurple,
                    padding: EdgeInsets.all(15),
                    width: double.infinity,
                    child: FutureBuilder<User>(
                      future: futureUser,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data!.roles);
                          return ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: <Widget>[
                              snapshot.data!.profileImage != null ?
                              Container(
                                width: 200,
                                height: 200,
                                child: Stack(
                                  children: <Widget>[
                                     Align(
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const EditUser()),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 200,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(snapshot.data!.profileImage!),
                                      ),
                                    ),
                                  ],
                                ),
                              ) :
                              Center(
                                child: Container(
                                  width: 210,
                                  height: 200,
                                  child: Stack(
                                    children: <Widget>[
                                       Align(
                                        alignment: Alignment.bottomRight,
                                        child: IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const EditUser()),
                                            );
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        height: 200,
                                        child: const CircleAvatar(
                                          backgroundImage: AssetImage("noProfile.png"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(snapshot.data!.firstName! + " " + snapshot.data!.lastName!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      height: 2,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        // By default, show a loading spinner.
                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text("He'd have you all unravel at the"),
                  color: Colors.teal[100],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text('Heed not the rabble'),
                  color: Colors.teal[200],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text('Sound of screams but the'),
                  color: Colors.teal[300],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text('Who scream'),
                  color: Colors.teal[400],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text('Revolution is coming...'),
                  color: Colors.teal[500],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text('Revolution, they...'),
                  color: Colors.teal[600],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _showDialog {
}