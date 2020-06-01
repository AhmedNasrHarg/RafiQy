import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/learn_bar.dart';
import 'package:fluttershare/classes/sheet.dart';
import 'package:fluttershare/pages/flexible_sheets_bar.dart';
import 'package:fluttershare/widgets/sheet_chat.dart';
import 'package:lottie/lottie.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:fluttershare/pages/home.dart';

class EnterySheets extends StatefulWidget {
  EnterySheets({Key key}) : super(key: key);
  @override
  _EnterySheetsState createState() => _EnterySheetsState();
}

class _EnterySheetsState extends State<EnterySheets> {
  List<Sheet> sheets = [];
  @override
  void initState() {
    super.initState();
    getSheets();
  }

  getSheets() async {
    QuerySnapshot snapshot = await sheetsRef
        .orderBy("sheetNumber", descending: false)
        .getDocuments();
    snapshot.documents.forEach((DocumentSnapshot doc) async {
      Sheet sheet = Sheet.fromDocument(doc);
      DocumentSnapshot completeDoc = await userRef
          .document(currentUser.id)
          .collection("completedSheets")
          .document("${sheet.sheetIdName}Log")
          .get();
      if (completeDoc.exists) {
        sheet.done = completeDoc["isDone"];
      } else {
        sheet.done = false;
      }
      sheets.add(sheet);
      setState(() {
        sheets = sheets;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: LearAppBar(),
            pinned: true,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(background: FlexibleSheetsBar()),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return (Ink(
                  color: Color(sheets[index].sheetColor),
                  child: ListTile(
                    // leading: Container(
                    //   height: 35.0,
                    //   width: 35.0,
                    //   child: Image.asset(
                    //       // "assets/images/lock.png"
                    //       sheets[index].sheetImage),
                    // ),
                    title: Center(
                      child: Text(
                          "${sheets[index].sheetTitle}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              decorationThickness: 2.85)),
                    ),
                    onTap: () {
                      // if (index > 0) {
                      //   if (sheets[index - 1].done == true) {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => SheetDetails(
                      //                   index: index,
                      //                 )));
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyHomePage(title: sheets[index].sheetIdName)),
                      );
                      //   } else {
                      //     Alert(
                      //         context: context,
                      //         title:
                      //             "لا يمكنك فتح تلك الصفحة دون اكمال السابقة",
                      //         content: Column(
                      //           children: <Widget>[
                      //             Lottie.asset(
                      //               'assets/animations/cant.json',
                      //               width: 300,
                      //               height: 300,
                      //               fit: BoxFit.fill,
                      //             ),
                      //           ],
                      //         ),
                      //         buttons: [
                      //           DialogButton(
                      //             onPressed: () => Navigator.pop(context),
                      //             child: Text("حسنا"),
                      //           )
                      //         ]).show();
                      //   }
                      // } else {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => SheetDetails(
                      //                 index: index,
                      //               )));
                      // }
                    },
                  ),
                  height: 100,
                ));
                // return Divider(height: 0, color: Colors.grey);
              },
              childCount: sheets.length,
            ),
          ),
        ],
      ),
    );
  }

  @override
  didChangeDependencies() {
//  _showWellcomeDialog();
    super.didChangeDependencies();
  }

  _showWellcomeDialog() {
    Alert(
        context: context,
        title: "أهلا بك في الجزء  الأهم في رفيقي ",
        content: Column(
          children: <Widget>[
            Lottie.asset(
              'assets/animations/first.json',
              width: 300,
              height: 300,
              fit: BoxFit.fill,
            ),
            //          Expanded(
            //   child: Text("سوف نقوم باعطاء لك شجرة ،عليك أن تراعيها حتي تكبر وتصبح جزء من حديقتنا", maxLines: 3,
            //     overflow: TextOverflow.ellipsis,
            //     textDirection: TextDirection.rtl,
            //     textAlign: TextAlign.justify,),
            // )
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: Text("أبدأ الآن"),
          )
        ]).show();
  }
}
