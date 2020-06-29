import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllQuizPage extends StatefulWidget {
  @override
  _AllQuizPageState createState() => _AllQuizPageState();
}

class _AllQuizPageState extends State<AllQuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الاختبارات"),),
      body: Column(

        children: <Widget>[
          Card(
            color: Colors.teal[100],
            elevation: 10,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:<Widget>[
                  Image.asset("assets/images/one.png",width: 100,height: 100,)

                ]),
          ),
          Card(
              color: Colors.teal[100],
              elevation: 10,
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:<Widget>[
                    Image.asset("assets/images/two.png",width: 100,height: 100,)

                  ]
              )),
          Card(
            color: Colors.teal[100],
            elevation: 10,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image.asset("assets/images/three.png",width: 100,height: 100,)

                ]),
          ),
          Card(
            color: Colors.teal[100],
            elevation: 10,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Image.asset("assets/images/four.png",width: 100,height: 100,)

                ]),
          ),


//      Lottie.network("https://assets9.lottiefiles.com/packages/lf20_aDxvEq.json"
//    ,width: 200
//    , height: 200
//    ,controller: controller,
//    onLoaded: (composition)
//    {
//    setState(() {
//    controller.duration=composition.duration*2;
//    });
//    }
//    )
        ],
      ),
    );
  }
}
