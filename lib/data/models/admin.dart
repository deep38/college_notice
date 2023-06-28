// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Admin {
  final String? name;
  final String email;
  final String? phone;
  Admin({
    this.name,
    required this.email,
    this.phone,
  });

  Admin copyWith({
    String? name,
    String? email,
    String? phone,
  }) {
    return Admin(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      name: map['name'] != null ? map['name'] as String : null,
      email: map['email'] as String,
      phone: map['phone'] != null ? map['phone'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) => Admin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Admin(name: $name, email: $email, phone: $phone)';

  @override
  bool operator ==(covariant Admin other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.email == email &&
      other.phone == phone;
  }

  @override
  int get hashCode => name.hashCode ^ email.hashCode ^ phone.hashCode;
}
