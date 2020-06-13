import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/models/situation.dart';
import 'package:fluttershare/pages/situation-details.dart';
import 'package:fluttershare/widgets/sheet_chat.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as Intl;

import 'home.dart';

class SituationGrid extends StatefulWidget {
  SituationGrid({Key key}) : super(key: key);

  @override
  DateGridState createState() => DateGridState();
}

class DateGridState extends State<SituationGrid> {
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;

  selectTime(BuildContext context) async {
    picked = await showTimePicker(context: context, initialTime: _time);
    setState(() {
      _time = picked;
      print(picked);
    });
  }

  List<int> situations = [];

  @override
  void initState() {
    super.initState();
    getdates();
  }

  getdates() async {
    QuerySnapshot querySnapshot = await userRef
        .document(currentUser.id)
        .collection("logSheetOutput")
        .getDocuments();
    //     .then((value) {
    //  print(value.documents.first.documentID) ;
    //  value.documents.forEach((element) {situations.add(element.documentID as int); });
    // });
    setState(() {
      querySnapshot.documents.forEach((element) {
        situations.add(int.parse(element.documentID));
      });
    });
  }

  dateToArabic(now) async {
    await initializeDateFormatting("ar_EG", null);
    var formatter = Intl.DateFormat.yMMMMEEEEd('ar_EG');
    String formatted = formatter.format(now);
    return formatted;
  }

  dataCells() {
    List<Widget> widgets = [];
    for (var item in situations) {
      var card = GestureDetector(
        child: Card(
          color: Colors.lightBlue[50],
          child: FutureBuilder(
            future: dateToArabic(DateTime.fromMillisecondsSinceEpoch(item)),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? Center(
                      child: Text(
                        snapshot.data,
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : CircularProgressIndicator();
            },
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SituationDetails(
                        data: item,
                      )));
        },
      );
      widgets.add(card);
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('جدول الرصد'),
        actions: <Widget>[
          RaisedButton.icon(
            icon: Icon(Icons.add),
            label: Text('إضافة'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(
                          title: 'logSheet',
                          sheetName: 'سِجِل الخواطر والمشاعر',
                          deleteLast: true,
                        )),
              );
            },
            color: Colors.amber,
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height / 2 - 25,
                  padding: EdgeInsets.all(4),
                  width: MediaQuery.of(context).size.width,
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    children: dataCells(),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Center(
                  child: Container(
                    child: Center(
                        child: Text(
                      'أهمية جدول الرصد',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        color: Colors.amber[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 2,
                          color: Colors.amber,
                        )),
                  ),
                ),
                Center(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "كتابة الحدث بشكل مفصل و ما ارتبط به من مشاعر سلبية و إدراك ما وراءها من أفكار و ما نتج عن ذلك كله من سلوك و هي الطريق الممهد للأستبصار (gaining insight)، بها تعرف أثر مشاعرك السلبية (مثال: القلق)، المطلوب منك رصد كل حدث شعرت فيه بالقلق، شدته، و ما الأفكار التي كانت تدور في رأسك، و ما نتج عن ذلك القلق (السلوكيات التجنبية).\nاعتر جدول الرصد هو دفتر يومياتك تكتب فيه الاحداث التي تراها سيئة، كي تستطيع التعامل معاها او تعيد النظر فيها بعدما تتعلم (معرفيا و سلوكيا) كيفية التعامل مع القلق.\nملحوظة: هذه المهمة مفتوحة كدفتر يومياتك و يطلب منك الالتزام بجدول الرصد لمدة اسبوع ع الأقل قبل أن تفتح المهمة التالية.\nرفيقي يرغب في مساعدتك .. حدد لي من فضلك ساعة انبهك فيها لتكتب معي جدول اليوم.",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.access_alarm),
                            onPressed: () {
                              selectTime(context);
                            }),
                      ],
                    ),
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.amber[200],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 2,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
