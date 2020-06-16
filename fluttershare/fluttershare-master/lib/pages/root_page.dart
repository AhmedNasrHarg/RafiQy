import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/login_signup_page.dart';
import 'package:fluttershare/services/authentication.dart';
import 'package:shimmer/shimmer.dart';

enum AuthStatus { NOT_DETERMINED, NOT_LOGGED_IN, LOGGED_IN }

class RootPage extends StatefulWidget {
  final BaseAuth auth;

  const RootPage({Key key, this.auth}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildsplashScreen() {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColor
                ])),
            alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: "hero",
                    child: Padding(
                      padding: EdgeInsets.only(top: 70.0),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 70.0,
                              child: Image.asset("assets/images/logo.png")),
                          Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: Colors.amber,
                            child: Text(
                              getTranslated(context, "project_name"),
                              style: TextStyle(
                                  fontFamily: Localizations.localeOf(context)
                                              .languageCode ==
                                          "ar"
                                      ? "Lemonada"
                                      : "Signatra",
                                  fontSize: 100.0,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildsplashScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId != null && _userId.length > 0) {
          return Home(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else {
          return buildWaitingScreen();
        }
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
