import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatefulWidget{
  String ImageUrl;
  @override
  _ImageViewerState createState() => _ImageViewerState(this.ImageUrl);
  ImageViewer({Key key,this.ImageUrl}):super(key:key);
}

class _ImageViewerState extends State<ImageViewer> {
  String ImageUrl;
  _ImageViewerState(this.ImageUrl);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  return Container(
    child: 
    PhotoView(imageProvider: AssetImage(ImageUrl),
)
  );

  }
}