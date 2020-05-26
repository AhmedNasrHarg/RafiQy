import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/album.dart';
var cardAspecRatio=12.0/16.0;
var widgetAspectRatio=cardAspecRatio*1.2;
class CardScrollWidget extends StatelessWidget{
  var currentPage;
  var padding =20.0;
  var verticalInset=20.0;

  CardScrollWidget(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(aspectRatio: widgetAspectRatio
    ,child: LayoutBuilder(builder: (context,contraints)
    {
      var width=contraints.maxWidth;
      var height=contraints.maxHeight;

      var safeWidth=width-2*padding;
      var safeHeight=height-2*padding;
      var heightOfPrimaryCard=safeHeight;
      var widthOfPrimaryCard=heightOfPrimaryCard*cardAspecRatio;

      var primaryCardLeft =safeWidth-widthOfPrimaryCard;
      var horizontalInset=primaryCardLeft/2;

      List<Widget>cardList=new List();
      for (var i=0;i<albumImages.length;i++)
      {
        var delta=i-currentPage;
        bool isOnRight=delta>0;

        var start =padding+max(
          primaryCardLeft-horizontalInset* -delta*(isOnRight?15:1),0.0
        );

        var cardItem=Positioned.directional(textDirection: TextDirection.rtl,top:padding+verticalInset*max(-delta,0.0),bottom: padding+verticalInset*max(-delta, 0.0),
        start: start,
        child: ClipRect(
         child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspecRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(albumImages[i], fit: BoxFit.cover),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                           
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ));
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
        
      
    },),
    );
  }

}