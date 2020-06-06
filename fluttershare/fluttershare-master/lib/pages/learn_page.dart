import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/learn_bar.dart';
import 'package:fluttershare/classes/learn_hive.dart';
import 'package:fluttershare/classes/learn_qa.dart';
import 'package:fluttershare/classes/topic.dart';
import 'package:fluttershare/dbs/db_manager.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/learn.dart';
import 'package:fluttershare/pages/learn_details_page.dart';
//import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

import 'flexible_bar.dart';

class LearnPage extends StatefulWidget {
  LearnPage({Key key}) : super(key: key);
  @override
  _LearnPageState createState() => _LearnPageState();
}

Future<bool> checkConnectivity() async {
  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    return false;
  } else if (result == ConnectivityResult.wifi ||
      result == ConnectivityResult.mobile) {
    return true;
  }
}

class _LearnPageState extends State<LearnPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bool isConnected;
    checkConnectivity().then((value) {
      setState(() {
        isConnected = value;
      });
    });

//    if (isConnected)
    getTopicsFromFireStore();
//    else
//      getTopicsFromHive(); //to get data when offline
  }

  Future<void> getTopicsFromFireStore() async {
    await topicRef.getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) async {

       questions.clear();
        // Topic(topicName, videoURL, topicImage, topicColor, isDone)
        print('${f.data}}');
        print('k');
        var questionsRef = Firestore.instance.collection("topic/${f.data['topic_id']}/topic_qa");
        await questionsRef.getDocuments().then((QuerySnapshot topic)
        {
          topic.documents.forEach((element) {
            print(element.data);
            List<String>answers=element.data['answer'];
            List<LearnQuestionAnswer>answerElement=[];
            for(int i=0;i<answers.length;i++)
              {
                answerElement.add(LearnQuestionAnswer(answers[i]));
              }

            LearnQuestionAnswer questionAnswer=new  LearnQuestionAnswer(element.data['question'], answerElement);
            questions.add(questionAnswer);

          });
        });
        Topic topic = new Topic(f.data['topic_id'],f.data['topic_name'], f.data['video_url'],
            f.data['topic_image'], f.data['topic_color'], f.data['is_done'],f.data['num_q'],f.data['num_q_read'],questions);
          print(topic.questions);
        setState(() {
          learnTopics.add(topic);
        });

      });
    });
    //save offline
//    saveToHive();
  }






  Future<void> saveToHive() {
    //to save to hive
    db = DBManager();
    db.saveTopics(learnTopics);
  }

  List<Topic> learnTopics = [];
  List<LearnQuestionAnswer>questions=[];
  DBManager db;
  Future<void> getTopicsFromHive() async {
    print(db);
    db = await DBManager();
    print(db);
    var topics = db.getLearnTopics();
    print(topics);
    topics.then((value) {
      for (int i = 0; i < value.length; i++) {
        print(value[i].topicName + ' ${value[i].isDone} ');
        setState(() {
          learnTopics.add(value[i] as Topic);
        });
      }
//      print(value[0].name);
    });
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   learnTopics = [
  //     Topic("CBT", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
  //         "assets/images/1.png", Colors.deepPurple[200].value, false),
  //     Topic(
  //         "Anexiety",
  //         "https://firebasestorage.googleapis.com/v0/b/cbt-rafiq.appspot.com/o/100611130_243714416727254_6466625261914816512_n.mp4?alt=media&token=df6fe0ef-1218-4535-94f7-d46eea05ebb1",
  //         "assets/images/2.png",
  //         Colors.teal[200].value,
  //         false),
  //     Topic("Worry", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
  //         "assets/images/3.png", Colors.purple[200].value, false),
  //     Topic("Calm", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
  //         "assets/images/4.png", Colors.teal[200].value, false),
  //     Topic("Need", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
  //         "assets/images/5.png", Colors.green[200].value, false),
  //     Topic("Nervious", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
  //         "assets/images/6.png", Colors.cyan[200].value, false),
  //     Topic("CBT", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
  //         "assets/images/7.png", Colors.deepPurple[200].value, false),
  //     Topic("Anexiety", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
  //         "assets/images/8.png", Colors.teal[200].value, false),
  //     Topic("Worry", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
  //         "assets/images/9.png", Colors.purple[200].value, false),
  //     Topic("Calm", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
  //         "assets/images/10.png", Colors.teal[200].value, false),
  //     Topic("Need", "https://www.youtube.com/watch?v=9ZeJSOzd6fs",
  //         "assets/images/11.png", Colors.green[200].value, false),
  //   ];
  //   saveToHive();
  // }

  // Future<void> saveToHive() async {
  //   //to save to hive
  //   db = await DBManager();
  //   db.saveTopics(learnTopics);
  // }

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
                  color: Color(learnTopics[index].topicColor),
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
                                    topic: learnTopics[index],
                                  )));
                    },
                    leading: Container(
                      height: 35.0,
                      width: 35.0,
                      child: Image.network(learnTopics[index].topicImage),
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
