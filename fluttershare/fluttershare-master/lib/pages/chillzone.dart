import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:lottie/lottie.dart';

class ChillZone extends StatefulWidget {
  @override
  _ChillZoneState createState() => _ChillZoneState();
}

class _ChillZoneState extends State<ChillZone> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, titleText: getTranslated(context,"chill_zone")),
      body :Column(
      children: <Widget>[
        Text(getTranslated(context,"still_working"),
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            )),
        Lottie.network(
            "https://assets5.lottiefiles.com/packages/lf20_DYkRIb.json"),
      ],
    ),
    ); 
  }
}
