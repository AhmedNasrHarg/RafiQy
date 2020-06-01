
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/pages/album_grid.dart';
import 'package:fluttershare/pages/album_viewer.dart';

class AlbumPage extends StatefulWidget {
  AlbumPage({Key key}) : super(key: key);
  @override
  _AlbumPageState createState() => _AlbumPageState();
}
// var cardAspecRatio=12.0/16.0;
// var widgetAspectRatio=cardAspecRatio*1.2;

class _AlbumPageState extends State<AlbumPage> with SingleTickerProviderStateMixin {
  // var learnTopics=Topic.learnTopics();
  // var currentPage=albumImages.length-1.0;
  TabController controller;
  @override
  void initState()
  {
    controller=new TabController(length: 2, vsync: this);
    super.initState();
  }
  @override 
  void dispose()
  {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    // PageController controller=PageController(initialPage: albumImages.length-1);
    // controller.addListener(() {
    //   setState((){
    //     currentPage=controller.page;
    //   });
    // });



    return Scaffold(
      backgroundColor:Colors.deepPurple[50],
      appBar: AppBar(
        title: Text(getTranslated(context, 'learn_page')),
        backgroundColor: Colors.teal,
        bottom: TabBar(controller: controller,
        indicatorWeight: 5.0,
        indicatorColor: Colors.deepPurple,
        tabs: <Widget>[
          Tab(icon:new Icon(Icons.image)),
          Tab(icon: new Icon(Icons.grid_on))
        ],),
      ),
     
      body: TabBarView(controller: controller,children: <Widget>[
        AlbumViewer(),
        AlbumGrid()

      ],),



    );
  }
}
