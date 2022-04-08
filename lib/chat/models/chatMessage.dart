import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isSender;

  ChatMessage({
    required this.text,
    required this.isSender,
  });


}

List chatMessages = [
  ChatMessage(text: 'Bonjour', isSender: true),
  ChatMessage(text: 'Hello', isSender: false),
  ChatMessage(text: 'ça va ?', isSender: true),
  ChatMessage(text: 'oui et toi ?', isSender: false),
  ChatMessage(text: 'Oui ça va merci', isSender: true),
  ChatMessage(text: 'Ok top', isSender: false),
  ChatMessage(text: 'RDV demain 10h ?', isSender: false),
  ChatMessage(text: 'Au salon', isSender: false),
  ChatMessage(text: 'Très bien', isSender: true),
];

Stream <List<ChatMessage>> get streamMessages => Stream.value(
  chatMessages.map((e) => ChatMessage(text: 'text', isSender: true)).toList()
);
