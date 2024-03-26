import 'package:flutter/cupertino.dart';
import 'package:heathtrack/objects/patient.dart';
import 'package:heathtrack/objects/theme.dart';

import '../models/user.dart';

class Watcher extends User {
  final DateTime? dateOfBirth;
  final String? phoneNumber;
  final String? gender;
  final List<Patient> patientList;

  Watcher({
    required String id,
    required String name,
    required String email,
    required String password,
    required String familyCode,
    required String address,
    required String type,
    required String token,
    this.dateOfBirth,
    this.phoneNumber,
    this.gender,
    required this.patientList,
  }) : super(
          id: id,
          name: name,
          email: email,
          password: password,
          familyCode: familyCode,
          address: address,
          type: type,
          token: token,
        );
}
