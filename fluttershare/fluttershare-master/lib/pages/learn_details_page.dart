
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/learn_qa.dart';
import 'package:fluttershare/classes/topic.dart';
import 'package:fluttershare/pages/note_page.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LearnDetailsPage extends StatefulWidget {
  Topic topic;
  LearnDetailsPage.learnIndex( Topic topic){this.topic=topic;}
  LearnDetailsPage({Key key,this.topic}):super(key:key);

  @override
  _LearnDetailsPageState createState() => _LearnDetailsPageState(topic);
}
var learnTopics;
//Topic.learnTopics();


class _LearnDetailsPageState extends State<LearnDetailsPage> {
  Topic topic;
  _LearnDetailsPageState(this.topic);
VideoPlayerController _videoPlayerController;
var videoURL;
bool connetcting;


@override
void initState() {
  _checkInternetConnectivity();
  videoURL =topic.videoURL;

_videoPlayerController=VideoPlayerController.network(
        videoURL)
      ..initialize().then((_) {
        setState(() {});
      });
super.initState();
}

@override
  Widget build(BuildContext context) {

    // TODO: implement build
//    if(connetcting==true)
//    {
//      print("conneting === $connetcting");
    return Scaffold
      (
      appBar: AppBar(
        title: Text(topic.topicName),
//          (DemoLocalization.of(context).getTranslatedValues('home_page')),
     actions: <Widget>[IconButton(icon: Icon(Icons.edit),onPressed: ()=>Navigator.push(context, MaterialPageRoute(
       builder: (context)=>NotePage()
     )),)],
      ),
 body: 
 Container(child: Column(children: <Widget>[
   _videoPlayerController.value.initialized
              ? AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                )
              : Container(),
Expanded(child: ListView.builder(
  itemBuilder: (BuildContext context, int index) =>
      QAItem(data[index]),
  itemCount: data.length,

//  {
//    return(
//      // Container(child: Text("text"),)
////      Column(children: <Widget>[Container(child:Text("Question")),Container(child: Text("Answer"),)],)
//      );
//  },
),)
  // , Text("Test")
 ],),)
,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _videoPlayerController.value.isPlaying
                  ? _videoPlayerController.pause()
                  : _videoPlayerController.play();
            });
          },
          child: Icon(
            _videoPlayerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      

   ) ;

//    else if(connetcting==false){
//      print('elseeeee');
//       return Scaffold
//      (
//      appBar: AppBar(
//        title: Text(getTranslated(context, 'cbt')),
//      ),
//      body:
//       Container(
//                padding: EdgeInsets.all(10.0),
//                child: Text("Kaza kaza "),
//              ));
//    }
  }


   _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showDialog(
        'No internet', 
        "You're not connected to a network to view video" 
      );
              connetcting=false;

    }  
    else if (result == ConnectivityResult.wifi||result == ConnectivityResult.mobile) {
      connetcting=true;
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
      }
    );
  }
}

class QAItem extends StatelessWidget {
  const QAItem(this.learnQA);

  final LearnQuestionAnswer learnQA;

  Widget _buildTiles(LearnQuestionAnswer root) {
    if (root.answers.isEmpty) return ListTile(title: Text(root.question));
    return ExpansionTile(
      key: PageStorageKey<LearnQuestionAnswer>(root),
      title: Text(root.question),
      children: root.answers.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(learnQA);
  }
}







