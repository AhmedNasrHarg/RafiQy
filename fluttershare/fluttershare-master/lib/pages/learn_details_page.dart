import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/learn_qa.dart';
import 'package:fluttershare/classes/topic.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/note_page.dart';
import 'package:fluttershare/widgets/chat_bubble.dart';
import 'package:fluttershare/widgets/chat_bubble_video.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

import 'image_viewer.dart';

bool vis = false;

class LearnDetailsPage extends StatefulWidget {
  Topic topic;

  LearnDetailsPage.learnIndex(Topic topic) {
    this.topic = topic;
  }
  LearnDetailsPage({Key key, this.topic}) : super(key: key);

  @override
  _LearnDetailsPageState createState() => _LearnDetailsPageState(topic);
}

var learnTopics;
List<String> topicImages = [];

class _LearnDetailsPageState extends State<LearnDetailsPage> {
  var hasImage;
  List<String> questions = [];
  List<List<String>> answers = [[]];
  List<LearnQuestionAnswer> dataQuestions = [];
  Topic topic;
  _LearnDetailsPageState(this.topic);
  VideoPlayerController _videoPlayerController;
  var videoURL;
  bool connetcting=false;

  var is_done = false;
  var num_q;
  var num_q_read;
  var topic_color;
  var topic_id;
  var topic_image;
  var topic_name;
  var video_url;
  List<String> done = [];

  Future<void> getDoneTopics() async {
    await userRef
        .document(currentUser.id)
        .collection("done_topics")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
//        print('${f.data}}');
        setState(() {
          done = new List<String>.from(f.data['done']);
//                f.data['favourite'].cast<int>();
        });
      });
      ;
    });
  }

  checkIsDone() async {
    await getDoneTopics();
    isDone();
  }

  isDone() {
    setState(() {
      for (int i = 0; i < done.length; i++) {
        if (done[i] == topic.topicId) {
          is_done = true;
          break;
        }
      }
    });
  }

  //to update our done
  addDone(List done) async {
    await userRef
        .document(currentUser.id)
        .collection("done_topics")
        .document("don")
        .setData({"done": done});
  }

  @override
  void initState() {
    _checkInternetConnectivity();
    getQuestions();
    checkIsDone();
setVideoUrl();
    super.initState();
  }

  getQuestions() async {
    final questionRef =
    Firestore.instance.collection("topic/${topic.topicId}/topic_qa");
    await questionRef.getDocuments().then((element) {
      topicImages.clear();
      element.documents.forEach((f) async {
        vis = false;
        List<LearnQuestionAnswer> learnAnswr = [];
        var question = await f.data['question'];
        var answer = await new List<String>.from(f.data['answer']);
        hasImage = await f.data['has_image'];
        var images;
        if (hasImage) {
          images = await f.data['images'];
        }

        setState(() {
          if (hasImage) {
            for (int i = 0; i < images.length; i++) {
              topicImages.add(images[i]);
            }
            hasImage = false;
            vis = true;
          }
          questions.add(question);
          for (int i = 0; i < answer.length; i++) {
            learnAnswr.add(new LearnQuestionAnswer(answer[i]));
          }
          answers.add(answer);

          dataQuestions.add(new LearnQuestionAnswer(question, learnAnswr));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {

//    print("url ${topic.videoURL}");

    // TODO: implement build

//  print("topic id ${topic.topicId}");
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.topicName),
//          (DemoLocalization.of(context).getTranslatedValues('home_page')),
        actions: <Widget>[
          Row(

            children: <Widget>[
              Text(getTranslated(context, "my_notes"),style: TextStyle(color: Colors.white),),
              IconButton(
                icon: Icon(Icons.book),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotePage(
                          topic_id: topic.topicId,
                        ))),
              ),
            ],

          )
        ],
      ),

      body:connetcting? SingleChildScrollView(
        child: Container(
          height:
//          MediaQuery.of(context).size.height,
          1000,
          child: Column(
            children: <Widget>[

             videoURL!=null? BubbleVideo(videoUrl: videoURL,):circularProgress()
            ,
              Visibility(
                child: CarouselSlider(
                    options: CarouselOptions(height: 200),
                    items: topicImages
                        .map((item) => Container(
                      child: GestureDetector(
                        child: Center(
                            child: Image(
                              image: NetworkImage(item),
                            )),
                        onTap: () {
//                            print("tapped");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ImageViewer(item)));
                        },
                      ),
                      height: 300,
                    ))
                        .toList()),
                visible: vis,
              ),

              Container(
                child: Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) =>
                        QAItem(dataQuestions[index]),
                    itemCount: dataQuestions.length,
                  ),
                ),
              ),
//
            ],
          ),
        ),
      ):circularProgress(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(is_done)
            {
              setState(() {
                is_done=false;
                done.remove(topic.topicId);
                addDone(done);
              });
            }
          else
            {
              setState(() {
                is_done = true;
                done.add(topic.topicId);
                addDone(done);
              });

            }
        },
        child:is_done? Icon(Icons.bookmark,color: Colors.amberAccent,):Icon(Icons.bookmark_border,color: Colors.white,),
        backgroundColor: Colors.teal[300],
      ),
    );
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showDialog(
          'No internet', "You're not connected to a network to view video");
      setState(() {
        connetcting = false;

      });
    } else if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      setState(() {
        connetcting = true;

      });
    }
  }

  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text(getTranslated(context, "ok")),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  setVideoUrl()async{
     videoURL=await topic.videoURL;
    }
}

class QAItem extends StatelessWidget {
  const QAItem(this.learnQA);

  final LearnQuestionAnswer learnQA;

  Widget _buildTiles(LearnQuestionAnswer root) {
    if (root.answers.isEmpty) return ListTile(title: Text(root.question));
    return ExpansionTile(
      key: PageStorageKey<LearnQuestionAnswer>(root),
      title: Text(
        root.question,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      children: root.answers.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(learnQA);
  }
}
