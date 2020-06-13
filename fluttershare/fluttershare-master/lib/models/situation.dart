import 'dart:convert';

class Situation {
  DateTime date;
  String event;
  String feeling;
  String thought;
  String response;
  String action;

  
  Situation({
    this.date,
    this.event,
    this.feeling,
    this.thought,
    this.response,
    this.action,
  });

  

  Map<String, dynamic> toMap() {
    return {
      'date': date?.millisecondsSinceEpoch,
      'event': event,
      'feeling': feeling,
      'thought': thought,
      'response': response,
      'action': action,
    };
  }

  static Situation fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Situation(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      event: map['event'],
      feeling: map['feeling'],
      thought: map['thought'],
      response: map['response'],
      action: map['action'],
    );
  }

  String toJson() => json.encode(toMap());

  static Situation fromJson(String source) => fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Situation &&
      o.date == date &&
      o.event == event &&
      o.feeling == feeling &&
      o.thought == thought &&
      o.response == response &&
      o.action == action;
  }

  @override
  int get hashCode {
    return date.hashCode ^
      event.hashCode ^
      feeling.hashCode ^
      thought.hashCode ^
      response.hashCode ^
      action.hashCode;
  }

  Situation copyWith({
    DateTime date,
    String event,
    String feeling,
    String thought,
    String response,
    String action,
  }) {
    return Situation(
      date: date ?? this.date,
      event: event ?? this.event,
      feeling: feeling ?? this.feeling,
      thought: thought ?? this.thought,
      response: response ?? this.response,
      action: action ?? this.action,
    );
  }

  @override
  String toString() {
    return 'Situation(date: $date, event: $event, feeling: $feeling, thought: $thought, response: $response, action: $action)';
  }
}
