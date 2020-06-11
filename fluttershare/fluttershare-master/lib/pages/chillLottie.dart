import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChillLottie extends StatefulWidget {
  String lottieUrl;
  @override
  _ChillLottieState createState() => _ChillLottieState(this.lottieUrl);
  ChillLottie({Key key,this.lottieUrl}):super(key:key);
}

class _ChillLottieState extends State<ChillLottie> {
  String lottieUrl;
  _ChillLottieState(this.lottieUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Lottie.network(lottieUrl,width: 500,height: 500)
    );
  }
}
