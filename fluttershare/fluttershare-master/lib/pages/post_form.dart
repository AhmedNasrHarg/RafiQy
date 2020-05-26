import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';
import 'package:fluttershare/pages/home.dart';

class PostForm extends StatefulWidget {

  File imgFile;
  PostForm({this.imgFile,});

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  bool isUploading = false;
  String postId = Uuid().v4();

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(widget.imgFile.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      widget.imgFile = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask = storageRef.child("post_$postId.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap =  await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFirestore({String mediaUrl, String title, String body}){
    userRef
      .document(currentUser.id)
      .collection("userPosts")
      .document(postId)
      .setData({
        "postId": postId,
        "timestamp" : timestamp,
      });
    postRef
      .document(postId)
      .setData({
        "postId" : postId,
        "authorId" : currentUser.id,
        "author" : currentUser.username,
        "title" : title,
        "body" : body,
        "mediaUrl" : mediaUrl,
        "likes" : {}
      });
      _titleController.clear();
      _bodyController.clear();
      setState(() {
        isUploading = false;
      });
      int count = 0;
      Navigator.popUntil(context, (route) {
        return count++ == 2;
      });
  }

  handleSubmit() async{
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(widget.imgFile);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      title: _titleController.text,
      body: _bodyController.text,
    );

  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: false, titleText: "2. Add Article Info", removeBackButton: false, hasAction: true, actionName: "Post", actionFunction: isUploading ? null : handleSubmit),
      body:Form(
        child: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : Text(""),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: FileImage(widget.imgFile)
                    )
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: Container(
              height: 35.0,
              width: 35.0,
              child: Image.asset("assets/images/title.png"),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Write Article Title...",
                  border: InputBorder.none
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Container(
              height: 35.0,
              width: 35.0,
              child: Image.asset("assets/images/pencil.png"),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: _bodyController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Write Article Body",
                  border: InputBorder.none
                ),
              ),
            ),
          )
        ],
      ),
        )
       
      );
  }
}
