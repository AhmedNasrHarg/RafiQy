class CheckListItem {
  String name;
  String type;
  String media;
  CheckListItem({this.name, this.type, this.media});
  CheckListItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    media = json['media'];
  }
}