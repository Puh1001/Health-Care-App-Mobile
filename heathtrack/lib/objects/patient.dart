
import 'package:heathtrack/models/patientInWatcher.dart';
import '../models/user.dart';

class Patient extends User {
  String watcherId;
  String? phoneNumber;
  DateTime? dateOfBirth;
  Patient(
      {required String id,
      required String name,
      required String email,
      required String password,
      required String familyCode,
      required String address,
      required String type,
      required String token,
      required this.watcherId,
      this.phoneNumber,
      this.dateOfBirth,
    })
      : super(
          id: id,
          name: name,
          email: email,
          password: password,
          familyCode: familyCode,
          address: address,
          type: type,
          token: token,
        );

  getDataFromPatientInWatcher(PatientInWatcher p) {
    name = p.name;
    email = p.email;
    password = p.password;
    type = p.type;
    id = p.id ?? '';
    //=p.age;
    familyCode = p.familyCode;
    watcherId = p.watcherId;
  }
}
