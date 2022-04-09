import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ProfilUser extends StatefulWidget {
  static String route = 'ProfilUser';

  const ProfilUser({Key? key}) : super(key: key);

  @override
  _ProfilUser createState() => _ProfilUser();
}

class _ProfilUser extends State<ProfilUser> {
  String imagePath = "";
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon profil'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.deepPurple,
              padding: EdgeInsets.all(15),
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black)),
                onPressed: () async {
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  // getImage à été remplacé par pickImage ?
                  if (pickedFile != null) {
                    setState(() {
                      imagePath = pickedFile.path;
                    });
                    // Si l'image choisi n'est pas égale à null, fait un setState de imagePath = pickedFile.path;
                  }
                },
                child: Text('Choisi une photo'),
              ),
            ),
            imagePath != ""
                ? Container(
                    color: Colors.deepPurple,
                    //width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Image.file(File(imagePath)),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
