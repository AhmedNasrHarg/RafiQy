
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/chill.dart';
import 'package:fluttershare/classes/chill_interactive.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/pages/chill_interactive_upload.dart';

import 'home.dart';
import 'image_viewer.dart';

class ChillInteractiveDetails extends StatefulWidget {
  Chill itemChill;
  @override
  _ChillInteractiveDetailsState createState() => _ChillInteractiveDetailsState(this.itemChill);
  ChillInteractiveDetails({Key key,this.itemChill}):super(key:key);
}

class _ChillInteractiveDetailsState extends State<ChillInteractiveDetails> {
  Chill itemChill;
  List<String>userImages=[];

  @override
  void initState() {
getUsetItemsImages();
  }

  _ChillInteractiveDetailsState(this.itemChill);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemChill.item_title),
      ),
      body:userImages.length!=0?
      GridView.count(
          childAspectRatio: (70 / 50),
          crossAxisCount: 1,
          children:List.generate(userImages.length, (index)
          {
            return
              Card(
                  elevation: 10.0,
                  child:GestureDetector(child:
                  Container(child:
                  Image.network(userImages[index]),width: 150,height: 120,),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ImageViewer(userImages[index],),));

                      }
                  )



              );

          })
      ):Center(child: Text(getTranslated(context, "no_images")),),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add,color: Colors.white,),
        onPressed: ()
        async {
         var userItem= await Navigator.push(context, MaterialPageRoute(
            builder: (context)=>ChillInteractiveUpload()
          ));
         if(userItem!=null) {
           setState(() {
            userImages.add(userItem);
            addUserItemImage(userImages);

           });
         }
        },
      ),
    );
  }
  addUserItemImage( List interactiveImages)async
  {
      await userRef
          .document(currentUser.id).collection("userInteractiveChill")
//          .collection("${itemChill.item_id}")
          .document("${itemChill.item_id}")
          .setData(
//          {"user_item_id": userItem.chillItemId,"user_item_title":userItem.title,"user_item_url":userItem.image}
      {"userImages":interactiveImages}
          );

  }
  getUsetItemsImages()async
  {



   DocumentReference chillItemRef= await userRef.document(currentUser.id)
        .collection("userInteractiveChill").document("${itemChill.item_id}");

    chillItemRef.get().then((value) {
      if(value.exists) {
        userImages = new List<String>.from(value["userImages"]);
        setState(() {
          userImages = userImages;
        });
      }
    });




  }

}

