import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:lottie/lottie.dart';

class StoryLine extends StatefulWidget {
  @override
  _StoryLineState createState() => _StoryLineState();
}

class _StoryLineState extends State<StoryLine> {
  @override
  Widget build(context) {
    return Column(
      children: <Widget>[
        Text(getTranslated(context,"still_working"),
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            )),
        Lottie.network(
            "https://assets4.lottiefiles.com/private_files/lf30_zwcbt8.json"),
      ],
    );
  }
}
