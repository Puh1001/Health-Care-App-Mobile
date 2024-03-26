import 'package:flutter/material.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:heathtrack/screens/watcherScreen/watcherHomeScreen.dart';
import 'package:heathtrack/screens/watcherScreen/watcherProfileScreen.dart';
import 'package:heathtrack/screens/watcherScreen/watcherSettingScreen.dart';
import 'package:provider/provider.dart';

class WatcherControlScreen extends StatefulWidget {
  static const String routeName = '/WatcherControl';
  const WatcherControlScreen({super.key});

  @override
  State<WatcherControlScreen> createState() => _WatcherControlScreenState();
}

class _WatcherControlScreenState extends State<WatcherControlScreen> {
  int selectedIndex = 0;
  final List<Widget> _children = [
    WatcherHomeScreen(),
    WatcherProfileScreen(),
    WatcherSettingScreen()
  ];
  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).setWatcher();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Provider.of<UserProvider>(context).theme.backgroundColor1,
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Setting'),
            ],
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            backgroundColor:
                Provider.of<UserProvider>(context).theme.backgroundColor2,
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
