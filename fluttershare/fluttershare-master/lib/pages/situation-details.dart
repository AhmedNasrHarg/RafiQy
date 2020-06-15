import 'package:flutter/material.dart';
import 'package:fluttershare/models/situation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' as Intl;

import 'home.dart';

class SituationDetails extends StatefulWidget {
  final int data;
  const SituationDetails({Key key, this.data}) : super(key: key);

  @override
  _SituationDetailsState createState() => _SituationDetailsState();
}

class _SituationDetailsState extends State<SituationDetails> {
  var situations = [];
  @override
  void initState() {
    super.initState();

    getSituationData(widget.data.toString());
  }

  dateToArabic(now) async {
    await initializeDateFormatting("ar_EG", null);
    var formatter = Intl.DateFormat.yMMMMEEEEd('ar_EG');
    String formatted = formatter.format(now);
    return formatted;
  }

  getSituationData(dataId) async {
    await userRef
        .document(currentUser.id)
        .collection('logSheetOutput')
        .document(dataId)
        .get()
        .then((value) {
      List x = value.data.entries.toList();
      setState(() {
        situations = x;
      });
      print(x);
    });
  }

  stringShaping(List strings) {
    print("sssssss");
    var str = '';
    for (int i = 0; i < strings.length - 1; i++) {
      str += '- ' + strings[i].toString() + '.\n';
    }
    return str;
  }

  textWidget(str) {
    print("bbbbbb");
    return (situations.isEmpty)
        ? Text("")
        : Text(
            str,
            textDirection: TextDirection.rtl,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          height: 1000,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: Localizations.localeOf(context).languageCode == "ar"
                  ?CrossAxisAlignment.start:CrossAxisAlignment.end,
              children: <Widget>[
                FutureBuilder(
                  future: dateToArabic(
                      DateTime.fromMillisecondsSinceEpoch(widget.data)),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return snapshot.hasData
                        ? Center(
                            child: Text(
                              snapshot.data,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 30),
                            ),
                          )
                        : CircularProgressIndicator();
                  },
                ),
                Text(
                  "الموقف:",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 30),
                ),
                (situations.isNotEmpty)
                    ? textWidget(stringShaping(situations[4].value))
                    : Text(""),
                Text(
                  "الشعور:",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 30),
                ),
                (situations.isNotEmpty)
                    ? textWidget(stringShaping(situations[2].value))
                    : Text(""),
                Text(
                  "الفكرة:",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 30),
                ),
                (situations.isNotEmpty)
                    ? textWidget(stringShaping(situations[0].value))
                    : Text(""),
                Text(
                  "الاستجابة:",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 30),
                ),
                (situations.isNotEmpty)
                    ? textWidget(stringShaping(situations[3].value))
                    : Text(""),
                Text(
                  "السلوك:",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 30),
                ),
                (situations.isNotEmpty)
                    ? textWidget(stringShaping(situations[1].value))
                    : Text(""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
