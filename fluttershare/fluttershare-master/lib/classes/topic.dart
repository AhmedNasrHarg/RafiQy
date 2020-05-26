import 'dart:ui';

import 'package:flutter/material.dart';

class Topic
{
  Topic(this.topicName,this.videoURL,this.topicImage,this.topicColor);
  String topicName;
  String videoURL;
  String topicImage;
  Color topicColor;




 static List<Topic>learnTopics(){
    return<Topic>[
          Topic("CBT","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/images/1.png",Colors.deepPurple[200]),
      Topic("Anexiety","https://firebasestorage.googleapis.com/v0/b/cbt-rafiq.appspot.com/o/100611130_243714416727254_6466625261914816512_n.mp4?alt=media&token=df6fe0ef-1218-4535-94f7-d46eea05ebb1","assets/images/2.png",Colors.teal[200]),
      Topic("Worry","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/images/3.png",Colors.purple[200]),
      Topic("Calm","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/images/4.png",Colors.teal[200]),
      Topic("Need","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/images/5.png",Colors.green[200]),
      Topic("Nervious","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/images/6.png",Colors.cyan[200]),
      Topic("CBT","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/images/7.png",Colors.deepPurple[200]),
      Topic("Anexiety","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/images/8.png",Colors.teal[200]),
      Topic("Worry","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/images/9.png",Colors.purple[200]),
      Topic("Calm","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/images/10.png",Colors.teal[200]),
      Topic("Need","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/images/11.png",Colors.green[200]),
      // Topic("Nervious","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/nerv.jpg",Colors.cyan[200]),
      // Topic("CBT","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/depr.jpg",Colors.deepPurple[200]),
      // Topic("Anexiety","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/foc.png",Colors.teal[200]),
      // Topic("Worry","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/hear.png",Colors.purple[200]),
      // Topic("Calm","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/over.png",Colors.teal[200]),
      // Topic("Need","https://www.youtube.com/watch?v=9ZeJSOzd6fs"," assets/help.png",Colors.green[200]),
      // Topic("Nervious","https://www.youtube.com/watch?v=9ZeJSOzd6fs","assets/nerv.jpg",Colors.cyan[200]),
    ];
  }
}

 