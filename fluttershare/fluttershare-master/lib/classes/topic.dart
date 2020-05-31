import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

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

//adapter
class TopicAdapter extends TypeAdapter<Topic> {
  @override
  Topic read(BinaryReader reader) {
    return Topic('g', 'g', 'g', 0, false)
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

class DBManager {
  DBManager() {
    init();
  }
  Future<int> init() async {
    final directory = await getApplicationDocumentsDirectory();
    print('nasoooooor');
    print(directory.path);
    String path = await directory.path;
    await Hive.init(path);
    return 1;
  }

  Future<List<dynamic>> getLearnTopics() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = await directory.path;
    await Hive.init(path);
    var box = await Hive.openBox('Learn');
    var topics = box.get('LearnTopics');
    return topics;
  }

  Future<void> saveTopics(List<Topic> topics) async {
    final directory = await getApplicationDocumentsDirectory();
    String path = await directory.path;
    await Hive
      ..init(path)
      ..registerAdapter(TopicAdapter());
    ;
    var box = await Hive.openBox('Learn');
    box.put('LearnTopics', topics);
  }
}
