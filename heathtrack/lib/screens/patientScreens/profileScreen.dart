import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heathtrack/constants/utils.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:heathtrack/services/profileService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../k_services/diagnoseEngine.dart';
import '../../widgets/InforBar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<File> image = [];

  var profileData;
  var bmi;
  var diagnoseBmi;

  Timer? _pollingTimer;

  final ProfileService profileService = ProfileService();
  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    fetchProfileData();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  fetchProfileData() async {
    try {
      profileData = await profileService.fetchProfileData(
          context: context,
          userId: Provider.of<UserProvider>(context, listen: false).user.id);
      bmi = DiagnosisEngine.calculateBMI(
          profileData.weight!, profileData.height!);
      diagnoseBmi = DiagnosisEngine.diagnoseBMI(bmi);
      processHealthData(); // Cập nhật giao diện với dữ liệu ban đầu

      // Bắt đầu bộ đếm thời gian long polling
      _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
        try {
          final updatedHealthData = await profileService.fetchProfileData(
              context: context,
              userId:
                  Provider.of<UserProvider>(context, listen: false).user.id);
          if (updatedHealthData != profileData) {
            // Cập nhật dữ liệu và giao diện nếu nhận được dữ liệu mới
            profileData = updatedHealthData;
            processHealthData();
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
      setState(() {});
    } // Cập nhật giao diện
  }

  void selectImage() async {
    var res = await pickImage();
    setState(() {
      image = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formatDate(String timeString) {
      String time; //2024-03-08T04:38:34.124Z
      time = DateFormat('dd/MM/yyyy').format(DateTime.parse(timeString));
      return time;
    }

    return Consumer<UserProvider>(
        builder: (BuildContext context, patient, child) {
      return profileData == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    color: const Color(0xfff7f7f7),
                    padding: const EdgeInsets.only(top: 100),
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
                                    child: image.isEmpty
                                        ? Image.network(
                                            profileData.image,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            image[0],
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    onPressed: () async {
                                      selectImage();
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      size: 25,
                                    ),
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          shortenName(patient.user.name),
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
                            patient.user.name,
                            // onTouch: (value) {
                            //   patient.updateName(value);
                            // },
                            onTouch: () {},
                            canEdit: false,
                          ),
                          Infor(
                            'Gender',
                            "${profileData.gender}",
                            canEdit: false, onTouch: () {},
                            // onTouch: (value) {
                            //   patient.updateSex(value);
                            // },
                          ),
                          Infor(
                            'Date of Birth',
                            (DateTime.parse(profileData.dateOfBirth) == null)
                                ? 'No information'
                                : DateFormat('dd/MM/yyyy').format(
                                    DateTime.parse(profileData.dateOfBirth)!),
                            onTouch: () {},
                            canEdit: false,
                          ),
                        ]),
                        InforBar('Communications', [
                          Infor(
                            'Phone number',
                            "${profileData.phoneNumber}",
                            onTouch: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext) {
                                    TextEditingController contentController =
                                        TextEditingController();
                                    contentController.text =
                                        patient.user.phoneNumber == null
                                            ? ''
                                            : '${profileData.phoneNumber}';
                                    return AlertDialog(
                                      title: const Text("Edit phone number"),
                                      content: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: contentController,
                                        decoration: InputDecoration(
                                            hintText:
                                                "${profileData.phoneNumber}"),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              profileService
                                                  .updatePhoneNumberProfile(
                                                      context: context,
                                                      phoneNumber:
                                                          contentController
                                                              .text,
                                                      userId: Provider.of<
                                                                  UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .user
                                                          .id);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("OK")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel")),
                                      ],
                                    );
                                  });
                            },
                          ),
                          Infor(
                            'Email',
                            "${patient.user.email}",
                            // onTouch: (value) {
                            //   patient.updateEmail(value);
                            // },
                            canEdit: false, onTouch: () {},
                          ),
                        ]),
                        InforBar('Body indicators', [
                          Infor(
                            'Blood Type',
                            '${profileData.bloodType}',
                            onTouch: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext) {
                                    TextEditingController contentController =
                                        TextEditingController();
                                    contentController.text =
                                        profileData.bloodType == null
                                            ? ''
                                            : '${profileData.bloodType}';
                                    return AlertDialog(
                                      title: const Text("Edit Blood Type"),
                                      content: TextField(
                                          keyboardType: TextInputType.number,
                                          controller: contentController,
                                          decoration: InputDecoration(
                                              hintText:
                                                  "${profileData.bloodType}")),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              profileService
                                                  .updateBloodTypeProfile(
                                                      context: context,
                                                      bloodType:
                                                          contentController
                                                              .text,
                                                      userId: Provider.of<
                                                                  UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .user
                                                          .id);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("OK")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel")),
                                      ],
                                    );
                                  });
                            },
                          ),
                          Infor(
                            'Height (cm)',
                            '${profileData.height}',
                            onTouch: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext) {
                                    TextEditingController contentController =
                                        TextEditingController();
                                    contentController.text =
                                        profileData.height == null
                                            ? ''
                                            : '${profileData.height}';
                                    return AlertDialog(
                                      title: const Text("Edit height"),
                                      content: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: contentController,
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              profileService
                                                  .updateHeightProfile(
                                                      context: context,
                                                      height: double.parse(
                                                          contentController
                                                              .text),
                                                      userId: Provider.of<
                                                                  UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .user
                                                          .id);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("OK")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel")),
                                      ],
                                    );
                                  });
                            },
                          ),
                          Infor(
                            'Weight (kg)',
                            '${profileData.weight}',
                            onTouch: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext) {
                                    TextEditingController contentController =
                                        TextEditingController();
                                    contentController.text =
                                        profileData.weight == null
                                            ? ''
                                            : '${profileData.weight}';
                                    return AlertDialog(
                                      title: const Text("Edit weight"),
                                      content: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: contentController,
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              profileService
                                                  .updateWeightProfile(
                                                      context: context,
                                                      weight: double.parse(
                                                          contentController
                                                              .text),
                                                      userId: Provider.of<
                                                                  UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .user
                                                          .id);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("OK")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Cancel")),
                                      ],
                                    );
                                  });
                            },
                          ),
                          Infor(
                            'BMI',
                            bmi != null
                                ? '$bmi ($diagnoseBmi)'
                                : 'no information',
                            canEdit: false,
                            onTouch: () {},
                          )
                        ])
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 85,
                  decoration: const BoxDecoration(
                    color: Color(0xfff7f7f7),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                  ),
                ),
              ],
            );
    });
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
}
