import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:heathtrack/objects/watcher.dart';
import 'package:heathtrack/providers/userProvider.dart';
import 'package:heathtrack/router.dart';
import 'package:heathtrack/screens/Login/login_view.dart';
import 'package:heathtrack/screens/patientScreens/patientControlScreen.dart';
import 'package:heathtrack/screens/watcherScreen/watcherControlScreen.dart';
import 'package:heathtrack/services/authService.dart';
import 'package:heathtrack/services/localNotifications.dart';
import 'package:provider/provider.dart';
import 'package:heathtrack/services/notificationService.dart';
import 'package:heathtrack/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  //them doan nay de nhan thong bao tu firebase
  callInitialize();
  WidgetsFlutterBinding.ensureInitialized;
  await localNotifications.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const HeathTrackApp()));
}

class HeathTrackApp extends StatefulWidget {
  const HeathTrackApp({super.key});

  @override
  State<HeathTrackApp> createState() => _HeathTrackAppState();
}

class _HeathTrackAppState extends State<HeathTrackApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (settings) => generateRoute(settings),
        home: Provider.of<UserProvider>(context).user.token.isNotEmpty
            ? Provider.of<UserProvider>(context).user.type == 'patient'
                ? const PatientControlScreen()
                : const WatcherControlScreen()
            : const LoginView());
  }
}
