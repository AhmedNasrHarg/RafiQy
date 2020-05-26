import 'package:flutter/material.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/chat_bubble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _text = new TextEditingController();
  var childList = <Widget>[];
  var _scrollController = ScrollController();
  String message = '';
  var sheet = [
    'How are you?',
    'Tell me about your self?',
    'what happened ?',
    'Are you good now ?'
  ];
  int i = 0;
  final databaseReference = Firestore.instance;
  Future<void> getChat() async {
    await databaseReference
        .collection("sheetName")
        .document('userId')
        .get()
        .then((DocumentSnapshot ds) {
      print(ds.data.length);
      i = ((ds.data.length).toInt() / 2).toInt();
      setState(() {
        for (var j = 0; j < ds.data.length; j++) {
          childList.add(ChatBubble(
            isMe: j % 2 == 0,
            message: ds.data['answer$j'],
          ));
        }
      });
      print('hhhhhhhhh');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChat();
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
      ),
      body: SafeArea(
        child: Container(
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
                      child: TextField(
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
                                setState(() {
                                  childList.add(
                                      ChatBubble(isMe: true, message: message));
                                  if (i < sheet.length)
                                    childList.add(ChatBubble(
                                        isMe: false, message: sheet[i++]));
                                  else
                                    childList.add(ChatBubble(
                                        isMe: false,
                                        message:
                                            'you have finished this sheet, thank you'));
                                  _text.text = '';
                                });
                                message = '';

                                Map<String, String> myMap = {};
                                for (var j = 0; j < childList.length; j++) {
                                  myMap['answer$j'] =
                                      (childList.elementAt(j) as ChatBubble)
                                          .message;
                                }
                                //write to firestore
                                databaseReference
                                    .collection('sheetName')
                                    .document('userId')
                                    .setData(myMap);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "please enter a message",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                          ),
                          border: InputBorder.none,
                          hintText: "Enter your message",
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
