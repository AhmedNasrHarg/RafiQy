import 'package:cloud_firestore/cloud_firestore.dart';

class ChillInteractive {
  String image;
  String title;
  String chillItemId;

  ChillInteractive({this.image, this.title, this.chillItemId});

  factory ChillInteractive.fromDocument(DocumentSnapshot doc)
    {
      return ChillInteractive(
          image: doc["user_item_url"],
          title: doc["user_item_title"],
          chillItemId: doc["user_item_id"]
      );
    }

}