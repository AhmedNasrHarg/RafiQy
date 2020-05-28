class Message{
  String message;
  bool isMe;
  int timeStamp;
  Message({this.message,this.isMe}){
    timeStamp = DateTime.now().millisecondsSinceEpoch; 
  }
  Message.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    isMe = json['isMe'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['isMe'] = this.isMe;
    data['timeStamp'] = this.timeStamp;
    return data;
  }
}