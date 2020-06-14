import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/models/question.dart';
import 'package:fluttershare/pages/chillzone.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/human_body.dart';
import 'package:fluttershare/pages/situation-grid.dart';
import 'package:fluttershare/widgets/chat_bubble.dart';
import 'package:fluttershare/widgets/check_list.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttershare/models/message.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.sheetName, this.deleteLast})
      : super(key: key);

  final String title;
  final String sheetName;
  bool deleteLast = false;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _text = new TextEditingController();
  var childList = <Widget>[];
  var chatLog = [];
  var oldChat = <List<dynamic>>[];
  bool isLoading = false;
  var _scrollController = ScrollController();
  String message = '';
  List sheet = [];
  int i = 0;
  int returnTo = 0;
  var bodyResponseSheet = <Question>[];
  List<Message> oldChat1 = [];
  var isBotTyping = false;
  @override
  void initState() {
    super.initState();
    // getBodyResponseSheet();
    buildChat();
    //  getQuestions();
  }

  ///////////////////////////////////////////////////////
  Function functionBuilder(str) {
    switch (str) {
      case "مشاهدة":
        return watch;
        break;
      case "أكمل":
        return compQuestion;
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
      case "اذهب":
        return visit;
        break;
      case "استمرار":
        return continueQestions;
        break;
      case "موقف آخر":
        return jumpTo;
        break;
      default:
        return notFound;
    }
  }

  jumpTo() async {
    userMessage('موقف آخر');
    await saveChat();
    await saveLogSheetOutput();
    i = returnTo;
    setState(() {
      nextBotMessage();
    });
  }

  watch() async {
    userMessage('مشاهدة');
    await saveChat();
    print("watch");
    setState(() {
      nextBotMessage();
    });
  }

  continueQestions() async {
    userMessage('استمرار');
    await saveChat();
    setState(() {
      nextBotMessage();
    });
  }

  visit() async {
    userMessage('اذهب');
    await saveChat();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChillZone()));
  }

  nextQuestion() async {
    // print("nextQuestion");
    userMessage('لا');
    await saveChat();
    setState(() {
      nextBotMessage();
    });
  }

  compQuestion() async {
    userMessage('أكمل');
    await saveChat();
    setState(() {
      i++;
      nextBotMessage();
    });
  }

  skipQuestion() async {
    print("skipQuestion");
    userMessage('نعم');
    await saveChat();
    setState(() {
      i++;
      nextBotMessage();
    });
  }

  enableSending() async {
    userMessage('المزيد');
    await saveChat();
    setState(() {
      // i++;
      nextBotMessage();
    });
  }

  sheetDone() async {
    // userMessage('انتهيت');
    if (widget.title == "logSheet") {
      await saveLogSheetOutput();
    }
    showDoneCongrats();
    await saveChat(isDone: true);
  }

  showDoneCongrats() {
    Alert(
        context: context,
        style: AlertStyle(isCloseButton: false),
        title: getTranslated(context,"good_job"),
        content: Column(
          children: <Widget>[
            Lottie.asset(
              'assets/animations/doing_well.json',
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context, true);
            },
            child: Text(getTranslated(context, "next")),
          )
        ]).show();
  }

  notFound() {
    print("Not Found!!");
  }

  ////////////////////////////////////////////

  @override
  void dispose() {
    //saveLastAnsIndex();
    super.dispose();
  }

  // getQuestions() async {
  //   await sheetsRef.document(widget.title).get().then((value) {
  //     print(value.data);
  //     setState(() {
  //       sheet = value.data['questions'];
  //     });
  //   });
  // }

  getBodyResponseSheet() async {
    setState(() {
      isLoading = true;
    });
    await sheetsRef.document(widget.title).get().then((value) {
      returnTo = value.data['returnTo'];
      value.data['questions'].forEach((e) {
        var q = Map<String, dynamic>.from(e);
        Question qst = Question.fromJson(q);
        bodyResponseSheet.add(qst);
      });
      setState(() {
        isLoading = false;
      });
      var br = bodyResponseSheet[i];
      childList.add(ChatBubble(
        question: br,
        f1: functionBuilder(br.btnOne),
        f2: functionBuilder(br.btnTwo),
      ));
    });
  }

  buildChat() async {
    DocumentSnapshot documentSnapshot = await userRef
        .document(currentUser.id)
        .collection("completedSheets")
        .document(widget.title + "Log")
        .get();
    await getBodyResponseSheet();
    if (documentSnapshot.exists) {
      bool isDone = documentSnapshot['isDone'];
      if (widget.deleteLast != null && widget.deleteLast) {
        userRef
            .document(currentUser.id)
            .collection('completedSheets')
            .document(widget.title + "Log")
            .delete();
      } else if (isDone && widget.title == 'bodyResponseSheet') {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HumanBody()),
        );
      } else if (isDone && widget.title == 'logSheet') {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SituationGrid()),
        );
      } else {
        getOldChat(documentSnapshot);
        print("Exist");
      }
    }
  }

  void getOldChat(DocumentSnapshot documentSnapshot) {
    i = documentSnapshot['lastAnsIndex'];
    for (int j = 0; j <= documentSnapshot['lastAnsIndex']; j++) {
      oldChat.add(documentSnapshot['answer$j']);
    }
    print(oldChat);
    for (int j = 0; j <= documentSnapshot['lastAnsIndex']; j++) {
      if (oldChat[j] != null && oldChat[j].isNotEmpty) {
        if (j == 0) {
          oldChat[j].forEach((m) {
            userMessage(m.toString());
          });
        } else {
          var br = bodyResponseSheet[j];
          childList.add(ChatBubble(
            question: br,
            f1: functionBuilder(br.btnOne),
            f2: functionBuilder(br.btnTwo),
            isPressed: true,
          ));
          oldChat[j].forEach((m) {
            userMessage(m.toString());
          });
        }
      }
      chatLog.clear();
    }
    var br = bodyResponseSheet[i];
    childList.add(ChatBubble(
      question: br,
      f1: functionBuilder(br.btnOne),
      f2: functionBuilder(br.btnTwo),
    ));
    // print(oldChat[0] + oldChat[1]+ oldChat[3]);
  }

  saveLogSheetOutput() async {
    DocumentSnapshot sheetlog = await userRef
        .document(currentUser.id)
        .collection('completedSheets')
        .document(widget.title + "Log")
        .get();

    await userRef
        .document(currentUser.id)
        .collection('logSheetOutput')
        .document(DateTime.now().millisecondsSinceEpoch.toString())
        .get()
        .then((DocumentSnapshot value) async {
      for (int i = 8; i <= 12; i++) {
        if (i != 8) {
          value.reference.updateData({'answer$i': sheetlog['answer$i']});
        } else {
          value.reference.setData({'answer$i': sheetlog['answer$i']});
        }
      }
    });

    // for (int i = 8; i <= 12; i++) {
    //   if (i != 8) {
    //     await sheetOutput.reference.updateData({'answer$i': sheetlog['answer$i']});
    //   } else {
    //     await sheetOutput.reference.setData({'answer$i': sheetlog['answer$i']});
    //   }
    // }
  }

  saveChat({isDone = false}) async {
    DocumentSnapshot sheetlog = await userRef
        .document(currentUser.id)
        .collection('completedSheets')
        .document(widget.title + "Log")
        .get();

    if (sheetlog.exists) {
      // if (sheetlog['answer$i'] == null) {
      if (bodyResponseSheet[i].items != null) {
        chatLog.clear();
        checkedItems.forEach((e) {
          if (e.media != null)
            chatLog.add({
              'name': e.name,
              'type': e.type,
              'media': e.media,
            });
          else
            chatLog.add({
              'name': e.name,
              'type': e.type,
            });
        });
        sheetlog.reference.updateData({'answer$i': chatLog, "isDone": isDone});
      } else {
        sheetlog.reference.updateData({'answer$i': chatLog, "isDone": isDone});
      }
      // }
    } else {
      sheetlog.reference.setData({'answer$i': chatLog, "isDone": isDone});
    }
    chatLog.clear();
    ++i;
  }

  saveLastAnsIndex() async {
    DocumentSnapshot sheetlog = await userRef
        .document(currentUser.id)
        .collection('completedSheets')
        .document(widget.title + "Log")
        .get();
    if (sheetlog.exists) {
      sheetlog.reference.updateData({'lastAnsIndex': i});
    } else {
      sheetlog.reference.setData({'lastAnsIndex': i});
    }
  }

  Future<bool> _showMyDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'حفظ الأجابات',
            textDirection: TextDirection.rtl,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'هل ترغب حفظ أجاباتك لحين\n عودتك مرة أخرى؟',
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'لا أرغب',
                textDirection: TextDirection.rtl,
              ),
              onPressed: () {
                userRef
                    .document(currentUser.id)
                    .collection('completedSheets')
                    .document(widget.title + "Log")
                    .delete();
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text(
                'أرغب',
                textDirection: TextDirection.rtl,
              ),
              onPressed: () {
                saveLastAnsIndex();
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
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
          var m = bodyResponseSheet[i];
          childList.add(
            ChatBubble(
              question: m,
              f1: functionBuilder(m.btnOne),
              f2: functionBuilder(m.btnTwo),
            ),
          );
          isBotTyping = false;
        }),
      );
      saveLastAnsIndex();
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: Duration(microseconds: 300), curve: Curves.easeOut);
    }
  }

  userMessage(String msg) {
    var m = Message(isMe: true, message: msg);
    setState(() {
      if (msg.compareTo('تم') != 0) childList.add(ChatBubble(msg: m));
    });

    chatLog.add(
      m.message,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showMyDialog,
      child: Scaffold(
        appBar: AppBar(
          title: FittedBox(child: Text(widget.sheetName)),
          // actions: <Widget>[
          //   FlatButton(
          //     child: Text("Reset"),
          //     onPressed: () {
          //       setState(() {
          //         childList.clear();
          //         i = 0;
          //         chatLog.clear();
          //         childList.add(ChatBubble(
          //             msg: Message(
          //           isMe: false,
          //           message:
          //               "We will ask you some questions, answer in many messages you want and type 'Done' when you finished\nType 'Done' if you understand",
          //         )));
          //       });
          //     },
          //   )
          // ],
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
                                        textInputAction:
                                            TextInputAction.newline,
                                        maxLines: 20,
                                        controller: _text,
                                        onChanged: (v) {
                                          message = v;
                                        },
                                        decoration: InputDecoration(
                                            // contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                                            suffixIcon: IconButton(
                                              icon: Icon(Icons.send),
                                              onPressed: isBotTyping
                                                  ? () {}
                                                  : () {
                                                      if (message.length > 0) {
                                                        // DO NOT FORGET TO CHECK ARRAY BOUNDARY
                                                        setState(() {
                                                          userMessage(message);
                                                          _text.text = '';
                                                        });
                                                        message = '';
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg: getTranslated(
                                                                context,
                                                                "msg_null"),
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                        print(chatLog);
                                                        // saveChat();
                                                      }
                                                    },
                                            ),
                                            border: InputBorder.none,
                                            hintText: getTranslated(
                                                context, "enter_msg")),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.done_all),
                                      iconSize: 24.0,
                                      onPressed: isBotTyping
                                          ? () {}
                                          : () async {
                                              userMessage('تم');
                                              print(
                                                  "i=$i, sheet = ${bodyResponseSheet.length}");
                                              if (i + 1 >=
                                                  bodyResponseSheet.length) {
                                                await sheetDone();
                                              } else {
                                                await saveChat();
                                                setState(() {
                                                  nextBotMessage();
                                                  isBotTyping = true;
                                                });
                                              }
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
      ),
    );
  }
}

// class ChatText extends StatelessWidget {
//   final String text;
//   ChatText(@required this.text);
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
