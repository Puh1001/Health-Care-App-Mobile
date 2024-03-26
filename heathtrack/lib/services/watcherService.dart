import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heathtrack/constants/errorHandling.dart';
import 'package:heathtrack/constants/utils.dart';
import 'package:heathtrack/models/heathData.dart';
import 'package:heathtrack/models/patientInWatcher.dart';
import 'package:heathtrack/models/user.dart';
import 'package:heathtrack/objects/patient.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:heathtrack/services/authService.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class WatcherService {
  void addPatient({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
    required String type,
    required String age,
    required String familyCode,
    required String watcherId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      PatientInWatcher patientInWatcher = PatientInWatcher(
        name: name,
        email: email,
        password: password,
        //age: age,
        type: type,
        familyCode: familyCode,
        watcherId: watcherId,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/register'),
        body: patientInWatcher.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSucess: () {
          showSnackBar(context, 'Account created!');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // GET ALL PATIENT
  Future<List<PatientInWatcher>> fetchAddressPatient({
    required BuildContext context,
    required watcherId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final watcherId = userProvider.user.id;
    List<PatientInWatcher> patientList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/watcher/get-all-patient?watcherId=$watcherId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            List<dynamic> data = jsonDecode(res.body);
            for (var patient in data) {
              patientList.add(PatientInWatcher(
                  id: patient['_id'],
                  name: patient['name'],
                  email: patient['email'],
                  password: patient['password'],
                  type: patient['type'],
                  familyCode: patient['familyCode'],
                  watcherId: patient['watcherId']));
            }
          });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
    return patientList;
  }

  // DELETE PATIENT
  void deletePatient({
    required BuildContext context,
    required userId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
          Uri.parse('$uri/watcher/delete-patient?userId=$userId'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          });

      httpErrorHandle(
        response: res,
        context: context,
        onSucess: () {
          showSnackBar(context, "Account Deleted!");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // GET ALL HEATH DATA
  Future<List<HeathData>> fetchHeathDataInWatcher(
    BuildContext context,
    userId,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<HeathData> heathDataList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/get-heath-data?userId=$userId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSucess: () {
            List<dynamic> data = jsonDecode(res.body);
            for (var health in data) {
              heathDataList.add(HeathData(
                  heartRate: health['heartRate'],
                  spb: health['spb'],
                  dbp: health['dbp'],
                  oxygen: double.parse(health['oxygen'].toString()),
                  temperature: double.parse(health['temperature'].toString()),
                  glucose: health['glucose'],
                  step: health['step'],
                  timestamp: health['timestamp'],
                  userId: health['userId']));
            }
          });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
    for (var i in heathDataList) {
      print(i.runtimeType);
    }
    return heathDataList;
  }
}
