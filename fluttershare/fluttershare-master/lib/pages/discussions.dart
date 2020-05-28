import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/post.dart';
import 'package:fluttershare/widgets/article.dart';
import 'package:fluttershare/widgets/article_tile.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:fluttershare/pages/home.dart';
class Discussion extends StatefulWidget {

  @override
  _DiscussionState createState() => _DiscussionState();
}

class _DiscussionState extends State<Discussion> {


TextEditingController searchController =  TextEditingController();
Future<QuerySnapshot> searchResultFuture;
bool isAdmin;
bool isLoading = false;
List<Article> posts = [];
List<Article> temp;

@override
void initState() { 
  super.initState();
  getPosts();
}

getPosts() async {
  setState(() {
    isLoading = true;
  });
  QuerySnapshot snapshot = await postRef.orderBy("timestamp",descending: true).getDocuments();
  snapshot.documents.forEach((DocumentSnapshot doc) {
    Post post = Post.fromDocument(doc);
    posts.add(Article(post: post,isProfile: false,));
    setState(() {
      isLoading = false;
      posts = posts;
    });
  });
}


// handleSearch (String query ){
//   Future<QuerySnapshot> posts = postRef
//     .where("title", isGreaterThanOrEqualTo: query )
//     .getDocuments();
//   setState(() {
//     searchResultFuture = posts;
//   });
// }

// clearSearch(){
//   searchController.clear();
// }

//   Container buildSearchAppBar(){
//   return Container(
//     width: MediaQuery.of(context).size.width * 0.9,
//     child: TextFormField(
//       controller: searchController,
//       decoration: InputDecoration(
//         hintText: "Search for an article ...",
//         filled: true,
//         prefixIcon: Icon(
//           Icons.search,
//           size: 28.0,
//         ),
//         suffixIcon: IconButton(
//           icon: Icon(Icons.clear),
//           onPressed: clearSearch,
//         )
//       ),
//       onFieldSubmitted: handleSearch,
//     ),
//   );
   
// }

  Container buildNoContent() {
    return Container(
      child: Text("posts will be here"),
    );
  }

  // buildSearchResults(){

  //   return FutureBuilder(
  //       future: searchResultFuture,
  //       builder: (context, snapshot) {
  //         if(!snapshot.hasData){ 
  //           return circularProgress();
  //         }
  //         List<PostResult> searchResults = [];
  //         snapshot.data.documents.forEach((doc){
  //           Post post =  Post.fromDocument(doc);
  //           PostResult searchResult = PostResult(post);
  //           searchResults.add(searchResult);
  //         });
  //         return ListView(
  //           children: searchResults,
  //         );
  //       } 
  //   );
  // }

  buildPostsGrid() {
    if(isLoading){
      return circularProgress();
    }
    List<GridTile> gridTiles = [];
    posts.forEach((post) {
      gridTiles.add(GridTile(child: ArticleTile(article: post,)));
    });
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      mainAxisSpacing: 1.5,
      crossAxisSpacing: 1.5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: gridTiles,
    );
  }


  @override
  Widget build(BuildContext context) {
    isAdmin = currentUser.isAdmin;
    return Container(
      child: Column(
        children: <Widget>[
          // buildSearchAppBar(),
          // searchResultFuture == null ? buildNoContent() : buildSearchResults(),
          buildPostsGrid(),
        ],
      )
    );
  }
}


// class PostResult extends StatelessWidget {

//   final Post post;

//   PostResult(this.post);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).primaryColor.withOpacity(0.7),
//       child: Column(
//         children: <Widget>[
//           GestureDetector(
//             onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => Article(post: post,isProfile: false,))),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.grey,
//                 backgroundImage: CachedNetworkImageProvider(post.mediaUrl),
//               ),
//               title: AutoSizeText(
//                   post.title,
//                   style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),
//                   maxLines: 2,
//                 ),
              
//                 subtitle: Text(
//                   "By ${post.author}",
//                   style: TextStyle(
//                     color: Colors.white
//                   ),
//                   ),
//             ),
//           ),
//           Divider(
//             height: 2.0,
//             color: Colors.white54,
//           ),
//         ],
//       ),
//     );
//   }
// }