import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/models/post.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:fluttershare/models/comment.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

class Comments extends StatefulWidget {
  final Post post;
  Comments({this.post});

  @override
  _CommentsState createState() => _CommentsState(post: post);
}

class _CommentsState extends State<Comments> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController commentController = TextEditingController();
  final Post post;

  _CommentsState({this.post});

  buildComments() {
    return StreamBuilder(
      stream: userRef
          .document(post.authorId)
          .collection("userPosts")
          .document(post.postId)
          .collection("comments")
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<CommentTile> comments = [];
        snapshot.data.documents.forEach((doc) {
          Comment comment = Comment.fromDocument(doc);
          comments.add(CommentTile(comment: comment, post: post));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  addComment() {
    if (currentUser.id != post.authorId) {
      SnackBar snackBar =
          SnackBar(content: Text("${getTranslated(context, "verify_wait")}"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      String commentId = Uuid().v4();
      userRef
          .document(post.authorId)
          .collection("userPosts")
          .document(post.postId)
          .collection("comments")
          .document(commentId)
          .setData({
        "username": currentUser.username,
        "comment": commentController.text,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "avatarUrl": currentUser.photoUrl,
        "userId": currentUser.id,
        "isVerified": false,
        "commentId": commentId
      });
      commentController.clear();
    } else {
      String commentId = Uuid().v4();
      userRef
          .document(post.authorId)
          .collection("userPosts")
          .document(post.postId)
          .collection("comments")
          .document(commentId)
          .setData({
        "username": currentUser.username,
        "comment": commentController.text,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "avatarUrl": currentUser.photoUrl,
        "userId": currentUser.id,
        "isVerified": true,
        "commentId": commentId
      });
      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, titleText: getTranslated(context, "comments")),
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildComments(),
          ),
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
  final Post post;
  final Comment comment;
  CommentTile({this.comment, this.post});

  verifyComment() {
    print("verified");
    userRef
        .document(currentUser.id)
        .collection("userPosts")
        .document(post.postId)
        .collection("comments")
        .document(comment.commentId)
        .updateData({"isVerified": true});
  }

  deleteComment() {
    print("deleted");
    userRef
        .document(currentUser.id)
        .collection("userPosts")
        .document(post.postId)
        .collection("comments")
        .document(comment.commentId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(comment.comment),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(comment.avatarUrl),
            ),
            subtitle: Text(timeago.format(
                DateTime.fromMillisecondsSinceEpoch(comment.timestamp))),
            trailing: Visibility(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onPressed: verifyComment,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.block,
                      color: Colors.red,
                    ),
                    onPressed: deleteComment,
                  )
                ],
              ),
              visible: comment.isVerified
                  ? false
                  : currentUser.isAdmin ? true : false,
            ),
            // Visibility(
            //   child: Container(
            //   height: 35.0,
            //   width: 35.0,
            //   child: Image.asset("assets/images/contact.png")
            //   ),
            //   visible: comment.isVerified ? false : true,
            // ),
          ),
          Divider(),
        ],
      ),
      visible: comment.isVerified
          ? true
          : currentUser.isAdmin && currentUser.id == post.authorId
              ? true
              : false,
    );
  }
}
