import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttershare/classes/chill_interactive.dart';
import 'package:fluttershare/localization/localization_constants.dart';
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
  TextEditingController imageTitleController = new TextEditingController();
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
      appBar: AppBar(title: Text(getTranslated(context, "add_what_you_love")),),
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
        child: Center(
          child:  imageFile==null?Text("No Selected Image"):Image.file(imageFile),
//            TextField(
//              controller: imageTitleController,
//              decoration: InputDecoration(
//                  border: InputBorder.none,
//                  hintText: getTranslated(context, "enter_image_title")
//              ),
//            )
        ),
      ),
    )
      ,
      floatingActionButton:imageFile==null? null:
      FloatingActionButton(child:
      Icon(Icons.file_upload,color: Colors.white,),
        backgroundColor: Colors.teal,
        onPressed: () async {
        var url=await uploadImage(imageFile);

//        print("URL $url");
        String imageId = Uuid().v4();

        Navigator.pop(context,url);
      },
      ),

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

