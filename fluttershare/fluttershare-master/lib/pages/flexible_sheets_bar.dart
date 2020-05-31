import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class FlexibleSheetsBar extends StatelessWidget{
  final double appBarHeight=66.0;
  const FlexibleSheetsBar();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final double statuesBarHeight =MediaQuery.of(context).padding.top;
    return new Container(
      color: Colors.teal[300],
      padding:new EdgeInsets.only(top:statuesBarHeight),
      height: statuesBarHeight+appBarHeight,
      child:  new Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                color: Colors.teal[300],
              child:Row(
                
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      
                        padding: const EdgeInsets.only(left:10),
                        child: new Text(
                            "Every sheet makes your tree grow",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0
                            )
                        ),
                      ),
                          Lottie.asset(
                        'assets/animations/bar.json',
                        width: 100,
                        height: 100,
                        fit: BoxFit.fill,
                    )
                  ]
              )
              )

            ],)
      ),
    );
  }
  
}