import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/learn_qa.dart';
import 'package:fluttershare/classes/topic.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/pages/note_page.dart';
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
  bool connetcting;

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
        print('${f.data}}');
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
      for(int i=0;i<done.length;i++){
          if(done[i]==topic_id){
            is_done=true;
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
    videoURL = topic.videoURL;
    getQuestions();
    checkIsDone();

    _videoPlayerController = VideoPlayerController.network(videoURL)
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }

  getQuestions() async {
    final questionRef =
        Firestore.instance.collection("topic/${topic.topicId}/topic_qa");
//    print("hereeeeee topic/${topic.topicId}/topic_qa");
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
//           print("imageslength ${images.length}");
        }

        setState(() {
          if (hasImage) {
            for (int i = 0; i < images.length; i++) {
              topicImages.add(images[i]);
//      print("imagessss ${images[i]}");
            }
            hasImage = false;
            vis = true;
          }
          questions.add(question);
          for (int i = 0; i < answer.length; i++) {
            learnAnswr.add(new LearnQuestionAnswer(answer[i]));
          }
          answers.add(answer);
//  print("questionsss $question");
//  print("answers$answer");
          dataQuestions.add(new LearnQuestionAnswer(question, learnAnswr));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
//print("lentof queston = ${dataQuestions.length}");
//print("${dataQuestions[0].question}");
//print("${dataQuestions[0]}");
    // TODO: implement build

//  print("topic id ${topic.topicId}");
    return Scaffold(
      appBar: AppBar(
        title: Text(topic.topicName),
//          (DemoLocalization.of(context).getTranslatedValues('home_page')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotePage(
                          topic_id: topic.topicId,
                        ))),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 1000,
          child: Column(
            children: <Widget>[
              _videoPlayerController.value.initialized
                  ? AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    )
                  : Container(),
              Visibility(
                child: CarouselSlider(
                    options: CarouselOptions(height: 300),
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
                              height: 400,
                            ))
                        .toList()),
                visible: vis,
              ),
              CheckboxListTile(
                title: Text("is Topic Done"),
                value: is_done,
                onChanged: (newValue) {
                  setState(() {
                    is_done = !is_done;
                    if(is_done){
                      done.add(topic.topicId);
                      addDone(done);
                    }else{
                      done.remove(topic.topicId);
                      addDone(done);
                    }
//                    print(is_done); //firebase
//                    print(topic.topicId);
//                    print(topicRef.document(topic.topicId));
//                    topicRef.document(topic.topicId).setData({
//                      'is_done': is_done,
//                      'num_q': num_q,
//                      'num_q_read': num_q_read,
//                      'topic_color': topic_color,
//                      'topic_id': topic_id,
//                      'topic_image': topic_image,
//                      'topic_name': topic_name,
//                      'video_url': video_url
//                    });
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) =>
                      QAItem(dataQuestions[index]),
                  itemCount: dataQuestions.length,
                ),
              ),

              // , Text("Test")
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _videoPlayerController.value.isPlaying
                ? _videoPlayerController.pause()
                : _videoPlayerController.play();
          });
        },
        child: Icon(
          _videoPlayerController.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
    );
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showDialog(
          'No internet', "You're not connected to a network to view video");
      connetcting = false;
    } else if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      connetcting = true;
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
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
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
