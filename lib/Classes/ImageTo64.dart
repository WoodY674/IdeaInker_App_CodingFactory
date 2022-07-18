import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';


 /// Convert image to base 64
 /// @param File
 /// @return base64 String
 
String imageTo64(File imageFile){
  String? type = lookupMimeType(imageFile.path);
  List<int> fileInByte = imageFile.readAsBytesSync();
  String fileInBase64 = base64Encode(fileInByte);
  String result = "data:$type;base64,$fileInBase64";
  return result;
}