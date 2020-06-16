import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/services/authentication.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool _isLoading;
  String _email;
  String _password;
  bool _isLoginForm;
  String _errorMessage;
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  // check if form is valid before perform login or signup
  validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          print("Signed in: $userId");
        } else {
          userId = await widget.auth.signUp(context, _email, _password);
          print("Signed up user : $userId");
        }
        setState(() {
          _isLoading = false;
        });

        if (userId != null && userId.length > 0) {
          if (_isLoginForm) {
            widget.loginCallback();
          } else {
            setState(() {
              _isLoginForm = true;
            });
          }
        }
      } catch (e) {
        print("Error : $e");
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
        showErrorMessage();
      }
    }
  }

  hangleGoogle() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    String userId = "";
    try {
      userId = await widget.auth.signInWithGoogle();
      print("Signed in: $userId");

      setState(() {
        _isLoading = false;
      });

      if (userId != null && userId.length > 0) {
        widget.loginCallback();
      }
    } catch (e) {
      print("Error : $e");
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
        _formKey.currentState.reset();
      });
      showErrorMessage();
    }
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: Stack(
              children: <Widget>[
                _showForm(),
                _showCircularProgress(),
              ],
            )));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            showLogo(),
            showEmailInput(),
            showPasswordInput(),
            showPrimaryButton(),
            showSecondaryButton(),
            showGoogleSignIn(),
          ],
        ),
      ),
    );
  }

  showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return Fluttertoast.showToast(
          msg: _errorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: "hero",
      child: Padding(
        padding: EdgeInsets.only(top: 70.0),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 48.0,
              child: Image.asset("assets/images/logo.png")),
              Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.amber,
                              child: Text(
                  getTranslated(context, "project_name"),
                  style: TextStyle(
                      fontFamily:
                          Localizations.localeOf(context).languageCode == "ar"
                              ? "Lemonada"
                              : "Signatra",
                      fontSize: 50.0,
                      color: Colors.white),
                ),
              ),
          ],       
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 60.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: "Email",
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? "Email can't be empty" : null,
        onSaved: (newValue) => _email = newValue.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: "Password",
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? "password can't be empty" : null,
        onSaved: (newValue) => _password = newValue.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return Padding(
      padding: EdgeInsets.only(top: 45.0),
      child: SizedBox(
        height: 40.0,
        child: RaisedButton(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Colors.tealAccent,
          child: Text(
            _isLoginForm ? "Login" : "Create Account",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          onPressed: validateAndSubmit,
        ),
      ),
    );
  }

  Widget showSecondaryButton() {
    return FlatButton(
      child: Text(
        _isLoginForm ? "Create an Account" : "Have an Account? Sign in",
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
      ),
      onPressed: toggleFormMode,
    );
  }

  Widget showGoogleSignIn() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0),
      child: Column(
        children: <Widget>[
          Text(
            "OR",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          GestureDetector(
            onTap: hangleGoogle,
            child: Container(
              width: 260.0,
              height: 60.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/google_signin_button.png'),
                fit: BoxFit.cover,
              )),
            ),
          )
        ],
      ),
    );
  }
}
