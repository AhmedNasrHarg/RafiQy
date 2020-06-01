import 'dart:async';
import 'package:animator/animator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/models/post.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/custom_image.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:fluttershare/pages/comments.dart';

class Article extends StatefulWidget {
  final Post post;
  final bool isProfile;
  Article({this.post, this.isProfile});

  int getLikeCount(likes) {
    print(likes);
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  _ArticleState createState() => _ArticleState(
      post: this.post,
      likes: this.post.likes,
      likesCount: getLikeCount(this.post.likes));
}

class _ArticleState extends State<Article> {
  final String currentUserId = currentUser.id;
  final Post post;
  int likesCount;
  Map likes;
  bool isLiked;
  bool showHeart = false;
  _ArticleState({this.post, this.likes, this.likesCount});

  buildPostHeader() {
    return FutureBuilder(
      future: userRef.document(post.authorId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photoUrl),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => print("showing profile"),
            child: Text(
              user.username,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text(user.bio),
          trailing: currentUser.isAdmin && user.id == currentUser.id
              ? IconButton(
                  onPressed: () => print("editing post"),
                  icon: Icon(Icons.more_vert),
                )
              : null,
        );
      },
    );
  }

  handleLikeArticle() {
    bool _isLiked = likes[currentUserId] == true;
    if (_isLiked) {
      postRef.document(post.postId).updateData({'likes.$currentUserId': false});
      setState(() {
        likesCount -= 1;
        isLiked = false;
        likes[currentUserId] = false;
      });
    } else if (!_isLiked) {
      postRef.document(post.postId).updateData({'likes.$currentUserId': true});
      setState(() {
        likesCount += 1;
        isLiked = true;
        likes[currentUserId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 500), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  buildPostImage() {
    return GestureDetector(
      onDoubleTap: () => handleLikeArticle(),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          cachedNetworkImage(post.mediaUrl),
          showHeart
              ? Animator(
                  duration: Duration(milliseconds: 300),
                  tween: Tween(begin: 0.8, end: 1.4),
                  curve: Curves.elasticOut,
                  cycles: 0,
                  builder: (context, anim, child) => Transform.scale(
                    scale: anim.value,
                    child: Icon(
                      Icons.favorite,
                      size: 80.0,
                      color: Colors.red,
                    ),
                  ),
                )
              : Text(""),
        ],
      ),
    );
  }

  buildPostContent() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40.0, left: 20.0),
            ),
            GestureDetector(
              onTap: () => handleLikeArticle(),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
            ),
            GestureDetector(
              onTap: () => showComments(context, post: post),
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
            ),
            Visibility(
              visible: widget.isProfile ? true : false,
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Article(
                              post: post,
                              isProfile: false,
                            ))),
                child: SizedBox(
                  width: 270.0,
                  height: 25.0,
                  child: AutoSizeText(
                    post.title,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                margin: EdgeInsets.only(
                    left: 20.0, bottom: widget.isProfile ? 8.0 : 0.0),
                child: Text(
                  "$likesCount ${getTranslated(context,"like")}",
                  style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        Visibility(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                post.body,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          visible: widget.isProfile ? false : true,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentUserId] == true);
    return Card(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.isProfile
                ? Text("")
                : header(context, isAppTitle: false, titleText: post.title),
            Visibility(
              visible: widget.isProfile ? false : true,
              child: buildPostHeader(),
            ),
            Visibility(
              visible: widget.isProfile ? false : true,
              child: buildPostImage(),
            ),
            buildPostContent(),
          ],
        ),
      ),
    );
  }
}

showComments(BuildContext context, {Post post}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Comments(post: post);
  }));
}
