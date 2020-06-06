import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/note.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NotePage extends StatefulWidget {
  String topic_id;
  NotePage({Key key, this.topic_id}) : super(key: key);
  @override
  _NotePageState createState() => _NotePageState(this.topic_id);
}

class _NotePageState extends State<NotePage> {
  String topic_id;
  _NotePageState(this.topic_id);
  List<String> notesTitles = [];
  List<String> notesContents = [];
  String curTitle = '';
  String curContent = '';
  int idx = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotes();
  }

  void saveNotes() {
    notesRef
        .document(currentUser.id)
        .collection(topic_id) //setb2a
        .document(topic_id)
        .setData({'notesTitles': notesTitles, 'notesContents': notesContents});
  }

  void getNotes() {
    notesRef
        .document(currentUser.id)
        .collection(topic_id)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        print('yarab');
        setState(() {
          notesTitles = new List<String>.from(f.data['notesTitles']);
          notesContents = new List<String>.from(f.data['notesContents']);
        });

        print('${f.data}}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, "note_page")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Alert(
              context: context,
              title: "New Note",
              content: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (text) {
                      curTitle = text;
                    },
                    decoration: InputDecoration(
                      labelText: 'title',
                    ),
//                    onSubmitted: (),
                  ),
                  Container(
                    child: TextField(
                      onChanged: (text) {
                        curContent = text;
                      },
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
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();

//                    Navigator.pop(context);
                    setState(() {
                      //check first if title & content is not empty
                      if (curTitle.length > 0 && curContent.length > 0) {
                        notesTitles.add(curTitle);
                        notesContents.add(curContent);
                        saveNotes();
                      } else {
                        //show toast here
                      }
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
      ),
      body: Column(
        children: notesTitles.map((e) {
          Note note = Note(e, e);
//          idx++;
          return NoteRow(note);
        }).toList(),
      ),
    );
  }
}

class NoteRow extends StatelessWidget {
  Note note;
  NoteRow(this.note);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              note.getTitle,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ), //add style ya nonnna
            Text(note.getContent),
          ],
        ),
      ),
    );
  }
}
