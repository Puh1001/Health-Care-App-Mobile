import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class WatcherProflie {
  final String gender;
  final String image;
  final String dateOfBirth;
  final String phoneNumber;
  String? id;
  final String userId;
  WatcherProflie({
    required this.gender,
    required this.image,
    required this.dateOfBirth,
    required this.phoneNumber,
    this.id,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gender': gender,
      'image': image,
      'dateOfBirth': dateOfBirth,
      'phoneNumber': phoneNumber,
      'id': id,
      'userId': userId,
    };
  }

  factory WatcherProflie.fromMap(Map<String, dynamic> map) {
    return WatcherProflie(
      gender: map['gender'] as String,
      image: map['image'] as String,
      dateOfBirth: map['dateOfBirth'] as String,
      phoneNumber: map['phoneNumber'] as String,
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WatcherProflie.fromJson(String source) =>
      WatcherProflie.fromMap(json.decode(source) as Map<String, dynamic>);
}
