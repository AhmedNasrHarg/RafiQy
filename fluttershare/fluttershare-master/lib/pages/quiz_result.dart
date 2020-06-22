import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as Intl;

class QuizResult extends StatefulWidget {
  final score;
  QuizResult({Key key, this.score}) : super(key: key);

  @override
  _QuizResultState createState() => _QuizResultState();
}

class _QuizResultState extends State<QuizResult> {
  var f;
  @override
  void initState() {
    f = new Intl.NumberFormat('##','ar_EG');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            Text(
              f.format(widget.score).toString(),
              style: TextStyle(fontSize: 120,color: Colors.amber,fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
