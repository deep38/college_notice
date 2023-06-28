// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:college_notice/data/models/department.dart';

class College {
  String id;
  String name;
  String admin;
  List<Department> departments;
  College({
    required this.id,
    required this.name,
    required this.admin,
    required this.departments,
  });

  College copyWith({
    String? id,
    String? name,
    String? admin,
    List<Department>? departments,
  }) {
    return College(
      id: id ?? this.id,
      name: name ?? this.name,
      admin: admin ?? this.admin,
      departments: departments ?? this.departments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'admin': admin,
      'departments': departments.map((x) => x.toMap()).toList(),
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return <String, dynamic>{
      'name': name,
      'admin': admin,
    };
  }

  static Map<String, dynamic> firebaseMap({required String name, required String admin}) {
    return <String, dynamic>{
      'name': name,
      'admin': admin,
    };
  }

  factory College.fromMap(Map<String, dynamic> map) {
    return College(
      id: map['id'],
      name: map['name'] as String,
      admin: map['admin'] as String,
      departments: List<Department>.from((map['departments'] as List<int>).map<Department>((x) => Department.fromMap(x as Map<String,dynamic>),),),
    );
  }

  factory College.fromFirebaseMap(String id, Map<String, dynamic> map) {
    return College(
      id: id,
      name: map['name'] as String,
      admin: map['admin'] as String,
      departments: [],
    );
  }

  String toJson() => json.encode(toMap());

  factory College.fromJson(String source) =>
      College.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(covariant College other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.admin == admin &&
      listEquals(other.departments, departments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      admin.hashCode ^
      departments.hashCode;
  }
}
