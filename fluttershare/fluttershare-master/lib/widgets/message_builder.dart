import 'package:flutter/material.dart';
import 'package:fluttershare/classes/video_provider.dart';
import 'package:fluttershare/models/question.dart';
import 'package:fluttershare/widgets/chat_bubble_typing.dart';
import 'package:fluttershare/widgets/chat_bubble_video.dart';
import 'package:fluttershare/widgets/chat_buttons.dart';
import 'package:fluttershare/widgets/check_list.dart';
import 'package:provider/provider.dart';

class QuesMsgBuilder extends StatelessWidget {
  final Question question;
  final Function f1;
  final Function f2;
  QuesMsgBuilder({this.question, this.f1, this.f2});

  // Function functionBuilder(str) {
  //   switch (str) {
  //     case "مشاهدة":
  //       return watch;
  //       break;
  //     case "أكمل":
  //       return nextQuestion;
  //       break;
  //     case "نعم":
  //       return skipQuestion;
  //       break;
  //     case "لا":
  //       return nextQuestion;
  //       break;
  //     case "المزيد":
  //       return enableSending;
  //       break;
  //     case "انتهيت":
  //       return sheetDone;
  //       break;
  //     default:
  //       return notFound;
  //   }
  // }

  // watch() {
  //   print("watch");
  // }

  // nextQuestion() {
  //   print("nextQuestion");
  // }

  // skipQuestion() {
  //   print("skipQuestion");
  // }

  // enableSending() {
  //   print("enable Sending");
  // }

  // sheetDone() {
  //   print("sheet done");
  // }

  // notFound() {
  //   print("Not Found!!");
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
        color: Theme.of(context).accentColor,
        child: Column(
          children: <Widget>[
            question.isTyping
                ? BubbleTyping()
                : SizedBox(
                    height: 0.0,
                  ),
            question.body != null
                ? Text(
                    question.body.replaceAll("&#", "\n"),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : SizedBox(
                    height: 0.0,
                  ),
            question.videoUrl != null
                ? BubbleVideo(
                  videoUrl: question.videoUrl,
                )
                : SizedBox(
                    height: 0.0,
                  ),
            question.items != null
                ? checkList(items: question.items)
                : SizedBox(
                    height: 0.0,
                  ),
            question.btnOne != null && question.btnTwo != null
                ? FittedBox(
                    fit: BoxFit.fitWidth,
                    child: ChatButtons(
                      btn1Title: question.btnOne,
                      btn2Title: question.btnTwo,
                      btn1Func: f1,
                      btn2Func: f2,
                    ),
                  )
                : SizedBox(
                    height: 0.0,
                  ),
          ],
        ),
      ),
    );
  }
}
