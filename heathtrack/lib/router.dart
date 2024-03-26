import 'package:flutter/material.dart';
import 'package:heathtrack/objects/patient.dart';
import 'package:heathtrack/screens/Login/login_view.dart';
import 'package:heathtrack/screens/Login/register_view.dart';
import 'package:heathtrack/screens/patientScreens/patientControlScreen.dart';
import 'package:heathtrack/screens/watcherScreen/watcherControlScreen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginView.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const LoginView());
    case RegisterView.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const RegisterView());
    case WatcherControlScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const WatcherControlScreen());
    case PatientControlScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const PatientControlScreen());
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist !!'),
          ),
        ),
      );
  }
}
