import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/post.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';


class Article extends StatefulWidget {
  final Post post;
  final bool isProfile;
  Article({this.post,this.isProfile});

  int getLikeCount(likes){
    print (likes);
    // if no likes, return 0
    if(likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val){
      if(val = true){
        count += 1;
      }
    });
    return count;
  }
  @override
  _ArticleState createState() => _ArticleState(post: this.post,likes: this.post.likes, likesCount: getLikeCount(this.post.likes));
}

class _ArticleState extends State<Article> {

  final Post post;
  int likesCount;
  Map likes;
  _ArticleState({this.post,this.likes,this.likesCount});

  buildPostHeader(){
    return FutureBuilder(
      future: userRef.document(post.authorId).get(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return circularProgress();
        }
        User user =  User.fromDocument(snapshot.data);
        return ListTile(
         leading: CircleAvatar(
           backgroundImage: CachedNetworkImageProvider(user.photoUrl),
           backgroundColor: Colors.grey,
         ),
         title: GestureDetector(
           onTap: () => print("showing profile"),
           child: Text(
             user.username,
             style: TextStyle(
               color: Colors.black,
               fontWeight: FontWeight.bold
             ),
           ),
         ),
         subtitle: Text(user.bio), 
         trailing: currentUser.isAdmin && user.id == currentUser.id ? IconButton(
           onPressed: () => print("editing post"),
           icon: Icon(Icons.more_vert),
         ) : null,
        );
      },
    );
  }

  buildPostImage(){
    return GestureDetector(
      onDoubleTap: () => print("liking post"),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(post.mediaUrl),
        ],
      ),
    );
  }

  buildPostContent(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0),),
            GestureDetector(
              onTap: () => print("liking post"),
              child: Icon(
                Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0),),
            GestureDetector(
              onTap: () => print("showing comments"),
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 20.0),),
            Visibility(
              visible: widget.isProfile ? true : false,
              child: GestureDetector(
              onTap: () => print("Go to article"),
              child: Text(
                post.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            ),
               
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0,bottom: widget.isProfile ? 8.0 : 0.0),
              child: Text(
                "$likesCount likes",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
        Visibility(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
          post.body,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
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
    return Card(
      child: SingleChildScrollView(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.isProfile? Text("") : header(context,isAppTitle: false,titleText: post.title),
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