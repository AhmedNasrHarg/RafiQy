import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/learn_qa.dart';
import 'package:fluttershare/classes/topic.dart';
import 'package:fluttershare/pages/note_page.dart';
import 'package:video_player/video_player.dart';

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

class _LearnDetailsPageState extends State<LearnDetailsPage> {
  List<String>questions=[];
  List<List<String>>answers=[[]];
  List<LearnQuestionAnswer>dataQuestions=[];
  Topic topic;
  _LearnDetailsPageState(this.topic);
  VideoPlayerController _videoPlayerController;
  var videoURL;
  bool connetcting;

  @override
  void initState() {
    _checkInternetConnectivity();
    videoURL = topic.videoURL;
    getQuestions();


    _videoPlayerController = VideoPlayerController.network(videoURL)
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }
  getQuestions ()
  async {
    final questionRef=Firestore.instance.collection("topic/${topic.topicId}/topic_qa");
    print("hereeeeee topic/${topic.topicId}/topic_qa");
    await questionRef.getDocuments().then((element)
    {
      element.documents.forEach((f) async {
        List<LearnQuestionAnswer>learnAnswr=[];
        var question=await f.data['question'];
        var answer=await new List<String>.from(f.data['answer']);
setState(() {
  questions.add(question);
  for(int i=0;i<answer.length;i++)
  {
    learnAnswr.add(new LearnQuestionAnswer(answer[i]));
  }
  answers.add(answer);
  print("questionsss $question");
  print("answers$answer");
  dataQuestions.add(new LearnQuestionAnswer(question,learnAnswr));
});

      });
    });

  }

  @override
  Widget build(BuildContext context) {
print("lentof queston = ${dataQuestions.length}");
print("${dataQuestions[0].question}");
print("${dataQuestions[0]}");
    // TODO: implement build

  print("topic id ${topic.topicId}");
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
      body: Container(
        child: Column(
          children: <Widget>[

            _videoPlayerController.value.initialized
                ? AspectRatio(
              aspectRatio: _videoPlayerController.value.aspectRatio,
              child: VideoPlayer(_videoPlayerController),
            )
                : Container(),

            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    QAItem(dataQuestions[index]),
                itemCount: dataQuestions.length,


              ),
            )
            // , Text("Test")
          ],
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
      title: Text(root.question,style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
      children: root.answers.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(learnQA);
  }
}
