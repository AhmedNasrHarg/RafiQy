import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/language.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/models/post.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/edit_profile.dart';
import 'package:fluttershare/pages/sheets_output.dart';
import 'package:fluttershare/pages/situation-grid.dart';
import 'package:fluttershare/widgets/article.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';
import 'human_body.dart';

class Profile extends StatefulWidget {
  final String profileId;
  Profile({this.profileId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile>with TickerProviderStateMixin {
  String currentUserId = currentUser.id;
  bool isFollowing = false;
  bool isLoading = false;
  int postCount = 0;
  int followerCount = 0;
  int followingCount = 0;
  List<Article> posts = [];
  List<Article> temp;
  bool isProfileOwner;
  int completedSheets=0;
  int completedTopics=0;
  int numUsed=0;
  var connecting=false;
  AnimationController controller;
  void _changeLanguage(Language language) async {
    Locale _temp = await setLocale(language.languageCode);

    MyApp.setLocale(context, _temp);
    print("current lang :${Localizations.localeOf(context).languageCode}");
  }

  @override
  void initState() {
    super.initState();
    isProfileOwner = currentUserId == widget.profileId;
    if (currentUser.isAdmin || !isProfileOwner) {
      getAdminPosts();
      chechIfFollowing();
    } if (currentUser.isAdmin) {
      getFollowers();
    } else if (!currentUser.isAdmin) {
      getFollowing();
    }

    controller = AnimationController(vsync: this)
      ..value = 0.0
      ..addListener(() {
        setState(() {
//          controller.stop();
          // Rebuild the widget at each frame to update the "progress" label.
        });
      });
    getDoneTopics();
    getCompletedDocs();
    getNumberUsed();
    _checkInternetConnectivity();
  }

  @override
  void dispose() {
controller.dispose();
super.dispose();
  }

  chechIfFollowing() async {
    DocumentSnapshot doc = await followerRef
        .document(widget.profileId)
        .collection("userFollowers")
        .document(currentUserId)
        .get();

    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async {
    QuerySnapshot snapshot =  await followerRef
    .document(widget.profileId)
    .collection("userFollowers")
    .getDocuments();

    setState(() {
      followerCount = snapshot.documents.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
    .document(widget.profileId)
    .collection("userFollowing")
    .getDocuments();

    setState(() {
      followingCount = snapshot.documents.length;
    });
  }

  getAdminPosts() async {
    setState(() {
      isLoading = true;
    });
    String docId = isProfileOwner ? currentUserId : widget.profileId;
    QuerySnapshot snapshot = await userRef
        .document(docId)
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
          buildCountColumn(getTranslated(context, "followers"), followerCount)
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildCountColumn(getTranslated(context, "following"), followingCount),
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
            style: TextStyle(
                color: isFollowing ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: isFollowing ? Colors.white : Colors.blue,
              border: Border.all(
                color: isFollowing ? Colors.grey : Colors.blue,
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
      return buildButton(
          text: getTranslated(context, "edit_profile"), function: editProfile);
    } else if (isFollowing) {
      return buildButton(
          text: getTranslated(context, "unfollow"),
          function: handleUnfollowUser);
    } else if (!isFollowing) {
      return buildButton(
          text: getTranslated(context, "follow"), function: handleFollowUser);
    }
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });
    // remove follower
    followerRef
        .document(widget.profileId)
        .collection("userFollowers")
        .document(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
    // remove following
    followingRef
        .document(currentUserId)
        .collection("userFollowing")
        .document(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });
    // Make auth user follower of THAT user (update THEIR followers collection)
    followerRef
        .document(widget.profileId)
        .collection("userFollowers")
        .document(currentUserId)
        .setData({});
    // Put THAT user on YOUR following collection (update your following collection)
    followingRef
        .document(currentUserId)
        .collection("userFollowing")
        .document(widget.profileId)
        .setData({});
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
                  child:
                  Row(children: <Widget>[
                    Text(
                      user.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),

                    Lottie.network("https://assets9.lottiefiles.com/packages/lf20_aDxvEq.json"
                        ,width: 30
                        , height: 30
                        ,controller: controller,
                        onLoaded: (composition)
                        {
                          setState(() {
                            controller.duration=composition.duration*2;
                          });
                        }
                    ),
                    Container(
                      // alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 2.0),
                      child: Text(
                        user.bio,
                      ),
                    ),
                  ],
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
  }

  buildUserProfile() {

  return
//    completed==0?
//  Card(
//
//    color: Colors.teal[100],
//    child: Row(
//      children: <Widget>[
//        Text("هيا تشجع لاكمال الدرس الاول",
//          style: TextStyle(
//            fontFamily: Localizations.localeOf(context).languageCode == "ar"
//                ? "Lemonada"
//                : "Signatra",
//          ),),
//        Lottie.network("https://assets4.lottiefiles.com/packages/lf20_zm1z76.json",width: 100,height: 100)
//
////            Image.asset("assets/images/flower.png")
//      ],
//      mainAxisAlignment: MainAxisAlignment.spaceAround,
//    ),
//  )
//
//     :
    connecting?
  Column(

    children: <Widget>[
      Card(
        color: Colors.teal[100],
    elevation: 10,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children:<Widget>[
            Text(completedTopics==0?getTranslated(context,"first_lesson"):"${getTranslated(context, "finish")}$completedTopics ${getTranslated(context, "from_lesson")} ",
                style: TextStyle(
                  fontFamily: "Tajwal"
                      ,
//        color: Colors.white
                )),
            Lottie.asset(completedTopics==0?"assets/animations/muscle.json":"assets/animations/12833-planta-3.json",width: 100,height: 100)

          ]
        ),

      ),
      Card(
        color: Colors.teal[100],
        elevation: 10,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:<Widget>[
              Column(
                children:<Widget>[ Text(completedSheets==0?getTranslated(context,"first_sheet"):" ${getTranslated(context, "finish")} $completedSheets ${getTranslated(context, "from_sheet")} ",
                    style: TextStyle(
                      fontFamily:
                           "Tajwal",

//        color: Colors.white
                    )),
                 completedSheets>=1? MaterialButton(child: Text(getTranslated(context, "result"),style: TextStyle(fontFamily: "Tajwal"),),onPressed: ()
                 {
                   Navigator.push(context,MaterialPageRoute(builder: (context)=>SheetsOutput()));
                 },color: Colors.teal[200],):Container(color: Colors.teal[100],)
                ]
              ),
              Lottie.asset(completedSheets==0?"assets/animations/muscle.json":"assets/animations/bar.json",width: 100,height: 100)

            ]
        ),

      ),
      Card(
        color: Colors.indigo[700],
        elevation: 10,
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:<Widget>[
              Text(numUsed==0?getTranslated(context,"never_used"):"${getTranslated(context, "use")} $numUsed ${getTranslated(context, "from_chill")} ",
                  style: TextStyle(
                    fontFamily:
                         "Tajwal"
                        ,
        color: Colors.white
                  )),
             numUsed==0? Image.asset("assets/images/sad_tree.png",width: 100,height: 100,):Lottie.asset("assets/animations/music.json",width: 100,height: 100)

            ]
        ),

      )
      ,

//      Lottie.network("https://assets9.lottiefiles.com/packages/lf20_aDxvEq.json"
//    ,width: 200
//    , height: 200
//    ,controller: controller,
//    onLoaded: (composition)
//    {
//    setState(() {
//    controller.duration=composition.duration*2;
//    });
//    }
//    )
    ],
  ):circularProgress();




  }

  ListView buildProfile() {
    bool isProfileOwner = currentUserId == widget.profileId;
    return ListView(
      children: <Widget>[
        buildProfileHeader(),
        Divider(),
        currentUser.isAdmin
            ? buildAdminProfile()
            : isProfileOwner ? buildUserProfile() : buildAdminProfile(),
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
              fontSize: Localizations.localeOf(context).languageCode == "ar"
                  ? 30.0
                  : 50.0,
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
  getCompletedDocs()async
  {

    await userRef
            .document(currentUser.id)
            .collection("completedSheets").getDocuments()
         .then((QuerySnapshot snapshot) {
       snapshot.documents.forEach((f) {
         setState(() {
           completedSheets=completedSheets+1;
           print("Completed $completedSheets");
           controller.value +=(1/6);

         });
       });
       ;
     });



  }

  Future<void> getDoneTopics() async {
    await userRef
        .document(currentUser.id)
        .collection("done_topics")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        setState(() {
          var c = new List<String>.from(f.data['done']);
        completedTopics=completedTopics+c.length;
        controller.value+=(1/6);
        print("Completed $completedTopics");
        });
      });
      ;
    });
  }

  getNumberUsed()async
  {
    await userRef
        .document(currentUser.id)
        .collection("number_used_chill")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        setState(() {
          numUsed=numUsed+1;
        });
      });
      ;
    });



  }
  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
setState(() {
  connecting = false;

});
    } else if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      setState(() {
        connecting = true;

      });
    }
  }

}
