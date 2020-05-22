import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Sheets extends StatefulWidget {
  @override
  _SheetsState createState() => _SheetsState();
}

class _SheetsState extends State<Sheets> {
  var sheets = ['first', 'second', 'third', 'forth', 'fifth'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sheets'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: sheets
                    .map((name) => SheetRow(name, 'here is the description'))
                    .toList()),
          ),
        ));
  }
}

class SheetRow extends StatelessWidget {
  final String title;
  final String desc;
  SheetRow(@required this.title, @required this.desc);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(desc),
            trailing: Icon(Icons.expand_more),
            onTap: () {
              Fluttertoast.showToast(
                  msg: "we should nvigte",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
          Divider(color: Colors.black),
        ],
      ),
    );
  }
}
