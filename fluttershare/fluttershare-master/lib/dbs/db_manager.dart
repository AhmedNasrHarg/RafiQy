import 'package:fluttershare/classes/topic.dart';
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
}
