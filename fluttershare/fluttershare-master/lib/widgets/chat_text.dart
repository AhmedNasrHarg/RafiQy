import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatText extends StatelessWidget {
  final String text;
  ChatText(@required this.text);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            FittedBox(
                child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            )),
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.normal, fontStyle: FontStyle.normal),
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w100),
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
    );
  }
}
