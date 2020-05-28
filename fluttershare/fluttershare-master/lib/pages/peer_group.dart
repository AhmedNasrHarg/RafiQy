
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/group.dart';
import 'package:fluttershare/pages/group_chat.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/custom_image.dart';
import 'package:fluttershare/widgets/progress.dart';



class PeerGroup extends StatefulWidget {

  @override
  _PeerGroupState createState() => _PeerGroupState();
}

class _PeerGroupState extends State<PeerGroup> {

  bool isLoading = false;
  List<Chat> chats = [];
  @override
  void initState() {
    super.initState();
    getGroups();
  }

  getGroups() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await groupRef.getDocuments();
    snapshot.documents.forEach((DocumentSnapshot doc) { 
      Chat groupChat = Chat.fromDocument(doc);
      chats.add(groupChat);
      setState(() {
        isLoading = false;
      });
    });
  }

  buildGroupsGrid(){
    if(isLoading){
      return circularProgress();
    }
    List<GridTile> gridTiles = [];
    chats.forEach((chat) {
      gridTiles.add(GridTile(
        child: GestureDetector(
          onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => GroupChat(chatId: chat.chatId,))),
          child: Card(
            child:  Stack(
            children: <Widget>[
              cachedNetworkImage(chat.photoUrl),
              Center(
                child: FittedBox(child:Text(chat.title, style: TextStyle(color: Colors.white,fontSize: 30.0, fontWeight: FontWeight.bold),) ) 
              )
              
            ],
          ),
          )
        ) ,
      ));
     });
     return GridView.count(
       crossAxisCount: 2,
       childAspectRatio: 1.0,
       mainAxisSpacing: 1.5,
       crossAxisSpacing: 1.5,
       shrinkWrap: true,
       physics: NeverScrollableScrollPhysics(),
       children: gridTiles,
     );
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: buildGroupsGrid(),
      
      );
    
  }
}