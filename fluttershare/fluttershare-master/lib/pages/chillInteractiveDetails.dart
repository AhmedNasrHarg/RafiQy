
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/chill.dart';
import 'package:fluttershare/classes/chill_interactive.dart';
import 'package:fluttershare/pages/chill_interactive_upload.dart';

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

  _ChillInteractiveDetailsState(this.itemChill);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemChill.item_title),
      ),
      body:
      GridView.count(
          childAspectRatio: (70 / 50),
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
        onPressed: ()
        {
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=>ChillInteractiveUpload()
          ));
        },
      ),
    );
  }
}

