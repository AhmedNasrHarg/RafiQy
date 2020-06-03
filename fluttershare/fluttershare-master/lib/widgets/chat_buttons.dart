import 'package:flutter/material.dart';

class ChatButtons extends StatefulWidget {
  final String btn1Title;
  final String btn2Title;
  final Function btn1Func;
  final Function btn2Func;
  bool isPressed = false;
  ChatButtons(
      {@required this.btn1Title,
      @required this.btn2Title,
      @required this.btn1Func,
      @required this.btn2Func,
      this.isPressed = false});

  @override
  _ChatButtonsState createState() =>
      _ChatButtonsState(isPressed: this.isPressed);
}

class _ChatButtonsState extends State<ChatButtons> {
  bool isPressed;
  _ChatButtonsState({this.isPressed});
  
  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      child: Row(children: <Widget>[
        RaisedButton(
          onPressed: isPressed
              ? () {}
              : () {
                  widget.btn1Func();
                  setState(() {
                    isPressed = true;
                  });
                },
          child: Text(widget.btn1Title),
          color: Colors.amber[300],
          textColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.amber, width: 2),
            borderRadius: BorderRadius.only(
              topLeft: isArabic? Radius.zero:Radius.circular(20),
              topRight: isArabic? Radius.circular(20):Radius.zero,
              bottomLeft: isArabic? Radius.zero:Radius.circular(20),
              bottomRight: isArabic? Radius.circular(20):Radius.zero,
            ),
          ),
        ),
        RaisedButton(
          onPressed: isPressed
              ? () {}
              : () {
                  widget.btn2Func();
                  setState(() {
                    isPressed = true;
                  });
                },
          child: Text(widget.btn2Title),
          color: Colors.amber[300],
          textColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.amber, width: 2),
            borderRadius: BorderRadius.only(
              topLeft: isArabic? Radius.circular(20):Radius.zero,
              topRight: isArabic? Radius.zero:Radius.circular(20),
              bottomLeft: isArabic? Radius.circular(20):Radius.zero,
              bottomRight: isArabic? Radius.zero:Radius.circular(20),
            ),
          ),
        ),
      ]),
    );
  }
}
