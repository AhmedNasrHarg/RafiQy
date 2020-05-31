import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/question.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/chat_bubble.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttershare/models/message.dart';

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

  saveChat() async {
    DocumentSnapshot sheetlog = await userRef
        .document(currentUser.id)
        .collection('completedSheets')
        .document(widget.title + "Log")
        .get();

    if (sheetlog.exists) {
      if (sheetlog['answer$i'] == null)
        sheetlog.reference.updateData({'answer$i': chatLog});
    } else {
      sheetlog.reference.setData({'answer$i': chatLog});
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
                                                              "please enter a message",
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
                                          hintText: "Enter your message",
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

class ChatText extends StatelessWidget {
  final String text;
  ChatText(@required this.text);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
