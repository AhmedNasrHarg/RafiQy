import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {

  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final int timestamp;
  bool isVerified;
  String commentId;


  Comment({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.timestamp,
    this.isVerified = false,
    this.commentId
  });

  factory Comment.fromDocument(DocumentSnapshot doc){
    return Comment(
      username: doc["username"],
      userId: doc["userId"],
      avatarUrl: doc["avatarUrl"],
      comment: doc["comment"],
      timestamp: doc["timestamp"],
      isVerified: doc["isVerified"],
      commentId: doc["commentId"]
    );
  }
}