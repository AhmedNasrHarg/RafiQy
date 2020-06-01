import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey =  GlobalKey<FormState>();
  String username;


  submit(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      SnackBar snackBar = SnackBar(content: Text("${getTranslated(context,"welcome")} $username!"));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 2),() {
        Navigator.pop(context, username);
      });
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold( 
      key: _scaffoldKey,
      appBar: header(context, titleText: getTranslated(context, "set_up"), removeBackButton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Text(
                    getTranslated(context, "create_user_name"),
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                  ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Container(
                  child: Form(
                    key: _formKey,
                    autovalidate: true,
                    child: TextFormField(
                      validator: (val) {
                        if(val.trim().length < 3 || val.isEmpty){
                          return getTranslated(context, "user_short");
                        } else if (val.trim().length > 15){
                          return getTranslated(context, "user_long");
                        } else {
                          return null;
                        }

                      },
                      onSaved: (val) => username = val,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: getTranslated(context, "user_name"),
                        labelStyle: TextStyle(fontSize: 15.0),
                        hintText: getTranslated(context, "three_char"),
                      ),
                    ),
                    ),
                ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50.0,
                    width: 350.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(7.0)
                    ),
                    child: Center(child: 
                    Text(
                      getTranslated(context, "submit"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    ),
                  ),
                )
            ],),
          )
        ],
      ),
      );
  }
}
