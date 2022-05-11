import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thebestatoo/Classes/Salon.dart';
import 'dart:io';
import '../Classes/CoordinatesStore.dart';
import 'main.dart';

final token = preferences.getString('token', defaultValue: '').getValue();

class Posts extends StatefulWidget {
  static String route = 'addPost';
  const Posts({Key? key}) : super(key: key);

  @override
  _Posts createState() => _Posts();
}

class _Posts extends State<Posts> {
  TextEditingController contentController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  String imagePath = "";
  final picker = ImagePicker();
  File imageFile = File("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau Post'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Créer un Post',
                  style: TextStyle(fontSize: 20),
                )
            ),
            imageFile.path != "" ?
            // Affichage de l'image
            Image.file(imageFile)
                : Container(),
            Container(
              child:
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black)),
                  onPressed: () async {
                    if (await Permission.photos.request().isGranted) {
                      // Either the permission was already granted before or the user just granted it.
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      // getImage à été remplacé par pickImage ?
                      print(pickedFile);
                      if (pickedFile != null) {
                        setState(() {
                          imageFile = File(pickedFile.path);
                        });
                      }
                    }else{
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.photos,
                      ].request();
                      //print(statuses[Permission.photos]); print status accés photos
                    }
                  },
                  child: imageFile.path != "" ? // C'est le if
                  const Text("Modifier la photo")
                      : const Text("Ajouter une photo") // : = else
              ),
            ),
            imageFile.path != "" ?
            Container(
              child:
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black)),
                  onPressed: () {
                    setState(() {
                      imageFile = File("");
                    });
                    // Si l'image choisi n'est pas égale à null, fait un setState de imagePath = pickedFile.path;
                  },
                  child: const Text("Supprimer la photo")
              ),
            ): Container(),
            Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Content',
                  ),
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                child: ElevatedButton(
                  child: const Text('Register'),
                  onPressed: () {
                    String fileInBase64 = "";
                    if(imageFile.path != ""){
                      List<int> fileInByte = imageFile.readAsBytesSync();
                      fileInBase64 = base64Encode(fileInByte);
                    }
                    String nomCreateur = "Emerick Chalet";
                    addPost(contentController.text, fileInBase64,nomCreateur);
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.deepPurple)
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
  Future<void> addPost(String content, String image64, String nomCreateur) async {
    final now = DateTime.now();

        print("début response");
        final responsePost = await http.post(
          Uri.parse('http://ideainker.fr/api/posts'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            HttpHeaders.authorizationHeader: "Bearer $token",
          },
          body: jsonEncode(<String, String>{
            'content': content,
            'image': image64,
            'createdAt': now.toString(),
            'createdBy': nomCreateur,
          }),
        );
        print(responsePost.body);
      if (responsePost.statusCode == 201) {
        // If the server did return a 201 CREATED response,
        // then parse the JSON.
        log("Post creer");
        Fluttertoast.showToast(
            msg: "Post added with Success!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.pop(context);
      }else{
        Fluttertoast.showToast(
            msg: "Failed create Post",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
  }
}
