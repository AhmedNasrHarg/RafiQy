import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/progress.dart';


class GroupChat extends StatefulWidget {

  final String chatId;
  GroupChat({this.chatId});

  @override
  _GroupChatState createState() => _GroupChatState(chatId: this.chatId);
}

class _GroupChatState extends State<GroupChat> {
    final String chatId;
    _GroupChatState({this.chatId});

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future sendHandle() async {
    if(messageController.text.length > 0){
      await
        chatRef.document(chatId).collection("messages")
        .add({
          "text" : messageController.text,
          "from" : currentUser.username,
          "senderId" : currentUser.id,
          "timestamp" : timestamp
        });
        messageController.clear();
        scrollController.animateTo(scrollController.position.minScrollExtent, duration: Duration(microseconds: 300), curve: Curves.easeOut);
    }
  }

//gs://cbtproject-55d7a.appspot.com
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,titleText: "Welcome to Chat"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatRef.document(chatId).collection("messages").orderBy("timestamp",descending: true).snapshots(),
              builder: (context,snapshot) {
                if(!snapshot.hasData){
                  return Center(
                    child: circularProgress(),
                  );
                }
                List<DocumentSnapshot> docs = snapshot.data.documents;
                List<Widget> messages = docs.map((doc) => Message(
                  from: doc.data["from"],
                  text: doc.data["text"],
                  isMe: currentUser.id == doc.data["senderId"],
                )).toList();
                return ListView(
                  controller: scrollController,
                  reverse: true,
                  children: messages,
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 8.0,left: 8.0,bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter a Message...",
                      border: OutlineInputBorder()
                    ),
                    controller: messageController,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send,size: 35,color: Theme.of(context).accentColor,),
                  onPressed: sendHandle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final String text;
  final Function callback;

  SendButton({this.text,this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(8.0),
      child: FlatButton(
      color: Theme.of(context).accentColor,
      onPressed: callback,
      child: Text(text,style: TextStyle(color: Colors.white),),
    ),
    );
    
  }
}


class Message extends StatelessWidget {

  final String from;
  final String text;
  final bool isMe;
  Message({this.from,this.text,this.isMe});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            from,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold
            ),
          ),
          Material(
            color: isMe? Theme.of(context).accentColor : Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Text(text,style: TextStyle(color: Colors.white,fontSize: 18.0),),
            ),
          ),
        ],
      ),
    );
  }
}