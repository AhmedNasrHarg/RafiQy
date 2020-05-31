import 'package:hive/hive.dart';

@HiveType()
class Note {
  @HiveField(0)
  String noteTitle;
  @HiveField(1)
  String noteContent;
  @HiveField(2)
  int noteColor;
  Note(this.noteTitle, this.noteContent, this.noteColor);
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  Note read(BinaryReader reader) {
    return Note('g', 'g', 0)
      ..noteTitle = reader.read()
      ..noteContent = reader.read()
      ..noteColor = reader.read();
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.write(obj.noteTitle);
    writer.write(obj.noteContent);
    writer.write(obj.noteColor);
  }

  @override
  // TODO: implement typeId
  int get typeId => 1;
}
