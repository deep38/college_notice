// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:college_notice/data/models/staff.dart';
import 'package:flutter/foundation.dart';

class Department {
  String id;
  final String name;
  String? admin;
  String collegeId;
  final List<Staff> staff;
  
  Department({
    required this.id,
    required this.name,
    this.admin,
    required this.collegeId,
    required this.staff,
  });
  
  Department copyWith({
    String? id,
    String? name,
    String? admin,
    String? collegeId,
    List<Staff>? staff,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      admin: admin ?? this.admin,
      collegeId: collegeId ?? this.collegeId,
      staff: staff ?? this.staff,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'admin': admin,
      'collegeId': collegeId,
      'staff': staff.map((x) => x.toMap()).toList(),
    };
  }

  Map<String, dynamic> toFirebaseMap() {
    return <String, dynamic>{
      'name': name,
      'admin': admin,
      'collegeId': collegeId,
    };
  }

  static Map<String, dynamic> firebaseMap({required String name, required String? admin, required String collegeId}) {
    return <String, dynamic>{
      'name': name,
      'admin': admin,
      'collegeId': collegeId,
    };
  }

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'],
      name: map['name'] as String,
      admin: map['admin'] != null ? map['admin'] as String : null,
      collegeId: map['collegeId'] as String,
      staff: List<Staff>.from((map['staff'] as List<int>).map<Staff>((x) => Staff.fromMap(x as Map<String,dynamic>),),),
    );
  }

  factory Department.fromFirebaseMap(String id, Map<String, dynamic> map) {
    return Department(
      id: id,
      name: map['name'] as String,
      admin: map['admin'] != null ? map['admin'] as String : null,
      collegeId: map['collegeId'],
      staff: [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Department.fromJson(String source) => Department.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(covariant Department other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.admin == admin &&
      other.collegeId == collegeId &&
      listEquals(other.staff, staff);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      admin.hashCode ^
      collegeId.hashCode ^
      staff.hashCode;
  }
}
