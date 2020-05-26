import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/learn_bar.dart';
import 'package:fluttershare/classes/topic.dart';
import 'package:fluttershare/pages/learn_details_page.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

import 'flexible_bar.dart';

class LearnPage extends StatefulWidget {
  LearnPage({Key key}) : super(key: key);
  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  var learnTopics=Topic.learnTopics();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
        body: 
        CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: LearAppBar(),
            pinned: true,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background:FlexibleAppBarWidget()
            ),
          ),
          SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return (
             
                Ink(
                color: learnTopics[index].topicColor,
              child: 
              ListTile(


                title:Center(child:Text(learnTopics[index].topicName,style: TextStyle(color: Colors.white,fontSize: 20,decorationThickness: 2.85)),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LearnDetailsPage(index: index,)));
                  
                },
leading: Container(
              height: 35.0,
              width: 35.0,
              child: Image.asset(learnTopics[index].topicImage),
            ),
              ),
              height: 100,)
              );
            },
            childCount: learnTopics.length,
          ),
        ),
          // ListView.builder(
          //   itemCount: learnTopics.length,
          //   itemBuilder: (context,index)
          //   {
          //      return (Ink(
          //     color: learnTopics[index].topicColor,
          //     child: ListTile(
          //       title:Center(child:Text(learnTopics[index].topicName,style: TextStyle(color: Colors.white,fontSize: 20,decorationThickness: 2.85)),),
          //       onTap: () {
          //         Navigator.pushNamed(context, learnDetailsRoute);
          //       },
          //     ),height: 100,));
          //   }
          //   )
        ],
      ),
  
    );


  }
}


