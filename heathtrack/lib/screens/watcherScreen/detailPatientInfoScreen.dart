import 'package:flutter/material.dart';
import 'package:heathtrack/constants/utils.dart';
import 'package:heathtrack/models/profile.dart';
import 'package:heathtrack/services/profileService.dart';
import 'package:intl/intl.dart';

import '../../k_services/diagnoseEngine.dart';
import '../../objects/patient.dart';
import '../../widgets/InforBar.dart';

class DetailPatientInfoScreen extends StatefulWidget {
  DetailPatientInfoScreen({super.key, required this.patient});
  Patient patient;

  @override
  State<DetailPatientInfoScreen> createState() =>
      _DetailPatientInfoScreenState();
}

class _DetailPatientInfoScreenState extends State<DetailPatientInfoScreen> {
  final ProfileService profileService = ProfileService();
  var profileData;
  var bmi;
  var diagnoseBmi;
  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    fetchProfileData();
  }

  fetchProfileData() async {
    try {
      profileData = await profileService.fetchProfileData(
          context: context, userId: widget.patient.id);
      bmi = DiagnosisEngine.calculateBMI(
          profileData.weight!, profileData.height!);
      diagnoseBmi = DiagnosisEngine.diagnoseBMI(bmi);
      if (mounted) {
        setState(() {});
      }
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String formatDate(String timeString) {
      String time; //2024-03-08T04:38:34.124Z
      time = DateFormat('dd/MM/yyyy').format(DateTime.parse(timeString));
      return time;
    }

    return profileData == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('${widget.patient.name}\'s information'),
            ),
            body: SingleChildScrollView(
              child: Container(
                color: const Color(0xfff7f7f7),
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      child: CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.white,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: ClipOval(
                                child: Image.network(
                                  profileData.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      shortenName(widget.patient.name),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InforBar('Main Information', [
                      Infor(
                        'Name',
                        widget.patient.name,
                        onTouch: () {},
                        canEdit: false,
                      ),
                      Infor(
                        'Gender',
                        "${profileData.gender}",
                        canEdit: false,
                        onTouch: () {},
                      ),
                      Infor(
                        'Date of Birth',
                        (profileData.dateOfBirth == null)
                            ? 'No information'
                            : "${formatDate(profileData.dateOfBirth)}",
                        onTouch: () {},
                        canEdit: false,
                      ),
                    ]),
                    InforBar('Communications', [
                      Infor(
                        'Phone number',
                        "${profileData.phoneNumber}",
                        canEdit: false,
                        onTouch: () {},
                      ),
                      Infor(
                        'Email',
                        "${widget.patient.email}",
                        canEdit: false,
                        onTouch: () {},
                      ),
                    ]),
                    InforBar('Body indicators', [
                      Infor('Blood Type', '${profileData.bloodType}',
                          canEdit: false, onTouch: () {}),
                      Infor('Height (cm)', '${profileData.height}',
                          canEdit: false, onTouch: () {}),
                      Infor('Weight (kg)', '${profileData.weight}',
                          canEdit: false, onTouch: () {}),
                      Infor(
                        'BMI',
                        bmi != null ? '$bmi ($diagnoseBmi)' : 'no information',
                        canEdit: false,
                        onTouch: () {},
                      )
                    ])
                  ],
                ),
              ),
            ),
          );
  }
}

String shortenName(String fullName) {
  String shortenName;
  fullName = fullName.trim();
  if (fullName.contains(" ")) {
    String startString = fullName.substring(0, fullName.indexOf(' '));
    String endString = fullName.substring(fullName.lastIndexOf(' ') + 1);
    shortenName = "$startString $endString";
  } else {
    shortenName = fullName;
  }
  return shortenName;
}
