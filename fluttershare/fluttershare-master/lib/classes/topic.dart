import 'package:hive/hive.dart';

@HiveType()
class Topic {
  Topic(this.topicName, this.videoURL, this.topicImage, this.topicColor,
      this.isDone);
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
}

//userId -> topic[]
//adapter
class TopicAdapter extends TypeAdapter<Topic> {
  @override
  Topic read(BinaryReader reader) {
    return Topic('', '', '', 0, false)
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
