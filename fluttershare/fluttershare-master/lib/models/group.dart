import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String title;
  String photoUrl;
  String chatId;

  Chat({this.title,this.photoUrl,this.chatId});
  
  factory Chat.fromDocument(DocumentSnapshot doc){
    return Chat(
      title: doc["title"],
      photoUrl: doc["photoUrl"],
      chatId: doc["chatId"]
    );
  }
}