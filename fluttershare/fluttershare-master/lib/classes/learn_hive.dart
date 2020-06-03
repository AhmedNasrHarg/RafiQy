import 'package:flutter/material.dart';
import 'package:fluttershare/classes/topic.dart';
import 'package:fluttershare/classes/topic_questions.dart';
import 'package:fluttershare/dbs/db_manager.dart';
class LearnHive
{List<Topic> learnTopics;
  String userId;
  List<Question> questions = [Question('what is cbt', 'hereis answer1', true)];
  DBManager db;
   LearnHive() {
    learnTopics = [
      Topic("العلاج المعرفي السلوكي", "https://flutter.github.io/assets-for-api-docs//assets/videos/bee.mp4?fbclid=IwAR3zVlWOHIjVyo3cgsWTPuRWaht_lLBBW40KyeojQT4suMmZbFSICTLb2r8",
          "assets/images/1.png", Colors.deepPurple[200].value, false),
      Topic(
          "القلق",
          "https://flutter.github.io/assets-for-api-docs//assets/videos/bee.mp4?fbclid=IwAR3zVlWOHIjVyo3cgsWTPuRWaht_lLBBW40KyeojQT4suMmZbFSICTLb2r8",
          "assets/images/2.png",
          Colors.teal[200].value,
          false),
      Topic("التوتر", "https://flutter.github.io/assets-for-api-docs//assets/videos/bee.mp4?fbclid=IwAR3zVlWOHIjVyo3cgsWTPuRWaht_lLBBW40KyeojQT4suMmZbFSICTLb2r8",
          "assets/images/3.png", Colors.purple[200].value, false),
      Topic("الهدوء", "https://flutter.github.io/assets-for-api-docs//assets/videos/bee.mp4?fbclid=IwAR3zVlWOHIjVyo3cgsWTPuRWaht_lLBBW40KyeojQT4suMmZbFSICTLb2r8",
          "assets/images/4.png", Colors.teal[200].value, false),
      Topic("الإحتياج", "https://flutter.github.io/assets-for-api-docs//assets/videos/bee.mp4?fbclid=IwAR3zVlWOHIjVyo3cgsWTPuRWaht_lLBBW40KyeojQT4suMmZbFSICTLb2r8",
          "assets/images/5.png", Colors.green[200].value, false),
      Topic("العصبية", "https://flutter.github.io/assets-for-api-docs//assets/videos/bee.mp4?fbclid=IwAR3zVlWOHIjVyo3cgsWTPuRWaht_lLBBW40KyeojQT4suMmZbFSICTLb2r8",
          "assets/images/6.png", Colors.cyan[200].value, false),
      Topic("العلاج المعرفي السلوكي", "https://flutter.github.io/assets-for-api-docs//assets/videos/bee.mp4?fbclid=IwAR3zVlWOHIjVyo3cgsWTPuRWaht_lLBBW40KyeojQT4suMmZbFSICTLb2r8",
          "assets/images/7.png", Colors.deepPurple[200].value, false),
      Topic("القلق", "https://flutter.github.io/assets-for-api-docs//assets/videos/bee.mp4?fbclid=IwAR3zVlWOHIjVyo3cgsWTPuRWaht_lLBBW40KyeojQT4suMmZbFSICTLb2r8",
          "assets/images/8.png", Colors.teal[200].value, false),
      Topic("التوتر", "https://flutter.github.io/assets-for-api-docs//assets/videos/bee.mp4?fbclid=IwAR3zVlWOHIjVyo3cgsWTPuRWaht_lLBBW40KyeojQT4suMmZbFSICTLb2r8",
          "assets/images/9.png", Colors.purple[200].value, false),
      Topic("الهدوء", "https://flutter.github.io/assets-for-api-docs//assets/videos/bee.mp4?fbclid=IwAR3zVlWOHIjVyo3cgsWTPuRWaht_lLBBW40KyeojQT4suMmZbFSICTLb2r8",
          "assets/images/10.png", Colors.teal[200].value, false),
      Topic("الحاجة", "https://flutter.github.io/assets-for-api-docs//assets/videos/bee.mp4?fbclid=IwAR3zVlWOHIjVyo3cgsWTPuRWaht_lLBBW40KyeojQT4suMmZbFSICTLb2r8",
          "assets/images/11.png", Colors.green[200].value, false),
    ];

    // take care of null ya nasr [use async await if you need]
//    saveUserId('4823fdf4823948');
//    getUserId();
    saveToHive();
    // getQues();
  //  getData(); // to get topics offline
  }

  Future<void> saveToHive() async {
    //to save to hive
    db = await DBManager();
   db.saveTopics(learnTopics);
    // db.saveQuestions('09201902', 'cbt', questions);
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

  Future<void> getQues() async {
    db = await DBManager();
    var questions = db.getTopicQuestions('09201902', 'cbt');
    questions.then((value) => print(value[0].isDone));
  }



}
