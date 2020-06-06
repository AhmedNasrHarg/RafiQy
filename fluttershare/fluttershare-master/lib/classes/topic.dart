import 'package:fluttershare/classes/learn_qa.dart';
import 'package:hive/hive.dart';

@HiveType()
class Topic {
//  Topic(this.topicId,this.topicName, this.videoURL, this.topicImage, this.topicColor,
//      this.isDone,this.numQ,this.numQRead);
  @HiveField(0)
  String topicName;
  @HiveField(1)
  String videoURL;
  @HiveField(2)
  String topicImage;
  @HiveField(3)
  int topicColor;
  @HiveField(4)
  bool isDone;
  int numQ;
  int numQRead;
  String topicId;
  List<LearnQuestionAnswer> questions;
  Topic(this.topicId,this.topicName, this.videoURL, this.topicImage, this.topicColor,
      this.isDone,this.numQ,this.numQRead,this.questions);

}

//userId -> topic[]
//adapter
class TopicAdapter extends TypeAdapter<Topic> {
  @override
  Topic read(BinaryReader reader) {
    return Topic('','', '', '', 0, false,0,0,[])
      ..topicName = reader.read()
      ..videoURL = reader.read()
      ..topicImage = reader.read()
      ..topicColor = reader.read()
      ..isDone = reader.read();
  }

  @override
  void write(BinaryWriter writer, Topic obj) {
    writer.write(obj.topicName);
    writer.write(obj.videoURL);
    writer.write(obj.topicImage);
    writer.write(obj.topicColor);
    writer.write(obj.isDone);
  }

  @override
  // TODO: implement typeId
  int get typeId => 0;
}
