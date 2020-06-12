import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/language.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/models/post.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/edit_profile.dart';
import 'package:fluttershare/widgets/article.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';

class Profile extends StatefulWidget {
  final String profileId;
  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String currentUserId = currentUser.id;
  bool isLoading = false;
  int postCount = 0;
  List<Article> posts = [];
  List<Article> temp;
  void _changeLanguage(Language language) async {
    Locale _temp = await setLocale(language.languageCode);

    MyApp.setLocale(context, _temp);
    print("current lang :${Localizations.localeOf(context).languageCode}");
  }

  @override
  void initState() {
    super.initState();
    if (currentUser.isAdmin) {
      getAdminPosts();
    }
  }

  getAdminPosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await userRef
        .document(currentUserId)
        .collection("userPosts")
        .orderBy("timestamp", descending: true)
        .getDocuments();
    if (snapshot.documents.length > 0) {
      snapshot.documents.forEach((post) async {
        temp = [];
        DocumentSnapshot doc = await postRef.document(post["postId"]).get();
        Post article = Post.fromDocument(doc);
        temp.add(Article(
          post: article,
          isProfile: true,
        ));
        setState(() {
          isLoading = false;
          postCount = snapshot.documents.length;
          posts = temp;
        });
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
  

  buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

  buildCountRow(isAdmin) {
    print(isAdmin);
    if (isAdmin) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildCountColumn(getTranslated(context, "articles"), postCount),
          buildCountColumn(getTranslated(context, "followers"), 0)
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildCountColumn(getTranslated(context, "following"), 0),
        ],
      );
    }
  }

  editProfile() async {
    final isUpdated = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditProfile(currentUserId: currentUserId)));
    if (isUpdated) {
      setState(() {
        currentUserId = currentUser.id;
      });
    }
  }

  Container buildButton({String text, Function function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 250.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );
  }

  buildProfileButton() {
    // viewing your own profile - should show profile button
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return buildButton(text: getTranslated(context, "edit_profile"), function: editProfile);
    }
  }

  buildProfileHeader() {
    return FutureBuilder(
      future: userRef.document(widget.profileId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(snapshot.data);
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        buildCountRow(user.isAdmin),
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              buildProfileButton(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                // alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 12.0),
                child: Center(
                  child: Text(
                    user.username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  // alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 2.0),
                  child: Text(
                    user.bio,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  buildAdminProfile() {
    if (isLoading) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/images/no_content.svg', height: 260.0),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "No Articles",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      children: posts,
    );
    // return Column(
    //   children: <Widget>[
    //     Text("Pending comments"),
    //   ],
    // );
  }

  buildUserProfile() {
    
//    return Column(
//      children: <Widget>[
//        Text(getTranslated(context, "still_working"),
//            style: TextStyle(
//              fontSize: 18.0,
//              fontWeight: FontWeight.bold,
//              color: Colors.amber,
//            )),
//        Lottie.network(
//            "https://assets5.lottiefiles.com/packages/lf20_DYkRIb.json"),
//      ],
//    );
  
//  return Text("hel");
  
  
  return Column(
    children: <Widget>[
      Lottie.network("https://assets6.lottiefiles.com/packages/lf20_4zv971.json")
//      Card(
//        child: Row(
//          children: <Widget>[
//            Text("هيا تشجع لاكمال الدرس الاول"),
//            Image.asset("assets/images/flower.png")
//          ],
//        ),
//      )
    ],
  );
  }

  ListView buildProfile() {
    return ListView(
      children: <Widget>[
        buildProfileHeader(),
        Divider(),
        currentUser.isAdmin ? buildAdminProfile() : buildUserProfile(),
      ],
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            getTranslated(context, "project_name") ?? "CBTTeam",
            style: TextStyle(
              color: Colors.white,
              fontFamily: Localizations.localeOf(context).languageCode == "ar"
                  ? "Lemonada"
                  : "Signatra",
              fontSize: Localizations.localeOf(context).languageCode == "ar" ? 30.0 : 50.0,
            ),
          ),
//          (DemoLocalization.of(context).getTranslatedValues('home_page')),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: DropdownButton(
                onChanged: (Language language) {
                  _changeLanguage(language);
                },
                underline: SizedBox(),
                icon: Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                items: Language.languageList()
                    .map((lang) => DropdownMenuItem(
                          value: lang,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(lang.flag),
                              Text(
                                lang.name,
                                style: TextStyle(fontSize: 30),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
            )
          ],
          centerTitle: true,
          backgroundColor: Theme.of(context).accentColor,
        ),
        body: buildProfile());
  }
}
