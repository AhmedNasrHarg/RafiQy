
import 'package:cloud_firestore/cloud_firestore.dart';

class Sheet
{
  Sheet({this.sheetTitle,this.sheetIdName,this.done,this.sheetColor,this.sheetImage});
  String sheetTitle;
  String sheetIdName;
  bool done;
  int sheetColor;
  String sheetImage;

  factory Sheet.fromDocument(DocumentSnapshot doc){
    return Sheet(
      sheetTitle: doc["sheetTitle"],
      sheetIdName: doc["sheetIdName"],
      sheetColor: doc["sheetColor"],
    );
  }

//  static List<Sheet>sheets(){
//     return<Sheet>[
//      Sheet("sheet1",true,Colors.deepPurple[200],"assets/images/reward.png"),
//      Sheet("sheet2",false,Colors.teal[200],"assets/images/flower.png"),
//      Sheet("Sheet3",false,Colors.purple[200],"assets/images/lock.png"),
//      Sheet("Sheet4",false,Colors.green[200],"assets/images/lock.png")

//     ];
//   }
}

 