import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/models/question.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/chat_bubble.dart';
import 'package:fluttershare/widgets/check_list.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttershare/models/message.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title,this.sheetName}) : super(key: key);

  final String title;
  final String sheetName;

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
      default:
        return notFound;
    }
  }

  watch() async {
    userMessage('مشاهدة');
    await saveChat();
    print("watch");
    setState(() {
      nextBotMessage();
    });
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
      i++;
      nextBotMessage();
    });
  }

  sheetDone() async {
    // userMessage('انتهيت');

    showDoneCongrats();
    await saveChat(isDone: true);
  }

  showDoneCongrats() {
    Alert(
        context: context,
        title: "أنت تقوم بعمل جيد",
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
              // Navigator.of(context).pop(true);
              // Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("التالي"),
          )
        ]).show();
  }

  notFound() {
    print("Not Found!!");
  }

  ////////////////////////////////////////////

  @override
  void dispose() {
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
    await sheetsRef.document(widget.title).get().then((value) {
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
    await getBodyResponseSheet();
    DocumentSnapshot documentSnapshot = await userRef
        .document(currentUser.id)
        .collection("completedSheets")
        .document(widget.title + "Log")
        .get();
    if (documentSnapshot.exists) {
      getOldChat(documentSnapshot);
      print("Exist");
    }
  }

  void getOldChat(DocumentSnapshot documentSnapshot) {
    i = documentSnapshot['lastAnsIndex'];
    for (int j = 0; j <= documentSnapshot['lastAnsIndex']; j++) {
      oldChat.add(documentSnapshot['answer$j']);
    }
    // print(old)
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

  saveChat({isDone = false}) async {
    DocumentSnapshot sheetlog = await userRef
        .document(currentUser.id)
        .collection('completedSheets')
        .document(widget.title + "Log")
        .get();

    if (sheetlog.exists) {
      if (sheetlog['answer$i'] == null){
        if (isDone) {
        chatLog.clear();
        checkedItems.forEach((e) {
          if(e.media != null)
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
      }else{
        sheetlog.reference.updateData({'answer$i': chatLog, "isDone": isDone});
        }
      }
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
                                                          msg:
                                                              getTranslated(context,"msg_null"),
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                      print(chatLog);
                                                      // saveChat();
                                                    }
                                                  },
                                          ),
                                          border: InputBorder.none,
                                          hintText: getTranslated(context, "enter_msg")
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.done_all),
                                      iconSize: 24.0,
                                      onPressed: isBotTyping
                                          ? () {}
                                          : () async {
                                              userMessage('تم');
                                              await saveChat();
                                              setState(() {
                                                nextBotMessage();
                                                isBotTyping = true;
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
