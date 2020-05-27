import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatButtons extends StatelessWidget {
  final String btn1Title;
  final String btn2Title;
  final Function btn1Func;
  final Function btn2Func;
  ChatButtons(@required this.btn1Title, @required this.btn2Title,
      @required this.btn1Func, @required this.btn2Func);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: <Widget>[
        ButtonTheme(
          minWidth: 50,
          child: RaisedButton(
            onPressed: btn1Func,
            child: Text(btn1Title),
            color: Colors.lightGreenAccent,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.zero,
              bottomLeft: Radius.elliptical(0, 15),
              bottomRight: Radius.zero,
            )),
          ),
        ),
        ButtonTheme(
          minWidth: 50,
          child: RaisedButton(
              onPressed: btn2Func,
              child: Text(btn2Title),
              color: Colors.redAccent,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.elliptical(0, 15),
                      bottomLeft: Radius.zero,
                      bottomRight: Radius.circular(25)))),
        ),
      ]),
    );
  }
}
