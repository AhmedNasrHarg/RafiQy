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
  Topic(this.topicId, this.topicName, this.videoURL, this.topicImage,
      this.topicColor, this.isDone, this.numQ, this.numQRead);
}

//userId -> topic[]
//adapter
class TopicAdapter extends TypeAdapter<Topic> {
  @override
  Topic read(BinaryReader reader) {
    return Topic('', '', '', '', 0, false, 0, 0)
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

@HiveType()
class Post {
  @HiveField(0)
  String postId;
  @HiveField(1)
  String authorId;
  @HiveField(2)
  String author;
  @HiveField(3)
  String title;
  @HiveField(4)
  String body;
  @HiveField(5)
  String mediaUrl;
  @HiveField(6)
  dynamic likes;

  Post({
    this.postId,
    this.authorId,
    this.author,
    this.title,
    this.body,
    this.mediaUrl,
    this.likes,
  });

  @override
  List<Object> get props =>
      [postId, authorId, author, title, body, mediaUrl, likes];
}

class PostAdapter extends TypeAdapter<Post> {
  @override
  Post read(BinaryReader reader) {
    return Post()
      ..postId = reader.read()
      ..authorId = reader.read()
      ..author = reader.read()
      ..title = reader.read()
      ..body = reader.read()
      ..mediaUrl = reader.read()
      ..likes = reader.read();
  }

  @override
  void write(BinaryWriter writer, Post obj) {
    writer.write(obj.postId);
    writer.write(obj.authorId);
    writer.write(obj.author);
    writer.write(obj.title);
    writer.write(obj.body);
    writer.write(obj.mediaUrl);
    writer.write(obj.likes);
  }

  @override
  // TODO: implement typeId
  int get typeId => 0;
}
