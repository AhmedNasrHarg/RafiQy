import 'package:cloud_firestore/cloud_firestore.dart';

List<String> albumImages = [
  "assets/images/cbt.png",
  "assets/images/guide.jpeg",
  "assets/images/social-anexity.png",
  "assets/images/self-regular.png"
];

List<String> albumTitle = ["CBT", "Guide", "Social Anexity", "Self Regular"];
class Album{
  int image_id;
  String image_url;
  String image_title;
  bool isFavorite;

  Album({this.image_id, this.image_url, this.image_title, this.isFavorite});

  factory Album.fromDocument(DocumentSnapshot doc){
    return Album(
        image_id: doc["image_id"],
        image_url: doc["image_url"],
        image_title: doc["image_title"],
        isFavorite: doc["isFavorite"]
    );
  }

}
