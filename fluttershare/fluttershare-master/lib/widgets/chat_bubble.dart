import 'package:flutter/material.dart';
import 'package:fluttershare/classes/video_provider.dart';
import 'package:fluttershare/models/question.dart';
import 'package:fluttershare/widgets/message_builder.dart';
import 'package:provider/provider.dart';

import 'chat_bubble_typing.dart';
import 'package:fluttershare/models/message.dart';

class ChatBubble extends StatelessWidget {
  bool isMe = false;
  Message msg;
  Question question;
  Function f1;
  Function f2;
  bool isPressed;

  ChatBubble(
      {this.msg, this.question, this.f1, this.f2, this.isPressed = false}) {
    isMe = this.question != null ? false : true;
    // print(DateTime.fromMillisecondsSinceEpoch(msg.timeStamp));
    // print(msg.message);
  }

  Widget msgWidget() {
    if (question != null) {
      return QuesMsgBuilder(
        question: question,
        f1: f1,
        f2: f2,
        isPressed: isPressed,
      );
    } else {
      return Text(
        msg.message,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.fromLTRB(8, 3, 8, 0),
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
          child: msgWidget(),
        ),
      ],
    );
  }
}
