import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heathtrack/k_services/diagnoseEngine.dart';
import 'package:heathtrack/k_services/getEachHealthData.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:heathtrack/screens/patientScreens/patientSettingScreen.dart';
import 'package:heathtrack/screens/patientScreens/sosScreen.dart';
import 'package:heathtrack/services/localNotifications.dart';
import 'package:heathtrack/widgets/healthIndicators.dart';
import 'package:provider/provider.dart';
import '../../constants/utils.dart';
import '../../services/patientServices.dart';
import '../../widgets/HorizontalBar.dart';
import '../../widgets/Summary.dart';
import 'checkBMIScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  final PatientServices patientServices = PatientServices();

  var healthDataList;
  GetEachHealthData getEachHealthData = GetEachHealthData();

  List<Data> listHeartData = [];
  List<Data2> listBloodData = [];
  List<Data> listOxyData = [];
  List<Data> listTempData = [];
  List<Data> listGlucoseData = [];

  String diagnose = "";

  Timer? _pollingTimer;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    fetchHealthData();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  fetchHealthData() async {
    try {
      healthDataList = await patientServices.fetchHeathData(context);
      processHealthData(); // Cập nhật giao diện với dữ liệu ban đầu

      // Bắt đầu bộ đếm thời gian long polling
      _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
        try {
          final updatedHealthData =
              await patientServices.fetchHeathData(context);
          if (updatedHealthData != healthDataList) {
            // Cập nhật dữ liệu và giao diện nếu nhận được dữ liệu mới
            healthDataList = updatedHealthData;
            processHealthData();
            diagnose = statusDiagnose();
            if (diagnose.isNotEmpty) {
              localNotifications.showNotification(
                  title: "Dangerous !!",
                  body: diagnose,
                  payload: "Something is not right 😔🤔");
            } else {
              diagnose += "Everything Good !!";
            }
          }
        } catch (err) {
          showSnackBar(context, err.toString());
        }
      });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  processHealthData() {
    listHeartData = getEachHealthData.getListHeartRate(healthDataList);
    listBloodData = getEachHealthData.getListBloodPressure(healthDataList);
    listOxyData = getEachHealthData.getListOxygen(healthDataList);
    listTempData = getEachHealthData.getListTemperature(healthDataList);
    listGlucoseData = getEachHealthData.getListGlucose(healthDataList);

    if (mounted) {
      setState(() {});
    } // Cập nhật giao diện
  }

  String statusDiagnose() {
    String diagnose;
    int heartRate = (listHeartData.isEmpty
            ? 0
            : listHeartData[listHeartData.length - 1].value)!
        .toInt();
    List<int> bloodStatus = [
      listBloodData[listBloodData.length - 1].val1.toInt(),
      listBloodData[listBloodData.length - 1].val2.toInt(),
    ];
    double oxyStatus =
        (listOxyData.isEmpty ? 0 : listOxyData[listOxyData.length - 1].value)!;
    double tempStatus = (listTempData.isEmpty
        ? 0
        : listTempData[listTempData.length - 1].value)!;
    double glucoseStatus = (listGlucoseData.isEmpty
        ? 0
        : listGlucoseData[listGlucoseData.length - 1].value)!;
    diagnose = DiagnosisEngine.diagnoseHealth(
        tempStatus, bloodStatus, heartRate, glucoseStatus, oxyStatus);
    return diagnose;
  }

  String statusAdvice(String diagnose) {
    String advice;
    if (diagnose.isEmpty) {
      advice = "Everything well 🌟🌿";
    } else {
      advice = "Please take care 🌿🌟";
    }
    return advice;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (BuildContext context, patient, child) {
        return healthDataList == null
            ? const Center(child: CircularProgressIndicator())
            : Scaffold(
                backgroundColor: const Color(0xfff7f7f7),
                body: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PatientSettingScreen()));
                                  },
                                  icon: const Icon(
                                    Icons.settings,
                                    size: 30,
                                  )),
                              const SizedBox(width: 5)
                            ]),
                        GestureDetector(
                            onTap: () {},
                            child: SummaryWG(
                              diagnose: statusDiagnose(),
                              advice: statusAdvice(statusDiagnose()),
                            )),
                        Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.only(top: 20),
                          child: HealthIndicators(
                              heathData:
                                  healthDataList[healthDataList.length - 1]
                              // patient.user.healthDataList.isEmpty?
                              // HeathData(heartRate: 0, spb: 0, dbp: 0, oxygen: 0, temperature: 0, glucose: 0, step: 0, timestamp: DateTime.now().toString(), userId: '')
                              //     :patient.user.healthDataList[patient.user.healthDataList.length -1],
                              ),
                        ),
                        HorizontalBar(
                          const Icon(
                            Icons.emergency,
                            color: Colors.red,
                          ),
                          'Emergency',
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SosScreen()));
                          },
                        ),
                        HorizontalBar(
                          const Icon(
                            Icons.spa_outlined,
                            color: Colors.blueAccent,
                          ),
                          'BMI',
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CheckBMIScreen()));
                          },
                        ),
                        HorizontalBar(
                          const Icon(
                            Icons.apple,
                            color: Colors.greenAccent,
                          ),
                          'Nutritions',
                          ontap: () {},
                        ),
                        const SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
