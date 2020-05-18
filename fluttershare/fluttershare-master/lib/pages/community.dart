import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, titleText: "Community"),
      body: Text("Community"),
    );
  }
}
