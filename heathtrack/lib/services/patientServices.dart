import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:heathtrack/constants/errorHandling.dart';
import 'package:heathtrack/constants/utils.dart';
import 'package:heathtrack/models/heathData.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:heathtrack/services/authService.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PatientServices {
  // GET ALL HEATH DATA
  Future<List<HeathData>> fetchHeathData(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.user.id;
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
    return heathDataList;
  }
}
