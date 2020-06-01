import 'package:hive/hive.dart';

@HiveType()
class Question {
  @HiveField(0)
  String question;
  @HiveField(1)
  String answer;
  @HiveField(2)
  bool isDone;
  Question(this.question, this.answer, this.isDone);
}

class QuestionAdapter extends TypeAdapter<Question> {
  @override
  Question read(BinaryReader reader) {
    return Question('', '', false)
      ..question = reader.read()
      ..answer = reader.read()
      ..isDone = reader.read();
  }

  @override
  void write(BinaryWriter writer, Question obj) {
    writer.write(obj.question);
    writer.write(obj.answer);
    writer.write(obj.isDone);
  }

  @override
  // TODO: implement typeId
  int get typeId => 1;
}
