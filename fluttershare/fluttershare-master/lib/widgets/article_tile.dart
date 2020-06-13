import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/article.dart';
import 'package:fluttershare/widgets/custom_image.dart';

class ArticleTile extends StatelessWidget {

  final Article article;
  ArticleTile({this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Article(post: article.post,isProfile: false,))),
        child: FittedBox(
          child: Column(
            children: <Widget>[
              Container(
                child: cachedNetworkImage(article.post.mediaUrl),
                height: 150,
                width: 200,
              ),
              Divider(height: 16.0,),
              Center(
                  child: Padding(padding: EdgeInsets.only(right: 8,left: 8),
                      child: FittedBox(fit:BoxFit.fitWidth, 
                    child: Text(article.post.title,style: TextStyle(fontWeight: FontWeight.bold),)),
                  )
                ),
            ],
          ),
        ),
      ),
    );
    
  }
}