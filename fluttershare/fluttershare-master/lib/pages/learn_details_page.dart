import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/topic.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LearnDetailsPage extends StatefulWidget {
  int index;
  LearnDetailsPage.learnIndex(int index) {
    this.index = index;
  }
  LearnDetailsPage({Key key, this.index}) : super(key: key);

  @override
  _LearnDetailsPageState createState() => _LearnDetailsPageState(index);
}

var learnTopics;

class _LearnDetailsPageState extends State<LearnDetailsPage> {
  int index;
  _LearnDetailsPageState(this.index);
  YoutubePlayerController _controller;
  VideoPlayerController _videoPlayerController;
  var videoURL;
  bool connetcting = true;

  @override
  void initState() {
    learnTopics = <Topic>[
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
    _checkInternetConnectivity();
    videoURL = learnTopics[index].videoURL;

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
          title: Text(getTranslated(context, 'cbt')),
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
            title: Text(getTranslated(context, 'cbt')),
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
