import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttershare/routes/route_names.dart';
import 'package:lottie/lottie.dart';

class FlexibleAppBarWidget extends StatelessWidget{
  final double appBarHeight=66.0;
  const FlexibleAppBarWidget();

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
                color: Colors.teal[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(child: Padding(
                      padding: const EdgeInsets.only(left:50),
                      child: new Text(
                          "معرض الصور",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20.0
                          )
                      ),
                    ),),

                    Container(child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: IconButton(
                         color: Colors.white,iconSize: 40.0, icon: Icon(Icons.arrow_right),
                         onPressed:()=> Navigator.pushNamed(context, albumRoute),
                          ),
                      
                    ),),

                  ],),
              ),
              Container(
                color: Colors.teal[400],
              child:Row(
                
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      
                        padding: const EdgeInsets.only(left:10),
                        child: new Text(
                            "كل موضوع تنهيه يجعل معرفتك أفضل",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15.0
                            )
                        ),
                      ),
                          Lottie.asset(
                        'assets/animations/12833-planta-3.json',
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