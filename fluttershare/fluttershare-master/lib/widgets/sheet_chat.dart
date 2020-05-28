import 'package:flutter/material.dart';
import 'package:fluttershare/classes/video_provider.dart';
import 'package:fluttershare/models/question.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/chat_bubble.dart';
import 'package:fluttershare/widgets/message_builder.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttershare/models/message.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   TextEditingController _text = new TextEditingController();
//   var childList = <Widget>[];
//   var _scrollController = ScrollController();
//   String message = '';
//   var sheet = [
//     'How are you?',
//     'Tell me about your self?',
//     'what happened ?',
//     'Are you good now ?'
//   ];
//   int i = 0;
//   final databaseReference = Firestore.instance;
//   Future<void> getChat() async {
//     await databaseReference
//         .collection("sheetName")
//         .document('userId')
//         .get()
//         .then((DocumentSnapshot ds) {
//       print(ds.data.length);
//       i = ((ds.data.length).toInt() / 2).toInt();
//       setState(() {
//         for (var j = 0; j < ds.data.length; j++) {
//           childList.add(ChatBubble(
//             isMe: j % 2 == 0,
//             message: ds.data['answer$j'],
//           ));
//         }
//       });
//       print('hhhhhhhhh');
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getChat();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         leading: FlutterLogo(
//           size: 40,
//           colors: Colors.deepOrange,
//         ),
//       ),
//       body: SafeArea(
//         child: Container(
//           child: Stack(
//             fit: StackFit.loose,
//             children: <Widget>[
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Flexible(
//                     fit: FlexFit.tight,
//                     child: Container(
//                       width: MediaQuery.of(context).size.width,
//                       child: SingleChildScrollView(
//                         controller: _scrollController,
//                         reverse: true,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: childList,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 6,
//                   ),
//                   Divider(height: 2, color: Colors.black26),
//                   // SizedBox(
//                   //   height: 50,
//                   Container(
//                     color: Colors.white,
//                     height: 50,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: TextField(
//                         maxLines: 20,
//                         controller: _text,
//                         onChanged: (v) {
//                           message = v;
//                         },
//                         decoration: InputDecoration(
//                           // contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
//                           suffixIcon: IconButton(
//                             icon: Icon(Icons.send),
//                             onPressed: () {
//                               if (message.length > 0) {
//                                 setState(() {
//                                   childList.add(
//                                       ChatBubble(isMe: true, message: message));
//                                   if (i < sheet.length)
//                                     childList.add(ChatBubble(
//                                         isMe: false, message: sheet[i++]));
//                                   else
//                                     childList.add(ChatBubble(
//                                         isMe: false,
//                                         message:
//                                             'you have finished this sheet, thank you'));
//                                   _text.text = '';
//                                 });
//                                 message = '';

//                                 Map<String, String> myMap = {};
//                                 for (var j = 0; j < childList.length; j++) {
//                                   myMap['answer$j'] =
//                                       (childList.elementAt(j) as ChatBubble)
//                                           .message;
//                                 }
//                                 //write to firestore
//                                 databaseReference
//                                     .collection('sheetName')
//                                     .document('userId')
//                                     .setData(myMap);
//                               } else {
//                                 Fluttertoast.showToast(
//                                     msg: "please enter a message",
//                                     toastLength: Toast.LENGTH_SHORT,
//                                     gravity: ToastGravity.CENTER,
//                                     timeInSecForIosWeb: 1,
//                                     textColor: Colors.white,
//                                     fontSize: 16.0);
//                               }
//                             },
//                           ),
//                           border: InputBorder.none,
//                           hintText: "Enter your message",
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _text = new TextEditingController();
  var childList = <Widget>[];
  var chatLog = [];
  var oldChat = [];
  bool isLoading = false;
  var _scrollController = ScrollController();
  String message = '';
  List sheet = [];
  int i = 0;
  var bodyResponseSheet = <Question>[];
  List<Message> oldChat1 = [];
  @override
  void initState() {
    super.initState();
    getBodyResponseSheet();

    //   getOldAnswers();
    //  getQuestions();
  }

  ///////////////////////////////////////////////////////
  Function functionBuilder(str) {
    switch (str) {
      case "مشاهدة":
        return watch;
        break;
      case "أكمل":
        return skipQuestion;
        break;
      case "نعم":
        return skipQuestion;
        break;
      case "لا":
        return nextQuestion;
        break;
      case "المزيد":
        return enableSending;
        break;
      case "انتهيت":
        return sheetDone;
        break;
      default:
        return notFound;
    }
  }

  watch() {
    print("watch");
    setState(() {
      nextBotMessage();
    });
  }

  nextQuestion() {
    // print("nextQuestion");
    setState(() {
      nextBotMessage();
    });
  }

  skipQuestion() {
    print("skipQuestion");
    setState(() {
      i++;
      nextBotMessage();
    });
  }

  enableSending() {
    print("enable Sending");
  }

  sheetDone() {
    print("sheet done");
  }

  notFound() {
    print("Not Found!!");
  }

  ////////////////////////////////////////////

  @override
  void dispose() {
    print("i = $i, len = " + (sheet.length).toString());
    if (i == sheet.length) {}
    saveChat();
    super.dispose();
  }

  getQuestions() async {
    await sheetsRef.document(widget.title).get().then((value) {
      print(value.data);
      setState(() {
        sheet = value.data['questions'];
      });
    });
  }

  getBodyResponseSheet() async {
    setState(() {
      isLoading = true;
    });
    await sheetsRef.document('bodyResponseSheet').get().then((value) {
      value.data['questions'].forEach((e) {
        var q = Map<String, dynamic>.from(e);
        Question qst = Question.fromJson(q);
        bodyResponseSheet.add(qst);
      });
      setState(() {
        isLoading = false;
      });
      var br = bodyResponseSheet[i++];
      childList.add(ChatBubble(
        question: br,
        f1: functionBuilder(br.btnOne),
        f2: functionBuilder(br.btnTwo),
      ));
    });
  }

  getOldAnswers() async {
    await userRef
        .document(currentUser.id)
        .collection("completedSheets")
        .document(widget.title + "Log")
        .get()
        .then((value) {
      print("fffff");
      print(value.data['answers'][0]);
      oldChat = value.data['answers']; //list of map
      value.data['answers'].forEach((element) {
        var m = Map<String, dynamic>.from(element);
        print(m);
        Message msg = Message.fromJson(m);
        oldChat1.add(msg);
        print(msg.message);
        print(m.runtimeType.toString());
        // oldChat1.add(m);
      });
      print(oldChat1.length);
      // oldChat1.clear();
      if (oldChat1.isEmpty) {
        childList.add(ChatBubble(
            msg: Message(
          isMe: false,
          message:
              "We will ask you some questions, answer in many messages you want and type 'Done' when you finished\nType 'Done' if you understand",
        )));
      } else {
        oldChat1.forEach((element) {
          childList.add(new ChatBubble(msg: element));
          if (!element.isMe) i++;
        });
        // oldChat1.forEach((element) { print(element.message);});
      }
      //  debugPrint("oldChat " + oldChat1.first.runtimeType.toString());
    });
  }

  saveChat() async {
    await userRef
        .document(currentUser.id)
        .collection('completedSheets')
        .document(widget.title + "Log")
        .setData({'answers': chatLog});
  }

  void nextBotMessage() {
    if (i < bodyResponseSheet.length) {
      childList.add(ChatBubble(
        question: Question(isTyping: true),
      ));
      Future.delayed(
        Duration(seconds: 4),
        () => setState(() {
          childList.removeLast();
          var m = bodyResponseSheet[i++];
          childList.add(
            ChatBubble(
              question: m,
              f1: functionBuilder(m.btnOne),
              f2: functionBuilder(m.btnTwo),
            ),
          );
          // chatLog.add({
          //   'message': m.message,
          //   'isMe': m.isMe,
          //   'timestamp': m.timeStamp,
          // });
        }),
      );
    }
  }

  List toChild(List oldChat) {
    debugPrint("oldcc" + oldChat.length.toString());
    return List<Message>.from(this.oldChat.map((e) => Message.fromJson(e)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: FlutterLogo(
          size: 40,
          colors: Colors.deepOrange,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Reset"),
            onPressed: () {
              setState(() {
                childList.clear();
                i = 0;
                chatLog.clear();
                childList.add(ChatBubble(
                    msg: Message(
                  isMe: false,
                  message:
                      "We will ask you some questions, answer in many messages you want and type 'Done' when you finished\nType 'Done' if you understand",
                )));
              });
            },
          )
        ],
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: circularProgress())
            : Container(
                child: Stack(
                  fit: StackFit.loose,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          fit: FlexFit.tight,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              reverse: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: childList,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Divider(height: 2, color: Colors.black26),
                        // SizedBox(
                        //   height: 50,
                        Container(
                          color: Colors.white,
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 50,
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.newline,
                                      maxLines: 20,
                                      controller: _text,
                                      onChanged: (v) {
                                        message = v;
                                      },
                                      decoration: InputDecoration(
                                        // contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.send),
                                          onPressed: () {
                                            if (message.length > 0) {
                                              // DO NOT FORGET TO CHECK ARRAY BOUNDARY
                                              setState(() {
                                                if (message
                                                        .toLowerCase()
                                                        .compareTo('done') !=
                                                    0) {
                                                  var m = Message(
                                                      isMe: true,
                                                      message: message);
                                                  childList
                                                      .add(ChatBubble(msg: m));
                                                  chatLog.add({
                                                    'message': m.message,
                                                    'isMe': m.isMe,
                                                    'timestamp': m.timeStamp,
                                                  });
                                                } else {
                                                  nextBotMessage();
                                                }
                                                _text.text = '';
                                              });
                                              message = '';
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "please enter a message",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              print(chatLog);
                                              saveChat();
                                            }
                                          },
                                        ),
                                        border: InputBorder.none,
                                        hintText: "Enter your message",
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.done_all),
                                    iconSize: 24.0,
                                    onPressed: () {
                                      setState(() {
                                        nextBotMessage();
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
