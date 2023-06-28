// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Staff {
  String id;
  String? name;
  String collegeId;
  String departmentId;
  final String email;
  List<String> subjects;

  Staff({
    required this.id,
    this.name,
    required this.collegeId,
    required this.departmentId,
    required this.email,
    required this.subjects,
  });

  Staff copyWith({
    String? id,
    String? name,
    String? collegeId,
    String? departmentId,
    String? email,
    List<String>? subjects,
  }) {
    return Staff(
      id: id ?? this.id,
      name: name ?? this.name,
      collegeId: collegeId ?? this.collegeId,
      departmentId: departmentId ?? this.departmentId,
      email: email ?? this.email,
      subjects: subjects ?? this.subjects,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'collegeId': collegeId,
      'departmentId': departmentId,
      'email': email,
      'subjects': subjects,
    };
  }

  static Map<String, dynamic> firebaseMap({
    required String email,
    required String collegeId,
    required String departemntId,
    required List<String> subjects,
  }) {
    return <String, dynamic>{
      'email': email,
      'collegeId': collegeId,
      'departmentId': departemntId,
      'subjects': subjects,
    };
  }

  factory Staff.fromMap(Map<String, dynamic> map) {
    return Staff(
      id: map['id'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      collegeId: map['collegeId'] as String,
      departmentId: map['departmentId'] as String,
      email: map['email'] as String,
      subjects: List<String>.from((map['subjects'] as List<String>)),
    );
  }

  factory Staff.fromFirebaseMap(String id, Map<String, dynamic> map) {
    return Staff(
      id: id,
      name: map['name'] != null ? map['name'] as String : null,
      collegeId: map['collegeId'] as String,
      departmentId: map['departmentId'] as String,
      email: map['email'] as String,
      subjects: List<String>.from((map['subjects'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Staff.fromJson(String source) => Staff.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Staff(id: $id, name: $name, collegeId: $collegeId, departmentId: $departmentId, email: $email, subjects: $subjects)';
  }

  @override
  bool operator ==(covariant Staff other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.collegeId == collegeId &&
      other.departmentId == departmentId &&
      other.email == email &&
      listEquals(other.subjects, subjects);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      collegeId.hashCode ^
      departmentId.hashCode ^
      email.hashCode ^
      subjects.hashCode;
  }
}
