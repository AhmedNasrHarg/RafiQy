import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:image_picker/image_picker.dart';

import 'post_form.dart';

class UploadPostPhoto extends StatefulWidget {
  @override
  _UploadPostPhotoState createState() => _UploadPostPhotoState();
}

class _UploadPostPhotoState extends State<UploadPostPhoto> {
  handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
    if (file != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostForm(
                    imgFile: file,
                  )));
    }
  }

  handleChooseFromGallery() async {
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostForm(
                    imgFile: file,
                  )));
    }
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              getTranslated(parentContext, "choose_img"),
              textAlign:
                  Localizations.localeOf(parentContext).languageCode == "ar"
                      ? TextAlign.end
                      : TextAlign.start,
            ),
            children: <Widget>[
              SimpleDialogOption(
                  child: Text(
                    getTranslated(parentContext, "cam_img"),
                    textAlign:
                        Localizations.localeOf(parentContext).languageCode ==
                                "ar"
                            ? TextAlign.end
                            : TextAlign.start,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    handleTakePhoto();
                  }),
              SimpleDialogOption(
                  child: Text(
                    getTranslated(parentContext, "gallery_img"),
                    textAlign:
                        Localizations.localeOf(parentContext).languageCode ==
                                "ar"
                            ? TextAlign.end
                            : TextAlign.start,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    handleChooseFromGallery();
                  }),
              SimpleDialogOption(
                child: Text(
                  getTranslated(parentContext, "cancel"),
                  textAlign:
                      Localizations.localeOf(parentContext).languageCode == "ar"
                          ? TextAlign.end
                          : TextAlign.start,
                ),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  Container buildSplashScreesn() {
    return Container(
        color: Theme.of(context).accentColor.withOpacity(0.6),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset("assets/images/upload.svg", height: 260.0),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Text(
                    getTranslated(context, "upload_img"),
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  ),
                  color: Colors.deepOrange,
                  onPressed: () => selectImage(context),
                ),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context,
            isAppTitle: false,
            titleText: getTranslated(context, "upload_article_img"),
            removeBackButton: false),
        body: buildSplashScreesn());
  }
}
