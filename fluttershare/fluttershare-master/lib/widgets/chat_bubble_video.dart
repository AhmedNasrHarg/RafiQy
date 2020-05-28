import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class BubbleVideo extends StatefulWidget {
  String videoUrl;
  bool isPlaying = false;
  BubbleVideo({this.videoUrl, this.isPlaying, Key key}) : super(key: key);

  @override
  BubbleVideoState createState() => BubbleVideoState();
}

class BubbleVideoState extends State<BubbleVideo> {
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: false,
    );
  }

  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  playVideo() {
    setState(() {
      _videoPlayerController.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Chewie(
            controller: _chewieController,
          ),
        ),
      ),
    );
  }
}
