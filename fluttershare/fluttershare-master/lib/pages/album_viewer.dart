
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/album.dart';
import 'package:fluttershare/classes/card_scroll.dart';

class AlbumViewer extends StatefulWidget {
  @override
  _AlbumViewerState createState() => _AlbumViewerState();
}

var cardAspecRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspecRatio * 1.2;

class _AlbumViewerState extends State<AlbumViewer> {
  var currentPage = albumImages.length - 1.0;
  @override
  Widget build(BuildContext context) {
    PageController controller =
        PageController(initialPage: albumImages.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });
    // TODO: implement build
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //   Padding(padding: const EdgeInsets.only(left: 12.0,right: 12.0),
          //  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //     IconButton(icon: Icon(Icons.menu,
          //       // CustomIcons.menu,
          //       color: Colors.white,size: 30.0),
          //        onPressed: ()=>print("menu pressed")
          //     ),
          //     IconButton(icon: Icon(
          //       Icons.search,
          //       color: Colors.white,
          //       size: 30.0,
          //       ),onPressed: ()=>print("search pressed"))
          //   ],)
          //    ) ,
          Stack(
            children: <Widget>[
              CardScrollWidget(currentPage),
              Positioned.fill(
                child: PageView.builder(
                  itemCount: albumImages.length,
                  controller: controller,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return Container();
                  },
                ),
              )
            ],
          ),
          //  Padding(
          //   padding: EdgeInsets.all(20.0),
          //   child: Text("Reda"),
          // ),
          Row(
            children: <Widget>[
              new Expanded(
                  child: new ListView(
                // scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: <Widget>[],
              ))
            ],
          )
        ],
      ),
    )));
  }
}
