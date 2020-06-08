import 'package:flutter/cupertino.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlay extends StatelessWidget {
  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'iLnmTe5Q2Qw',
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
//        YoutubePlayerController(
//          initialVideoId: 'iLnmTe5Q2Qw',
//          flags: YoutubePlayerFlags(
//            autoPlay: true,
//            mute: true,
//          ),
//        ),
      ],
    );
  }
}
