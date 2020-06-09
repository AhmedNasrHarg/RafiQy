//Future<String> uploadImage(imageFile) async {
//  StorageUploadTask uploadTask = storageRef.child("post_$postId.jpg").putFile(imageFile);
//  StorageTaskSnapshot storageSnap =  await uploadTask.onComplete;
//  String downloadUrl = await storageSnap.ref.getDownloadURL();
//  return downloadUrl;
//}
//
//compressImage() async {
//  final tempDir = await getTemporaryDirectory();
//  final path = tempDir.path;
//  Im.Image imageFile = Im.decodeImage(widget.imgFile.readAsBytesSync());
//  final compressedImageFile = File('$path/img_$postId.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
//  setState(() {
//    widget.imgFile = compressedImageFile;
//  });
//}
//class ChillInteractvieDetails extends StatefulWidget {
//  @override
//  _ChillInteractvieDetailsState createState() => _ChillInteractvieDetailsState();
//}
//
//class _ChillInteractvieDetailsState extends State<ChillInteractvieDetails> {
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/chill.dart';

class ChillInteractiveDetails extends StatefulWidget {
  Chill itemChill;
  @override
  _ChillInteractiveDetailsState createState() => _ChillInteractiveDetailsState(this.itemChill);
  ChillInteractiveDetails({Key key,this.itemChill}):super(key:key);
}

class _ChillInteractiveDetailsState extends State<ChillInteractiveDetails> {
  Chill itemChill;
  _ChillInteractiveDetailsState(this.itemChill);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemChill.item_title),
      ),
      body: ListView.builder(itemBuilder: null),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}

