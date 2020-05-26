
import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String postId;
  final String authorId;
  final String author;
  final String title;
  final String body;
  final String mediaUrl;
  final dynamic likes;

  Post({
   this.postId,
   this.authorId,
   this.author,
   this.title,
   this.body,
   this.mediaUrl,
   this.likes,
  });

  factory Post.fromDocument(DocumentSnapshot doc){
    return Post(
      postId: doc["postId"],
      authorId: doc["authorId"],
      author: doc["author"],
      title: doc["title"],
      body: doc["body"],
      mediaUrl: doc["mediaUrl"],
      likes: doc["likes"],
    );
  }

}