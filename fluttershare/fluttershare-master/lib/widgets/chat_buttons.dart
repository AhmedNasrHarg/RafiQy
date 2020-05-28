import 'package:flutter/material.dart';

class ChatButtons extends StatelessWidget {
  final String btn1Title;
  final String btn2Title;
  final Function btn1Func;
  final Function btn2Func;
  ChatButtons(
      {@required this.btn1Title,
      @required this.btn2Title,
      @required this.btn1Func,
      @required this.btn2Func});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: <Widget>[
        RaisedButton(
          onPressed: btn1Func,
          child: Text(btn1Title),
          color: Colors.amber[300],
          textColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.amber,width: 2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.zero,
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.zero,
            ),
          ),
        ),
        RaisedButton(
          onPressed: btn2Func,
          child: Text(btn2Title),
          color: Colors.amber[300],
          textColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.amber,width: 2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.zero,
              topRight: Radius.circular(20),
              bottomLeft: Radius.zero,
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ]),
    );
  }
}
