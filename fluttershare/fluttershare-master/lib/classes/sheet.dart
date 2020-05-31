import 'dart:ui';

import 'package:flutter/material.dart';

class Sheet
{
  Sheet(this.sheetName,this.done,this.sheetColor,this.sheetImage);
  String sheetName;
  bool done;
  Color sheetColor;
  String sheetImage;



 static List<Sheet>sheets(){
    return<Sheet>[
     Sheet("sheet1",true,Colors.deepPurple[200],"assets/images/reward.png"),
     Sheet("sheet2",false,Colors.teal[200],"assets/images/flower.png"),
     Sheet("Sheet3",false,Colors.purple[200],"assets/images/lock.png"),
    Sheet("Sheet4",false,Colors.green[200],"assets/images/lock.png")

    ];
  }
}

 