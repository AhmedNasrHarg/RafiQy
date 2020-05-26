import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttershare/models/post.dart';
import 'package:fluttershare/pages/upload_post.dart';
import 'package:fluttershare/widgets/article.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:fluttershare/pages/home.dart';


class Community extends StatefulWidget {

  // final User currentUser;
  // Community({this.currentUser});

  @override
  _CommunityState createState() => _CommunityState();
}



class _CommunityState extends State<Community> {

TextEditingController searchController =  TextEditingController();
Future<QuerySnapshot> searchResultFuture;
bool isAdmin;



handleSearch (String query ){
  Future<QuerySnapshot> posts = postRef
    .where("title", isGreaterThanOrEqualTo: query )
    .getDocuments();
  setState(() {
    searchResultFuture = posts;
  });
}

clearSearch(){
  searchController.clear();
}

  AppBar buildSearchAppBar(){
  return AppBar(
    backgroundColor: Colors.white,
    title: TextFormField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: "Search for an article ...",
        filled: true,
        prefixIcon: Icon(
          Icons.search,
          size: 28.0,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: clearSearch,
        )
      ),
      onFieldSubmitted: handleSearch,
    ),
  );
}

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.portrait ? 300.0 : 200.0,
            ),
            Text(
              "Find Articles",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchResults(){

    return FutureBuilder(
      future: searchResultFuture,
      builder: (context, snapshot) {
        if(!snapshot.hasData){ 
          return circularProgress();
        }
        List<PostResult> searchResults = [];
        snapshot.data.documents.forEach((doc){
          Post post =  Post.fromDocument(doc);
          PostResult searchResult = PostResult(post);
          searchResults.add(searchResult);
        });
        return ListView(
          children: searchResults,
        );
      } 
    );

  }


  @override
  Widget build(BuildContext context) {
    isAdmin = currentUser.isAdmin;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
      appBar: buildSearchAppBar(),
      body: searchResultFuture == null ? buildNoContent() : buildSearchResults(),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPostPhoto()));
          },
          child: Icon(Icons.note_add, color: Theme.of(context).primaryColor,),
          backgroundColor: Colors.white,
        ),
        visible: isAdmin ? true : false,
        )
              
    );
  }
}


class PostResult extends StatelessWidget {

  final Post post;

  PostResult(this.post);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => Article(post: post,isProfile: false,))),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(post.mediaUrl),
              ),
              title: Text(
                post.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
                ),
                subtitle: Text(
                  "By ${post.author}",
                  style: TextStyle(
                    color: Colors.white
                  ),
                  ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}