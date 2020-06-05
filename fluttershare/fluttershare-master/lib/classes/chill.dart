import 'package:cloud_firestore/cloud_firestore.dart';

class Chill {
  int image_id;
  String image_url;
  String image_title;
  String lottie;
  bool isFavorite;

  Chill({this.image_id, this.image_url, this.image_title, this.isFavorite});

  factory Chill.fromDocument(DocumentSnapshot doc) {
    return Chill(
        image_id: doc["image_id"],
        image_url: doc["image_url"],
        image_title: doc["image_title"],
        isFavorite: doc["isFavorite"]);
  }
}
