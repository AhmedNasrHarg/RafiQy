import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'home.dart';

class ChillInteractiveUpload extends StatefulWidget {
  @override
  _ChillInteractiveUploadState createState() => _ChillInteractiveUploadState();
}

class _ChillInteractiveUploadState extends State<ChillInteractiveUpload> {
  File imageFile;

  Future<void>pickImage(ImageSource imageSource)async{
    var selectedImage=await ImagePicker.pickImage(source: imageSource);
    setState(() {
      imageFile=selectedImage;
    });
  }
  void removeImage()
  {
    setState(() {
      imageFile=null;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("اضف ما تحبه"),),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: ()=>pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: ()=>pickImage(ImageSource.gallery),

            )
          ],
        ),
      ),
      body:
//      Center(
//        child: imageFile==null?Text("No Selected Image"):Image.file(imageFile),
//      )
    SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Center(
              child:  imageFile==null?Text("No Selected Image"):Image.file(imageFile),
            ),
            TextField(
            decoration: InputDecoration(
            border: InputBorder.none,
        hintText: 'ادخل عنوان للصورة'
        ),
        )
          ],
        ),
      ),
    )
      ,
      floatingActionButton:imageFile==null? null:
      FloatingActionButton(child:
      Icon(Icons.play_arrow,color: Colors.white,),
        backgroundColor: Colors.teal,
        onPressed: (){
        var url=uploadImage(imageFile);
        print("URL $url");
      },),

    );
  }

  String imageId = Uuid().v4();


Future<String> uploadImage(imageFile) async {
  StorageUploadTask uploadTask = storageRef.child("im_$imageId.jpg").putFile(imageFile);
  StorageTaskSnapshot storageSnap =  await uploadTask.onComplete;
  String downloadUrl = await storageSnap.ref.getDownloadURL();
  return downloadUrl;
}

}

//import 'dart:io';
//
//import 'package:flutter/cupertino.dart';
//import 'package:image_picker/image_picker.dart';
//
//class ChillInteractiveUpload extends StatefulWidget {
//  @override
//  _ChillInteractiveUploadState createState() => _ChillInteractiveUploadState();
//}
//
//class _ChillInteractiveUploadState extends State<ChillInteractiveUpload> {
//  File imageFile;
//  final imagePicker=ImagePicker();
//  Future getImage()async
//  {
//    final imagePicked=await imagePicker.getImage();
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Container();
//  }
//}
