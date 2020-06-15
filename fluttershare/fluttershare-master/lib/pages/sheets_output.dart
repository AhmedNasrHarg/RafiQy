import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/learn_bar.dart';
import 'package:fluttershare/classes/sheet.dart';
import 'package:fluttershare/classes/sheets_bar.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/pages/flexible_sheets_bar.dart';
import 'package:fluttershare/pages/human_body.dart';
import 'package:fluttershare/pages/situation-grid.dart';
import 'package:fluttershare/widgets/sheet_chat.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:fluttershare/pages/home.dart';

class SheetsOutput extends StatefulWidget {
  SheetsOutput({Key key}) : super(key: key);
  @override
  _SheetsOutputState createState() => _SheetsOutputState();
}

class _SheetsOutputState extends State<SheetsOutput> {
  List<String> completedSheets = [];
  int lastDone = 0;
  @override
  void initState() {
    super.initState();
    getCompletedSheets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "sheets_output")),
          backgroundColor: Colors.teal[300],
        ),
        body: ListView.builder(
          itemCount: completedSheets.length,
          itemBuilder: (context, i) {
            return ListTile(
                title: Card(
                  color: Colors.teal[100],
                  elevation: 10,
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                            completedSheets[i] == "logSheetLog"
                                ? "سجل الخواطر والمشاعر"
                                : "الاستجابات وردود الافعال",
                            style: TextStyle(
                              fontFamily: "Tajwal",
//        color: Colors.white
                            )),
                        Lottie.asset("assets/animations/flower.json",
                            width: 100, height: 100)
                      ]),
                ),
                onTap: () {
                  completedSheets[i] == "logSheetLog"
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SituationGrid()))
                      : Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HumanBody()));
                });
          },
        ));
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  getCompletedSheets() async {
    CollectionReference logSheet =
        userRef.document(currentUser.id).collection("logSheetOutput");

    if (logSheet != null) {
      logSheet.getDocuments().then((value) {
        if (value.documents.length > 0) {
          setState(() {
            completedSheets.add("logSheetLog");
          });
        }
      });
    }

    DocumentReference bodySheet = userRef
        .document(currentUser.id)
        .collection("completedSheets")
        .document("bodyResponseSheetLog");

    bodySheet.get().then((value) {
      if (value.exists) {
        if (mounted) {
          setState(() {
            completedSheets.add("bodyResponseSheetLog");
          });
        }
      }
    });
  }
}
