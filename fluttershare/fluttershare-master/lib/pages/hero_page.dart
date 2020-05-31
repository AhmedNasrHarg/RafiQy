import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OurHeros extends StatefulWidget{
  @override
  _OurHerosState createState() => _OurHerosState();
  OurHeros({Key key}):super(key:key);
}


class _OurHerosState extends State<OurHeros> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(title: Text("Our Heros"))
    ,
    body: GridView.count(
      crossAxisCount: 2,
      children:List.generate(30, (index)  
      {
            return Card(
                elevation: 10.0,
                child:Column(children: <Widget>[
                  Container(child:
                  Image.asset("assets/images/hero.png"),width: 150,height: 150,),
                  Text("User $index"),
                ],)
                
                // Container(child: Text("$index"),) ,
            );
      })
      // children:Container(child: Text("$index"),)
      ),
      );
  }
}