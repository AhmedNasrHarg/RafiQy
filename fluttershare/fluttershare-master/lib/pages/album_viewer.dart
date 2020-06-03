import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/album.dart';
import 'package:fluttershare/pages/image_viewer.dart';
import 'package:photo_view/photo_view.dart';

class AlbumFavorite extends StatefulWidget {
  AlbumFavorite():super();
  @override
  _AlbumFavoriteState createState() => _AlbumFavoriteState();
}

class _AlbumFavoriteState extends State<AlbumFavorite> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(height: 1000),
        items:albumImages.map((item) =>
            Container(child:
                GestureDetector(
          child: Center(child:

          Image(image: AssetImage(item),)
          ),
                  onTap: ()
                  {
                    print("tapped");
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageViewer(item)));
                  },
        )
            ,height: 1000,)).toList()
      )
    );
  }
}

