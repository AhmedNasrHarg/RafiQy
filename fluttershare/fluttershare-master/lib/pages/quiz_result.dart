import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as Intl;

class QuizResult extends StatefulWidget {
  final score;
  QuizResult({Key key, this.score}) : super(key: key);

  @override
  _QuizResultState createState() => _QuizResultState(this.score);
}

class _QuizResultState extends State<QuizResult> {
  var score;
  _QuizResultState(this.score);
  var f;
  String resultOut="";
  @override
  void initState() {
    f = new Intl.NumberFormat('##','ar_EG');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print( this.score);
    if(score>=0&&score<=4)
      {
        resultOut="لا يوجد قلق عندك";
      }
    else if(score>=5&&score<=9)
    {
      resultOut="قلق بسيط";
    }
    else if(score>=10&&score<=14)
    {
      resultOut="قلق متوسط";
    }
    else if(score>=15&&score<=21)
    {
      resultOut="قلق شديد";
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).primaryColor,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("نتيجة أختبارك هي:",style: TextStyle(color: Colors.white),),
            Center(
              child: Text(
                resultOut,
                style: TextStyle(fontSize: 50,color: Colors.amber,fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
