class Question {
  String body;
  String btnOne;
  String btnTwo;
  String videoUrl;
  List<dynamic> items;
  bool isTyping = false;

  Question({this.body,this.btnOne,this.btnTwo,this.items,this.videoUrl,this.isTyping});
  Question.fromJson(Map<String,dynamic> json){
    body = json['body'];
    btnOne = json['btnOne'];
    btnTwo = json['btnTwo'];
    videoUrl = json['videoUrl'];
    items = json['list'];
  }
}