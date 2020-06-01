import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/topic.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:video_player/video_player.dart';

class LearnDetailsPage extends StatefulWidget {
  Topic index;
  LearnDetailsPage.learnIndex(Topic index) {
    this.index = index;
  }
  LearnDetailsPage({Key key, this.index}) : super(key: key);

  @override
  _LearnDetailsPageState createState() => _LearnDetailsPageState(index);
}

var learnTopics;

class _LearnDetailsPageState extends State<LearnDetailsPage> {
  Topic index;
  _LearnDetailsPageState(this.index);
  VideoPlayerController _videoPlayerController;
  var videoURL;
  bool connetcting = true;

  @override
  void initState() {
    
    _checkInternetConnectivity();
    // videoURL = learnTopics[index].videoURL;
videoURL=index.videoURL;
// _controller =YoutubePlayerController(initialVideoId: YoutubePlayer.convertUrlToId(videoURL));

    _videoPlayerController = VideoPlayerController.network(videoURL)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("index======");
    print(index);
    // TODO: implement build
    if (connetcting == true) {
      print("conneting === $connetcting");
      return Scaffold(
        appBar: AppBar(
          title: Text(index.topicName),
        ),
        // body:
        // Container(
        //         child: Column(
        //           children: <Widget>[
        //             Container(
        //               padding: EdgeInsets.all(10.0),
        //               child:
        //               YoutubePlayer(controller: _controller,),
        //             ),
        //             Container(
        //               padding: EdgeInsets.all(10.0),
        //               child: Text("Kaza kaza "),
        //             ),

        //           ],
        //         ),
        //   )

        body: Center(
          child: _videoPlayerController.value.initialized
              ? AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                )
              : Container(),
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
    } else if (connetcting == false) {
      print('elseeeee');
      return Scaffold(
          appBar: AppBar(
            title: Text(index.topicName),
          ),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: Text("Kaza kaza "),
          ));
    }
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showDialog(
          'No internet', "You're not connected to a network to view video");
      connetcting = false;
    }
    // else if (result == ConnectivityResult.mobile) {
    //   _showDialog(
    //     'Internet access',
    //     "You're connected over mobile data"
    //   );
    // }
    else if (result == ConnectivityResult.wifi ||
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
