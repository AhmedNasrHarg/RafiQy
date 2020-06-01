import 'package:fluttershare/classes/topic.dart';
import 'package:fluttershare/classes/topic_notes.dart';
import 'package:fluttershare/classes/topic_questions.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<String> getUserId() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = await directory.path;
    await Hive.init(path);
    var box = await Hive.openBox('User');
    var id = box.get('userId');
    return id;
  }

  Future<void> saveUserId(String id) async {
    final directory = await getApplicationDocumentsDirectory();
    String path = await directory.path;
    await Hive.init(path);
    var box = await Hive.openBox('User');
    box.put('userId', id);
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

  Future<void> saveQuestions(
      String userId, String topicName, List<Question> questions) async {
    final directory = await getApplicationDocumentsDirectory();
    String path = await directory.path;
    await Hive
      ..init(path)
      ..registerAdapter(QuestionAdapter());
    ;
    var box = await Hive.openBox('Learn');
    box.put(userId, {
      topicName: {'questions': questions}
    });
  }

  Future<List<dynamic>> getTopicQuestions(
      String userId, String topicName) async {
    final directory = await getApplicationDocumentsDirectory();
    String path = await directory.path;
    await Hive.init(path);
    var box = await Hive.openBox('Learn');
    var topics = box.get(userId);
    var topic = topics[topicName];
    var topicQuestions = topic['questions'];
    return topicQuestions;
  }

  Future<void> saveTopicNotes(
      String userId, String topicName, List<Note> topicNotes) async {
    final directory = await getApplicationDocumentsDirectory();
    String path = await directory.path;
    await Hive
      ..init(path)
      ..registerAdapter(NoteAdapter());
    var box = await Hive.openBox('Learn');
    box.put(userId, {
      topicName: {'topicNotes': topicNotes}
    });
  }

  Future<List<dynamic>> getTopicNotes(String userId, String topicName) {}
}
