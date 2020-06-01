
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/album.dart';
import 'package:fluttershare/pages/image_viewer.dart';
import 'package:photo_view/photo_view.dart';


class AlbumGrid extends StatefulWidget{
  @override
  _AlbumGridState createState() => _AlbumGridState();
}

class _AlbumGridState extends State<AlbumGrid> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
       body: GridView.count(
      crossAxisCount: 2,
      children:List.generate(albumImages.length, (index)  
      {
            return GestureDetector(child:
            Card(
                elevation: 10.0,
                child:Column(children: <Widget>[
                  Container(child:
                  Image.asset(albumImages[index]),width: 150,height: 150,),
                ],)
                
            )
     ,onTap: (){
       print("Tappppped");
          //  PhotoView(imageProvider: AssetImage("assets/images/cbt.png"),)
          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewer(ImageUrl: albumImages[index],),));

        // PhotoView(imageProvider: AssetImage(albumImages[index]));
       }
      );
      })
      ),
      );
  }
}