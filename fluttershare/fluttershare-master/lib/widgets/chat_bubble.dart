import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;

  ChatBubble({@required this.isMe, @required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.fromLTRB(8, 6, 0, 0),
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).primaryColor
                : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
              minHeight: 30),
          child: Text(
            message,
            style: TextStyle(
              color: isMe
                  ? Colors.white
                  : Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
