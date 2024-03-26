import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heathtrack/constants/utils.dart';
import 'package:heathtrack/k_services/diagnoseEngine.dart';
import 'package:heathtrack/k_services/getEachHealthData.dart';
import 'package:heathtrack/objects/patient.dart';
import 'package:heathtrack/services/localNotifications.dart';
import 'package:heathtrack/services/watcherService.dart';
import 'package:heathtrack/widgets/updatePatientInfoView.dart';
import 'updateInfoView.dart';

class PatientCard extends StatefulWidget {
  PatientCard(
      {super.key,
      required this.name,
      this.email,
      required this.ontap,
      this.isWoman = false,
      required this.diagnose,
      required this.patient,
      required this.userId});

  String name;
  String? email;
  final Function ontap;
  var isWoman = false;
  Patient patient;
  String diagnose;
  String userId;
  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {
  final WatcherService watcherService = WatcherService();

  var healthDataList;
  String diagnose = "";

  Timer? _pollingTimer;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    fetchHealthData();
  }

  fetchHealthData() async {
    try {
      healthDataList = await watcherService.fetchHeathDataInWatcher(
          context, widget.patient.id);
      processHealthData();
      _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
        try {
          final updatedHealthData = await watcherService
              .fetchHeathDataInWatcher(context, widget.patient.id);
          if (updatedHealthData != healthDataList) {
            healthDataList = updatedHealthData;
            processHealthData();
            diagnose = statusDiagnose();
            if (diagnose.isNotEmpty) {
              localNotifications.showNotification(
                  title: "Dangerous!! ${widget.patient.name} have",
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
    if (mounted) {
      listHeartData = getEachHealthData.getListHeartRate(healthDataList);
      listBloodData = getEachHealthData.getListBloodPressure(healthDataList);
      listOxyData = getEachHealthData.getListOxygen(healthDataList);
      listTempData = getEachHealthData.getListTemperature(healthDataList);
      listGlucoseData = getEachHealthData.getListGlucose(healthDataList);

      setState(() {});
    }
  }

  GetEachHealthData getEachHealthData = GetEachHealthData();

  List<Data> listHeartData = [];
  List<Data2> listBloodData = [];
  List<Data> listOxyData = [];
  List<Data> listTempData = [];
  List<Data> listGlucoseData = [];
  String statusDiagnose() {
    String diagnose;
    int heartRate = (listHeartData.isEmpty
            ? 0
            : listHeartData[listHeartData.length - 1].value)
        .toInt();
    List<int> bloodStatus = listBloodData.isEmpty
        ? [0, 0]
        : [
            listBloodData[listBloodData.length - 1].val1.toInt(),
            listBloodData[listBloodData.length - 1].val2.toInt(),
          ];
    double oxyStatus =
        (listOxyData.isEmpty ? 0 : listOxyData[listOxyData.length - 1].value);
    double tempStatus = (listTempData.isEmpty
        ? 0
        : listTempData[listTempData.length - 1].value);
    double glucoseStatus = (listGlucoseData.isEmpty
        ? 0
        : listGlucoseData[listGlucoseData.length - 1].value);
    diagnose = DiagnosisEngine.diagnoseHealth(
        tempStatus, bloodStatus, heartRate, glucoseStatus, oxyStatus);
    return diagnose;
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.ontap();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.1))
            ],
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFFFFFFF),
              ],
            ),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 1 / 1.2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    image: DecorationImage(
                        image: AssetImage(
                          widget.isWoman
                              ? 'images/womanAvatar.png'
                              : 'images/manAvatar.png',
                        ),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      (widget.email == null)
                          ? 'Email: No information'
                          : 'Email: ${widget.email}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diagnose:',
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text(
                          '${statusDiagnose()}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    )
                  ],
                )),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UpdateInfoView(
                                patientId: widget.patient.id,
                              )));
                    },
                    icon: const Icon(
                      Icons.settings,
                      size: 30,
                    ),
                    color: Colors.grey.shade600,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UpdatePatientInfoView(
                                patientId: widget.patient.id,
                                patientName: widget.patient.name,
                                patientPassword: widget.patient.password,
                              )));
                    },
                    icon: const Icon(
                      Icons.published_with_changes,
                      size: 30,
                    ),
                    color: Colors.grey.shade600,
                  ),
                  TextButton(
                      onPressed: () {
                        WatcherService().deletePatient(
                            context: context, userId: widget.patient.id);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Color(0xffb93939)),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
