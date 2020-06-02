import 'package:hive/hive.dart';

@HiveType()
class Album {
  @HiveField(0)
  String title;
  @HiveField(1)
  String imagePath;
  @HiveField(2)
  bool isFavourite;

  Album(this.title, this.imagePath, this.isFavourite);
}

class AlbumAdapter extends TypeAdapter<Album> {
  @override
  Album read(BinaryReader reader) {
    return Album('', '', false)
      ..title = reader.read()
      ..imagePath = reader.read()
      ..isFavourite = reader.read();
  }

  @override
  void write(BinaryWriter writer, Album obj) {
    writer.write(obj.title);
    writer.write(obj.imagePath);
    writer.write(obj.isFavourite);
  }

  @override
  // TODO: implement typeId
  int get typeId => 3;
}
