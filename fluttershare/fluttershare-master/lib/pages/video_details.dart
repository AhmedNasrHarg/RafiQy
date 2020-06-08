import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlay extends StatefulWidget {
  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
    flags: YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );
  List<YoutubePlayerController> controllers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < 4; i++) {
      setState(() {
        controllers.add(YoutubePlayerController(
          initialVideoId: 'iLnmTe5Q2Qw',
          flags: YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youga'),
      ),
      body: SingleChildScrollView(
        child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            children: controllers.map((e) {
              return FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: YoutubePlayer(
                    controller: e,
                    showVideoProgressIndicator: true,
                  ),
                ),
              );
            }).toList()),
      ),
    );
  }
}
