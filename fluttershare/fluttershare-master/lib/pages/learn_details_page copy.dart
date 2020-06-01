import 'package:cbtproject/classes/topic.dart';
import 'package:cbtproject/localization/localization_constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LearnDetailsPage extends StatefulWidget {
  int index;
  LearnDetailsPage.learnIndex( int index){this.index=index;}
  LearnDetailsPage({Key key,this.index}):super(key:key);

  @override
  _LearnDetailsPageState createState() => _LearnDetailsPageState(index);
}
var learnTopics=Topic.learnTopics();


class _LearnDetailsPageState extends State<LearnDetailsPage> {
  int index;
  _LearnDetailsPageState(this.index);
// YoutubePlayerController _controller;
VideoPlayerController _videoPlayerController;
var videoURL;
bool connetcting;


@override
void initState() {
  _checkInternetConnectivity();
  videoURL =learnTopics[index].videoURL;

_videoPlayerController=VideoPlayerController.network(
        videoURL)
      ..initialize().then((_) {
        setState(() {});
      });
super.initState();
}

@override
  Widget build(BuildContext context) {
    print("index======");
    print(index);
    // TODO: implement build
    if(connetcting==true)
    {
      print("conneting === $connetcting");
    return Scaffold
      (
      appBar: AppBar(
        title: Text(getTranslated(context, 'cbt')),
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
  itemCount: 2,
  itemBuilder: (context,index)
  {
    return(
      // Container(child: Text("text"),)
      Column(children: <Widget>[Container(child:Text("Question")),Container(child: Text("Answer"),)],)
      );
  },
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
    }
    else if(connetcting==false){
      print('elseeeee');
       return Scaffold
      (
      appBar: AppBar(
        title: Text(getTranslated(context, 'cbt')),
      ),
      body:
       Container(
                padding: EdgeInsets.all(10.0),
                child: Text("Kaza kaza "),
              ));
    }
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







