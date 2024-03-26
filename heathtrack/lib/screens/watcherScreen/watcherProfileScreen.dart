import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:heathtrack/constants/utils.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:heathtrack/services/profileService.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../widgets/updateWatcherInfoView.dart';
import '../../widgets/InforBar.dart';

class WatcherProfileScreen extends StatefulWidget {
  @override
  State<WatcherProfileScreen> createState() => _WatcherProfileScreenState();
}

class _WatcherProfileScreenState extends State<WatcherProfileScreen> {
  List<File> image = [];
  final ProfileService profileService = ProfileService();
  var profileDataList = [];

  Timer? _pollingTimer;

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
      profileDataList = await profileService.fetchWatcherProfileData(
          context: context,
          userId: Provider.of<UserProvider>(context, listen: false).user.id);
      processHealthData(); // Cập nhật giao diện với dữ liệu ban đầu

      // Bắt đầu bộ đếm thời gian long polling
      _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
        try {
          final updatedHealthData =
              await profileService.fetchWatcherProfileData(
                  context: context,
                  userId: Provider.of<UserProvider>(context, listen: false)
                      .user
                      .id);
          if (updatedHealthData != profileDataList) {
            // Cập nhật dữ liệu và giao diện nếu nhận được dữ liệu mới
            profileDataList = updatedHealthData;
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

  @override
  Widget build(BuildContext context) {
    String formatDate(String timeString) {
      String time; //2024-03-08T04:38:34.124Z
      time = DateFormat('dd/MM/yyyy').format(DateTime.parse(timeString));
      return time;
    }

    return Consumer<UserProvider>(builder: (context, watcher, child) {
      return profileDataList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              appBar: AppBar(
                leading: Container(),
                centerTitle: true,
                title: Text('Information'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UpdateWatcherInfoView(
                                patientId: Provider.of<UserProvider>(context,
                                    listen: false),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Edit',
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                ],
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
                                    profileDataList[0].image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        shortenName(watcher.user.name),
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
                          watcher.user.name,
                          onTouch: () {},
                          canEdit: false,
                        ),
                        Infor(
                          'Gender',
                          "${profileDataList[0].gender}",
                          canEdit: false,
                          onTouch: () {},
                        ),
                        Infor(
                          'Date of Birth',
                          (DateTime.parse(profileDataList[0].dateOfBirth) ==
                                  null)
                              ? 'No information'
                              : DateFormat('dd/MM/yyyy').format(DateTime.parse(
                                  profileDataList[0].dateOfBirth)!),
                          onTouch: () {},
                          canEdit: false,
                        ),
                      ]),
                      InforBar('Communications', [
                        Infor(
                          'Phone number',
                          "${profileDataList[0].phoneNumber}",
                          onTouch: () {},
                          canEdit: false,
                        ),
                        Infor(
                          'Email',
                          "${watcher.user.email}",
                          canEdit: false,
                          onTouch: () {},
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            );
    });
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
