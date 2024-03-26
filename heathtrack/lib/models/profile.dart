import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Proflie {
  final String gender;
  final String image;
  final String dateOfBirth;
  final String bloodType;
  final String phoneNumber;
  final double weight;
  final double height;
  String? id;
  final String userId;
  Proflie({
    required this.gender,
    required this.image,
    required this.dateOfBirth,
    required this.bloodType,
    required this.phoneNumber,
    required this.weight,
    required this.height,
    this.id,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gender': gender,
      'image': image,
      'dateOfBirth': dateOfBirth,
      'bloodType': bloodType,
      'phoneNumber': phoneNumber,
      'weight': weight,
      'height': height,
      'id': id,
      'userId': userId,
    };
  }

  factory Proflie.fromMap(Map<String, dynamic> map) {
    return Proflie(
      gender: map['gender'] as String,
      image: map['image'] as String,
      dateOfBirth: map['dateOfBirth'] as String,
      bloodType: map['bloodType'] as String,
      phoneNumber: map['phoneNumber'] as String,
      weight: map['weight'] as double,
      height: map['height'] as double,
      id: map['id'] != null ? map['id'] as String : null,
      userId: map['userId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Proflie.fromJson(String source) =>
      Proflie.fromMap(json.decode(source) as Map<String, dynamic>);
}
