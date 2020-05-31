import 'package:flutter/material.dart';
import 'package:fluttershare/classes/topic.dart';
import 'package:fluttershare/dbs/db_manager.dart';

class Learn extends StatefulWidget {
  @override
  _LearnState createState() => _LearnState();
}

class _LearnState extends State<Learn> {
  List<Topic> learnTopics;
  String userId;
  DBManager db;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    learnTopics = [
      Topic("CBToff", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
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
    // take care of null ya nasr [use async await if you need]
    saveUserId('4823fdf4823948');
    getUserId();
    saveToHive();
    getData(); // to get topics offline
  }

  Future<void> saveToHive() async {
    //to save to hive
    db = await DBManager();
    db.saveTopics(learnTopics);
  }

  void saveUserId(String id) {
    db = DBManager();
    db.saveUserId(id);
  }

  Future<String> getUserId() async {
    db = await DBManager();
    var id = db.getUserId();
    await id.then((value) => userId = value);
    print(userId);
  }

  Future<void> getData() async {
    print(db);
    db = await DBManager();
    print(db);
    var topics = db.getLearnTopics();
    topics.then((value) {
      for (int i = 0; i < value.length / 2; i++) {
        print(value[i].topicName + ' ${value[i].isDone} ');
        learnTopics.add(value[i] as Topic);
      }
//      print(value[0].name);
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('yarab'),
      ),
      body: Container(
        child: Text('yarab'),
      ),
    );
  }
}
