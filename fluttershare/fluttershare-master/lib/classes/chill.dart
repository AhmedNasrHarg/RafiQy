import 'package:cloud_firestore/cloud_firestore.dart';

class Chill {
  int item_id;
  String item_image;
  String item_title;
  String lottie;
  bool isFavorite;
  int numUsed;

  Chill(
      {this.item_id,
      this.item_image,
      this.lottie,
      this.item_title,
      this.isFavorite,
      this.numUsed});

  factory Chill.fromDocument(DocumentSnapshot doc) {
    return Chill(
        item_id: doc["ch_id"],
        item_image: doc["ch_image"],
        lottie: doc['ch_lottie'],
        item_title: doc["ch_name"],
        isFavorite: doc["is_favorite"],
      numUsed: doc["num_used"]

    );
  }
}
