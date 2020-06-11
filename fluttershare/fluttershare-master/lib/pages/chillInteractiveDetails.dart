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
import 'package:fluttershare/classes/chill_interactive.dart';

import 'image_viewer.dart';

class ChillInteractiveDetails extends StatefulWidget {
  Chill itemChill;
  @override
  _ChillInteractiveDetailsState createState() => _ChillInteractiveDetailsState(this.itemChill);
  ChillInteractiveDetails({Key key,this.itemChill}):super(key:key);
}

class _ChillInteractiveDetailsState extends State<ChillInteractiveDetails> {
  Chill itemChill;
  List<ChillInteractive>userImages=[ChillInteractive("https://firebasestorage.googleapis.com/v0/b/cbtproject-55d7a.appspot.com/o/mandala.png?alt=media&token=79805b74-e36a-4032-ac96-0cedaa8ba41c","mandala")];

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  _ChillInteractiveDetailsState(this.itemChill);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemChill.item_title),
      ),
      body:

//      ListView.builder(
//          padding: const EdgeInsets.all(8),
//          itemCount: entries.length,
//          itemBuilder: (BuildContext context, int index) {
//            return Container(
//              height: 50,
//              color: Colors.amber[colorCodes[index]],
//              child: Center(child: Text('Entry ${entries[index]}')),
//            );
//          }      ),




      GridView.count(
          crossAxisCount: 1,
          children:List.generate(userImages.length, (index)
          {
            return
              Card(
                  elevation: 10.0,
                  child:
                    GestureDetector(child:
                    Container(child:
                    Image.network(userImages[index].image),width: 150,height: 120,),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewer(userImages[index].image,),));

                        }
                    ),


              );

          })
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}

