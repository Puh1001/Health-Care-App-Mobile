import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PatientInWatcher {
  final String name;
  final String email;
  final String password;
  final String type;
  final String familyCode;
  final String watcherId;
  String? id;
  PatientInWatcher({
    required this.name,
    required this.email,
    required this.password,
    required this.type,
    required this.familyCode,
    required this.watcherId,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'type': type,
      'familyCode': familyCode,
      'watcherId': watcherId,
      'id': id,
    };
  }

  factory PatientInWatcher.fromMap(Map<String, dynamic> map) {
    return PatientInWatcher(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      type: map['type'] as String,
      //age: map['age'] as String,
      familyCode: map['familyCode'] as String,
      watcherId: map['watcherId'] as String,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientInWatcher.fromJson(String source) =>
      PatientInWatcher.fromMap(json.decode(source) as Map<String, dynamic>);
}
