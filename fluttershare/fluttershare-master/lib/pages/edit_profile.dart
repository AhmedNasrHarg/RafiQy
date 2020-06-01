import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';

class EditProfile extends StatefulWidget {

  final String currentUserId;

  EditProfile({this.currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  User user;
  bool _userNameValid = true;
  bool _bioValid = true;
  bool isUpdated = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc =  await userRef.document(widget.currentUserId).get();
    user =  User.fromDocument(doc);
    userNameController.text = user.username;
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top:12.0),
          child: Text(
            getTranslated(context,"user_name"),
            style: TextStyle(
              color: Colors.grey
            ),
          ),
        ),
        TextField(
          controller: userNameController,
          decoration: InputDecoration(
            hintText: getTranslated(context,"update_username"),
            errorText: _userNameValid ? null : userNameController.text.trim().length < 15 ? getTranslated(context, "user_short") : getTranslated(context, "user_long")
          ),
        ),
      ],
    );
  }

 Column buildBioField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top:12.0),
          child: Text(
            getTranslated(context, "bio"),
            style: TextStyle(
              color: Colors.grey
            ),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: getTranslated(context, "update_bio"),
            errorText: _bioValid ? null : getTranslated(context, "bio_long")

          ),
        ),
      ],
    );
  }

  updateProfileData() async{
    setState(() {
      userNameController.text.trim().length < 3 || userNameController.text.isEmpty || userNameController.text.trim().length > 15 ?
      _userNameValid = false : _userNameValid = true ;
      bioController.text.trim().length > 100 ? _bioValid = false : _bioValid = true;
    });

    if(_userNameValid && _bioValid){
      userRef.document(widget.currentUserId).updateData({
        "username" : userNameController.text,
        "bio": bioController.text
      });
      if(user.isAdmin)
      {
        QuerySnapshot postsIds = await userRef.document(widget.currentUserId).collection("userPosts").getDocuments();
        postsIds.documents.forEach((article)  {
        postRef.document(article["postId"]).updateData({
          "author" : userNameController.text,
        });
       });
      }
      SnackBar snackbar = SnackBar(content: Text(getTranslated(context, "profile_updated")));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      isUpdated = true;
    }
  }

  logout() async{
   await googleSignIn.signOut();
   Navigator.push(context, MaterialPageRoute(builder:(context) => Home()));
  }


  @override
  Widget build(context) {
    return Scaffold(
      key : _scaffoldKey,
      appBar: header(context,isAppTitle: false,titleText: getTranslated(context, "edit_profile"), removeBackButton: true, hasAction: true, isIcon: true,actionIcon: Icons.done, actionFunction: ()=> Navigator.pop(context, isUpdated),),
      body: isLoading ? circularProgress() : ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(user.photoUrl),
                    radius: 50.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      buildDisplayNameField(),
                      buildBioField(),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: updateProfileData,
                  child: Text(
                    getTranslated(context, "update_profile"),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: FlatButton.icon(
                    onPressed: logout,
                    icon: Icon(Icons.cancel, color: Colors.red,),
                    label: Text(
                      getTranslated(context, "log_out"),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20.0
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
