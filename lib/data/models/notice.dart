// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Notice {
  final String id;
  final String title;
  final DateTime dateTime;
  final String content;
  final String subject;
  
  Notice({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.content,
    required this.subject,
  });

  Notice copyWith({
    String? id,
    String? title,
    DateTime? dateTime,
    String? content,
    String? subject,
  }) {
    return Notice(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      content: content ?? this.content,
      subject: subject ?? this.subject,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'content': content,
      'subject': subject,
    };
  }

  static Map<String, dynamic> firebaseMap({
    required String title,
    required DateTime dateTime,
    required String content,
    required String subject,
  }) {
    return <String, dynamic>{
      'title': title,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'content': content,
      'subject': subject,
    };
  }

  factory Notice.fromMap(Map<String, dynamic> map) {
    return Notice(
      id: map['id'] as String,
      title: map['title'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] is int ? map['dateTime'] as int : int.parse(map['dateTime'])),
      content: map['content'] as String,
      subject: map['subject'] as String,
    );
  }

  factory Notice.fromFirebaseMap(String id, Map<String, dynamic> map) {
    return Notice(
      id: id,
      title: map['title'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] is int ? map['dateTime'] as int : int.parse(map['dateTime'])),
      content: map['content'] as String,
      subject: map['subject'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notice.fromJson(String source) => Notice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Notice(id: $id, title: $title, dateTime: $dateTime, content: $content, subject: $subject)';
  }

  @override
  bool operator ==(covariant Notice other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.dateTime == dateTime &&
      other.content == content &&
      other.subject == subject;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      dateTime.hashCode ^
      content.hashCode ^
      subject.hashCode;
  }
}
