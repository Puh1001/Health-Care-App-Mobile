import 'package:flutter/material.dart';
import 'package:heathtrack/screens/patientScreens/mapScreen.dart';
import 'package:heathtrack/screens/patientScreens/profileScreen.dart';
import 'package:provider/provider.dart';

import '../../constants/utils.dart';
import '../../providers/userProvider.dart';
import '../../services/patientServices.dart';
import 'homeScreen.dart';
import '../../screens/patientScreens/newsScreen.dart';

class PatientControlScreen extends StatefulWidget {
  const PatientControlScreen({super.key});
  static const String routeName = '/PatientControl';
  @override
  State<PatientControlScreen> createState() => _PatientControlScreenState();
}

class _PatientControlScreenState extends State<PatientControlScreen> {
  int selectedIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    const MapScreen(),
    const ViewModel(),
    const ProfileScreen()
  ];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).setPatient();
        final PatientServices patientServices = PatientServices();
        Future fetchHealthData() async {
          try {
            final healthDataList =
                await patientServices.fetchHeathData(context);
            if (healthDataList != null) {
              // print(healthDataList);
              setState(() {});
            } else {
              print("No health data found");
            }
          } catch (err) {
            showSnackBar(context, err.toString());
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      body: _children[selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            //color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 25)
            ]),
        margin: EdgeInsets.only(right: 12, left: 12, bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper), label: 'News'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.black54,
            selectedItemColor: const Color(0xFF68E3B3),
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
