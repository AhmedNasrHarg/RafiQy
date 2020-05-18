import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/pages/community.dart';
import 'package:fluttershare/pages/learn.dart';
import 'package:fluttershare/pages/profile.dart';
import 'package:fluttershare/pages/storyline.dart';
import 'package:fluttershare/pages/chillzone.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() { 
    super.initState();
    pageController = PageController();
    // Detect's when user signed in 
    googleSignIn.onCurrentUserChanged.listen((account) {
      handelSignIn(account);
     }, onError: (err) {
       print('Error signing in: $err');
     });
     // Reauthenticate user when app is opened
     googleSignIn.signInSilently(suppressErrors: false)
     .then((account){
       handelSignIn(account);
     }).catchError((err){
         print('Error signing in: $err');
     });
  }

  handelSignIn(GoogleSignInAccount account){
    if(account != null){
        print('user signes in!: $account');
        setState(() {
          isAuth = true;
        });
      } else {
        setState(() {
          isAuth = false;
        });
      }
  }

  @override
  void dispose() { 
    pageController.dispose();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {  
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut
    );
  }

  Scaffold buildAuthScreen(){
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Profile(),
          Learn(),
          ChillZone(),
          StoryLine(),
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
          BottomNavigationBarItem(icon: Icon(Icons.account_circle),title: Text('Profile')),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline),title: Text('Learn')),
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny,size: 35.0,),title: Text('Chill Zone')),
          BottomNavigationBarItem(icon: Icon(Icons.note),title: Text('Sheets')),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer),title: Text('Community')),
        ],
      ),
    );
    // return RaisedButton(
    //   child: Text('Logout'),
    //   onPressed: logout,
    // );
  }

  Widget buildUnAuthScreen(){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ]
          )
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('CBTTeam',
            style: TextStyle(
              fontFamily: "Signatra",
              fontSize: 90.0,
              color: Colors.white
            ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_signin_button.png'),
                    fit: BoxFit.cover,
                  )
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth? buildAuthScreen() : buildUnAuthScreen();
  }
}
