// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Student {
  final String enrollment;
  final String? name;
  final String? collegeId;
  final String? departmentId;
  final List<String> subjects;
  Student({
    required this.enrollment,
    required this.name,
    this.collegeId,
    this.departmentId,
    required this.subjects,
  });

  Student copyWith({
    String? enrollment,
    String? name,
    String? collegeId,
    String? departmentId,
    List<String>? subjects,
  }) {
    return Student(
      enrollment: enrollment ?? this.enrollment,
      name: name ?? this.name,
      collegeId: collegeId ?? this.collegeId,
      departmentId: departmentId ?? this.departmentId,
      subjects: subjects ?? this.subjects,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'enrollment': enrollment,
      'name': name,
      'collegeId': collegeId,
      'departmentId': departmentId,
      'subjects': subjects,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      enrollment: map['enrollment'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      collegeId: map['collegeId'] != null ? map['collegeId'] as String : null,
      departmentId: map['departmentId'] != null ? map['departmentId'] as String : null,
      subjects: List<String>.from((map['subjects'] as List<String>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) => Student.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Student(enrollment: $enrollment, name: $name, collegeId: $collegeId, departmentId: $departmentId, subjects: $subjects)';
  }

  @override
  bool operator ==(covariant Student other) {
    if (identical(this, other)) return true;
  
    return 
      other.enrollment == enrollment &&
      other.name == name &&
      other.collegeId == collegeId &&
      other.departmentId == departmentId &&
      listEquals(other.subjects, subjects);
  }

  @override
  int get hashCode {
    return enrollment.hashCode ^
      name.hashCode ^
      collegeId.hashCode ^
      departmentId.hashCode ^
      subjects.hashCode;
  }
}
