import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/chillzone.dart';
import 'package:fluttershare/pages/community.dart';
import 'package:fluttershare/pages/learn_page.dart';
import 'package:fluttershare/pages/profile.dart';
import 'package:fluttershare/pages/sheets_entery_page.dart';
import 'package:fluttershare/services/authentication.dart';
import 'package:fluttershare/pages/testNotification.dart';
import 'package:fluttershare/pages/video_details.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

final StorageReference storageRef = FirebaseStorage.instance.ref();
final userRef = Firestore.instance.collection("users");
final postRef = Firestore.instance.collection("posts");
final commentRef = Firestore.instance.collection("comments");
final groupRef = Firestore.instance.collection("groups");
final chatRef = Firestore.instance.collection("chats");
final sheetsRef = Firestore.instance.collection("sheets");
final albumRef = Firestore.instance.collection("album");
final topicRef = Firestore.instance.collection("topic");
final chillRef = Firestore.instance.collection("chill_zone");
final notesRef = Firestore.instance.collection("notes");
final followerRef = Firestore.instance.collection("followers");
final followingRef = Firestore.instance.collection("following");
User currentUser;

class Home extends StatefulWidget {

  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  const Home({
    Key key,
    this.userId,
    this.auth,
    this.logoutCallback,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController pageController;
  int pageIndex = 0;


  @override
  void initState() {
    super.initState();
    pageController = PageController();

  }
  


  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }



  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    if (pageIndex == 3) {
      _showWellcomeDialog();
    }
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Profile(
            profileId: widget.userId,
            auth: widget.auth,
            logoutCallback: widget.logoutCallback,
          ),
          LearnPage(),
          ChillZone(),
          EnterySheets(),
          Community(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text(getTranslated(context, "profile"))),
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline),
              title: Text(getTranslated(context, "learn"))),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.wb_sunny,
                size: 35.0,
              ),
              title: Text(getTranslated(context, "chill_zone"))),
          BottomNavigationBarItem(
              icon: Icon(Icons.note),
              title: Text(getTranslated(context, "sheets"))),
          BottomNavigationBarItem(
              icon: Icon(Icons.question_answer),
              title: Text(getTranslated(context, "community"))),
        ],
      ),
    );



  @override
  Widget build(BuildContext context) {
    return  buildAuthScreen();
  }

  _showWellcomeDialog() async {
    bool checkBox;
    await getSharedPref().then((value) {
      print("i am in share pref");
      print("valuee $value");
      checkBox = value;
      print("checkkk $checkBox");
    });
    if (checkBox == false) {
      print("Iam in if check box = false");
      Alert(
          context: context,
          title: "أهلابك في الجزء الأهم في رفيقي ",
          content: Container(
            height: 350,
            width: 350,
            child: FittedBox(
                          child: Column(
                  children: <Widget>[
                    Lottie.asset(
                      'assets/animations/first.json',
                      width: 300,
                      height: 250,
                      fit: BoxFit.fill,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          getTranslated(context, "sheets_message"),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: <Widget>[
                          Text(
              getTranslated(context, "no_show_msg"),
              style: TextStyle(fontSize: 11, color: Colors.teal),
                          ),
                          Checkbox(
              value: noHelloSheet,
//                      onChanged: savePrefs(),
              onChanged: (bool value) {
                setState(() {
                  setHelloSheet(value);
                  noHelloSheet = value;
                });
              },
                          )
                        ],
                      ),
                    )
                  ],
                ),
            ),
          ),
          buttons: [
            DialogButton(
              onPressed: () => Navigator.pop(context),
              child: Text(getTranslated(context, "start_now")),
            ),
//            DialogButton(child: Text(getTranslated(context, "no_show_msg")),onPressed:
//            (){
//              setState(() {
//                setHelloSheet(true);
//                noHelloSheet = true;
//              });
//              Navigator.pop(context);
//            },)
          ]).show();
    } else {
      print("elseee");
//        Alert(
//            context: context,
//            title: "أهلابك في الجزء الأهم في رفيقي ",
//            content: Container(
//              height: 350,
//              width: 350,
//              child: Column(
//                children: <Widget>[
//                  Lottie.asset(
//                    'assets/animations/first.json',
//                    width: 300,
//                    height: 250,
//                    fit: BoxFit.fill,
//                  ),
//                  Expanded(
//                    child: Container(
//                      margin: EdgeInsets.only(top: 5),
//                      child: Text(
//                        "سوف نقوم باعطاء لك شجرة،عليك أن تراعيها حتي تكبر و تصبح جزء من حديقتنا",
//                        maxLines: 3,
//                        overflow: TextOverflow.ellipsis,
//                        textDirection: TextDirection.rtl,
//                        textAlign: TextAlign.justify,
//                        style: TextStyle(fontSize: 15),),
//                    ),
//                  ),
//                  FittedBox(
//
//                    child: Row(
//                      children: <Widget>[
//                        Text("لا تظهر الرسالة مرة أخري",
//                          style: TextStyle(fontSize: 11, color: Colors.teal),),
//                        Checkbox(value: noHelloSheet,
////                      onChanged: savePrefs(),
//                          onChanged: (bool value) {
//                          setState(() {
//                            noHelloSheet=value;
//                          });
//                            setState(() {
//                              setHelloSheet(value);
//                              noHelloSheet=value;
//
//                            });
//                          },
//                        )
//                      ],),
//                  )
//                ],
//              ),
//            ),
//            buttons: [
//              DialogButton(
//                onPressed: () => Navigator.pop(context),
//                child: Text("أبدأ الآن"),
//              )
//            ]).show();
    }
  }

  bool noHelloSheet = false;

  Future<bool> getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final helloSheet = prefs.getBool('hello_sheet');
    if (helloSheet == null) {
      return false;
    }
    return helloSheet;
  }

  Future<void> setHelloSheet(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    bool currentHelloSheet = val;

    await prefs.setBool('hello_sheet', currentHelloSheet);
    setState(() {
      noHelloSheet = currentHelloSheet;
    });
  }
}
