import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SheetDetails extends StatefulWidget{
  int index;
  SheetDetails({Key key,this.index}):super(key:key);
  @override
  _SheetDetailsState createState() => _SheetDetailsState(this.index);
}
// var sheets=Sheet.sheets();
var sheets;

class _SheetDetailsState extends State<SheetDetails> {
  int index;
  _SheetDetailsState(this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Sheet"),),
    body: MaterialButton(child: Text("Done"),onPressed: ()
    {
      sheets[index].done=true;
      Alert
       (
         context: context,
         title: "أنت تقوم بعمل جيد",
        content: Column(
          children: <Widget>[
            Lottie.asset
            (
              'assets/animations/doing_well.json',
              width: 300,
              height: 300,
              fit: BoxFit.fill,
          ),
            
          ],
        )
        ,
        buttons: [DialogButton(
          onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
            },
        child: Text("التالي"),)]
       ).show();

      }));

  }
}