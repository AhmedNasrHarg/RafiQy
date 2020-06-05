import 'package:cloud_firestore/cloud_firestore.dart';

class Chill {
  int image_id;
  String image_url;
  String image_title;
  String lottie;
  bool isFavorite;

  Chill(
      {this.image_id,
      this.image_url,
      this.lottie,
      this.image_title,
      this.isFavorite});

  factory Chill.fromDocument(DocumentSnapshot doc) {
    return Chill(
        image_id: doc["ch_id"],
        image_url: doc["ch_image"],
        lottie: doc['ch_lottie'],
        image_title: doc["ch_name"],
        isFavorite: doc["is_favorite"]);
  }
}
