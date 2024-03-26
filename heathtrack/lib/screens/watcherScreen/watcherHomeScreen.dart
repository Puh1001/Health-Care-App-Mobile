import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:heathtrack/screens/watcherScreen/patientMornitoringScreen.dart';
import 'package:heathtrack/services/watcherService.dart';
import 'package:heathtrack/widgets/patientCard.dart';
import 'package:provider/provider.dart';
import '../../constants/utils.dart';
import '../../objects/patient.dart';
import '../../widgets/deviceCard.dart';

class WatcherHomeScreen extends StatefulWidget {
  const WatcherHomeScreen({super.key});

  @override
  State<WatcherHomeScreen> createState() => _WatcherHomeScreenState();
}

class _WatcherHomeScreenState extends State<WatcherHomeScreen> {
  List<Patient> listPatient = [];
  final WatcherService watcherService = WatcherService();
  var listPatientInW = [];

  Timer? _pollingTimer;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    fetchAddressPatient();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  fetchAddressPatient() async {
    try {
      listPatientInW = await watcherService.fetchAddressPatient(
        context: context,
        watcherId: Provider.of<UserProvider>(context, listen: false).user.id,
      );
      processHealthData();
      _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
        try {
          final updatedHealthData = await watcherService.fetchAddressPatient(
            context: context,
            watcherId:
                Provider.of<UserProvider>(context, listen: false).user.id,
          );
          if (updatedHealthData != listPatientInW) {
            listPatientInW = updatedHealthData;
            processHealthData();
          }
        } catch (err) {
          print(err.toString());
        }
      });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
    listPatient.clear();
    for (var i in listPatientInW) {
      Patient patient = Patient(
          id: '',
          name: '',
          email: '',
          password: '',
          familyCode: '',
          address: '',
          type: '',
          token: '',
          watcherId: '');
      patient.getDataFromPatientInWatcher(i);
      listPatient.add(patient);
    }
  }

  processHealthData() {
    if (mounted) {
      setState(() {});
    }
  }

  bool mySwitch = true;
  TextEditingController patientName = TextEditingController();
  TextEditingController patientEmail = TextEditingController();
  TextEditingController patientPassword = TextEditingController();
  TextEditingController ageController = TextEditingController();

  void addPatient() {
    setState(() {
      watcherService.addPatient(
        context: context,
        name: patientName.text,
        email: patientEmail.text,
        password: patientPassword.text,
        age: ageController.text,
        type: 'patient',
        familyCode:
            Provider.of<UserProvider>(context, listen: false).user.familyCode,
        watcherId: Provider.of<UserProvider>(context, listen: false).user.id,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, watcher, child) {
      return listPatientInW.isEmpty || listPatient.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                      elevation: 5,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 20,
                                  left: 20,
                                  right: 20,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          20),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  )),
                              width: MediaQuery.sizeOf(context).width,
                              child: Column(
                                children: [
                                  const Text(
                                    'New patient',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: patientName,
                                    decoration: const InputDecoration(
                                      label: Text('Patient\'s name'),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: patientEmail,
                                    decoration: const InputDecoration(
                                      label: Text('Email'),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: ageController,
                                    decoration: const InputDecoration(
                                      label: Text('Age'),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: patientPassword,
                                    decoration: const InputDecoration(
                                      label: Text('Password'),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (patientName.text.isEmpty ||
                                          patientEmail.text.isEmpty ||
                                          patientPassword.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Please complete information!')),
                                        );
                                      } else {
                                        setState(() {
                                          addPatient();
                                        });
                                        Navigator.pop(context);
                                        // _dialogAddInfo();
                                      }
                                    },
                                    style: const ButtonStyle(
                                        padding: MaterialStatePropertyAll(
                                            EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 10)),
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.red),
                                        foregroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.white)),
                                    child: const Text('Add new'),
                                  ),
                                ],
                              ),
                            ),
                          ));
                },
                backgroundColor: const Color(0xff9bc7d5),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                ),
              ),
              backgroundColor: watcher.theme.backgroundColor1,
              body: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      const CircleAvatar(
                        radius: 30.0,
                        backgroundImage: AssetImage('images/avatar.png'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(watcher.user.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: watcher.theme.textColor1)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: watcher.theme.backgroundColor2),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      mySwitch = true;
                                    });
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: mySwitch
                                            ? const Color(0xFFA5C8EB)
                                            : Colors.transparent),
                                    child: const Text(
                                      'list patients',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    mySwitch = false;
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: !mySwitch
                                            ? const Color(0xFFA5C8EB)
                                            : Colors.transparent),
                                    child: const Text(
                                      'list devices',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        mySwitch
                            ? SizedBox(
                                height: MediaQuery.sizeOf(context).height - 250,
                                child: SingleChildScrollView(
                                  child: listPatient.isEmpty
                                      ? Text('No patients yet')
                                      : Column(
                                          children: listPatient
                                              .map((e) => PatientCard(
                                                    isWoman: false,
                                                    name: e.name,
                                                    email: e.email,
                                                    ontap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PatientMornitoringScreen(
                                                                      patient:
                                                                          e)));
                                                    },
                                                    patient: e,
                                                    diagnose: '',
                                                    userId: e.id,
                                                  ))
                                              .toList(),
                                        ),
                                ),
                              )
                            : const DeviceCard()
                      ],
                    ),
                  ),
                ],
              ),
            );
    });
  }

//   Future _dialogAddInfo() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Notice:'),
//           content: const SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('Create new patient !'),
//                 Text('Add information to new patient ?'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Okay'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => UpdateInfoView(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
}

int getAge(String date) {
  int now = DateTime.now().year;
  int age = now - int.parse(date.substring(0, 4));
  return age;
}
