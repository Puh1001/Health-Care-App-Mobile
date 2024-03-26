// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  late  String id;
  late  String name;
  late  String email;
  late  String password;
  late  String familyCode;
   String address;
  late  String type;
   String token;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.familyCode,
    required this.address,
    required this.type,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'familyCode': familyCode,
      'address': address,
      'type': type,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      familyCode: map['familyCode'] as String,
      address: map['address'] as String,
      type: map['type'] as String,
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
