import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/models/post.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:fluttershare/models/comment.dart';
import 'package:timeago/timeago.dart' as timeago;
class Comments extends StatefulWidget {

  final Post post;
  Comments({this.post});

  @override
  _CommentsState createState() => _CommentsState(post: post);
}

class _CommentsState extends State<Comments> {

  TextEditingController commentController = TextEditingController();
  final Post post;
  _CommentsState({this.post});

  buildComments(){
    return StreamBuilder(
      stream: commentRef.document(post.postId).collection("comments")
      .orderBy("timestamp",descending: false).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return circularProgress();
        }
        List<CommentTile> comments = [];
        snapshot.data.documents.forEach((doc){
          Comment comment = Comment.fromDocument(doc);
          comments.add(CommentTile(comment));
        });
        return ListView(children: comments,);
      }, 
    );
  }

  addComment(){
    commentRef
      .document(post.postId)
      .collection("comments")
      .add({
        "username": currentUser.username,
        "comment": commentController.text,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "avatarUrl": currentUser.photoUrl,
        "userId": currentUser.id
      });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,titleText: getTranslated(context,"comments")),
      body: Column(
        children: <Widget>[
          Expanded(child: buildComments(),),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: getTranslated(context, "write_comment"),                
              ),
            ),
            trailing: OutlineButton(
              onPressed: () => addComment(),
              borderSide: BorderSide.none,
              child: Text(getTranslated(context, "post")),
            ),
          )
        ],
      ),
    );
  }
}

class CommentTile extends StatelessWidget {

  final Comment comment;
  CommentTile(this.comment);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment.comment),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(comment.avatarUrl),
          ),
          subtitle: Text(timeago.format(DateTime.fromMillisecondsSinceEpoch(comment.timestamp))),
        ),
        Divider(),
      ],
    );
  }
}