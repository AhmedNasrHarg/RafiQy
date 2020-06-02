
import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/pages/upload_post.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/toggle_row.dart';
import 'package:fluttershare/pages/discussions.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/peer_group.dart';

class Community extends StatefulWidget {


  @override
  _CommunityState createState() => _CommunityState();
}



class _CommunityState extends State<Community> {



  bool isDiscuussion = true;
  toggle(String tabIndex){
    if(tabIndex == "tapOne")
    {
      setState(() {
        isDiscuussion = true;
      });
    }
    else {
      setState(() {
        isDiscuussion = false;
      });
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,isAppTitle: false,titleText: getTranslated(context,"community"),removeBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Toggle(context,tapOneTitle: getTranslated(context, "discussions"),tapTwoTitle: getTranslated(context, "groups"),toggleFunction: toggle,),
            isDiscuussion ?  Discussion() : PeerGroup()
        ],
      ),
      ),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPostPhoto()));
          },
          child: Icon(Icons.note_add, color: Theme.of(context).primaryColor,),
          backgroundColor: Colors.white,
        ),
        visible: currentUser.isAdmin && isDiscuussion ? true : false,
        )  
    );
  }
}