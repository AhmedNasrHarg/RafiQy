import 'package:flutter/material.dart';
import 'package:fluttershare/classes/topic_notes.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  List <Note>notes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getTranslated(context, "note_page")),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Alert(
              context: context,
              title: "New Note",
              content: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'title',

                    ),
//                    onSubmitted: (),
                  ),
                  Container(child:
                  TextField(
                    maxLines: 15,
                    decoration: InputDecoration(
                      labelText: 'content',

                    ),


                  ),
                    height: 300,
                    width: 300,
                  )
                ],
              ),
              buttons: [
                DialogButton(
                  onPressed: ()
                  {
          Navigator.pop(context);
          setState(() {
//            notes.add(Note())
          });
          },
                  child: Text(
                    "Add Note",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]).show();
        },
        child: Icon(
          Icons.add,
        ),
      ),      body: Center(child: Text("Notes"),),
    );
  }
}
