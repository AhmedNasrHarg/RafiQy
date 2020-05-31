import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/learn_bar.dart';
import 'package:fluttershare/classes/topic.dart';
import 'package:fluttershare/dbs/db_manager.dart';
import 'package:fluttershare/pages/learn_details_page.dart';
//import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

import 'flexible_bar.dart';

class LearnPage extends StatefulWidget {
  LearnPage({Key key}) : super(key: key);
  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  var learnTopics;
  DBManager db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    learnTopics = [
      Topic("CBT", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
          "assets/images/1.png", Colors.deepPurple[200].value, false),
      Topic(
          "Anexiety",
          "https://firebasestorage.googleapis.com/v0/b/cbt-rafiq.appspot.com/o/100611130_243714416727254_6466625261914816512_n.mp4?alt=media&token=df6fe0ef-1218-4535-94f7-d46eea05ebb1",
          "assets/images/2.png",
          Colors.teal[200].value,
          false),
      Topic("Worry", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
          "assets/images/3.png", Colors.purple[200].value, false),
      Topic("Calm", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
          "assets/images/4.png", Colors.teal[200].value, false),
      Topic("Need", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
          "assets/images/5.png", Colors.green[200].value, false),
      Topic("Nervious", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
          "assets/images/6.png", Colors.cyan[200].value, false),
      Topic("CBT", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
          "assets/images/7.png", Colors.deepPurple[200].value, false),
      Topic("Anexiety", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
          "assets/images/8.png", Colors.teal[200].value, false),
      Topic("Worry", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
          "assets/images/9.png", Colors.purple[200].value, false),
      Topic("Calm", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
          "assets/images/10.png", Colors.teal[200].value, false),
      Topic("Need", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
          "assets/images/11.png", Colors.green[200].value, false),
    ];
    saveToHive();
  }

  Future<void> saveToHive() async {
    //to save to hive
    db = await DBManager();
    db.saveTopics(learnTopics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: LearAppBar(),
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(background: FlexibleAppBarWidget()),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return (Ink(
                  color: learnTopics[index].topicColor,
                  child: ListTile(
                    title: Center(
                      child: Text(learnTopics[index].topicName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              decorationThickness: 2.85)),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearnDetailsPage(
                                    index: index,
                                  )));
                    },
                    leading: Container(
                      height: 35.0,
                      width: 35.0,
                      child: Image.asset(learnTopics[index].topicImage),
                    ),
                  ),
                  height: 100,
                ));
              },
              childCount: learnTopics.length,
            ),
          ),
          // ListView.builder(
          //   itemCount: learnTopics.length,
          //   itemBuilder: (context,index)
          //   {
          //      return (Ink(
          //     color: learnTopics[index].topicColor,
          //     child: ListTile(
          //       title:Center(child:Text(learnTopics[index].topicName,style: TextStyle(color: Colors.white,fontSize: 20,decorationThickness: 2.85)),),
          //       onTap: () {
          //         Navigator.pushNamed(context, learnDetailsRoute);
          //       },
          //     ),height: 100,));
          //   }
          //   )
        ],
      ),
    );
  }
}
