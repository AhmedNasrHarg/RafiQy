import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/classes/note.dart';
import 'package:fluttershare/localization/localization_constants.dart';
import 'package:fluttershare/pages/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  Future<void> saveNotes() async {
   await notesRef
        .document(currentUser.id)
        .collection(topic_id) //setb2a
        .document(topic_id)
        .setData({'notesTitles': notesTitles, 'notesContents': notesContents});

    curTitle = '';
    curContent = '';
  }

  void getNotes() {
    notesRef
        .document(currentUser.id)
        .collection(topic_id)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
//        print('yarab');
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
          backgroundColor: notesTitles.length % 2 == 0
              ? Colors.amber[600]
              : Colors.teal[600],
          onPressed: () {
            Alert(
                context: context,
                title: getTranslated(context, "new_note"),
                content: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: (text) {
                        curTitle = text;
                      },
                      decoration: InputDecoration(
                        labelText: getTranslated(context, "note_title"),
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
                          labelText: getTranslated(context, "note_content"),
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
//                    Navigator.pop(context);
                      setState(()  {
                        Navigator.of(context, rootNavigator: true).pop();
                        //check first if title & content is not empty
                        if (curTitle.length > 0 && curContent.length > 0) {
                          notesTitles.add(curTitle);
                          notesContents.add(curContent);
                           saveNotes();
                        } else {
                          //show toast here
                          Fluttertoast.showToast(
                              msg: 'can not add empty note',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      });
                    },
                    child: Text(
                      getTranslated(context, "add_note"),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ]).show();
          },
          child: Icon(
            Icons.add,
          ),
        ),
        body: Card(
          child: ListView.builder(
              padding: const EdgeInsets.all(2),
              itemCount: notesContents.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: index % 2 == 0 ? Colors.amber[200] : Colors.teal,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          NoteRow(
                              Note(notesTitles[index], notesContents[index])),
                          RaisedButton.icon(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            color: index % 2 == 0
                                ? Colors.amber[200]
                                : Colors.teal,
                            onPressed: () {
                              setState(() {
                                notesTitles.removeAt(index);
                                notesContents.removeAt(index);
                                saveNotes();
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red[200],
                            ),
                            label: Text(''),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ));
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
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              note.getTitle,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ), //add style ya nonnna
            Divider(height: 20, color: Colors.white),
            Text(note.getContent,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )),
          ],
        ),
      ),
    );
  }
}
