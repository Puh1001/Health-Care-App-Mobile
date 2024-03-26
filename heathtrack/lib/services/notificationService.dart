import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class SendNotification {}

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  // hàm gửi thông báo ra màn hình ngoài
  static Future init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final token = await _firebaseMessaging.getToken();
    // ignore: avoid_print
    print('device token: $token');
  }
}

//hàm gửi thông báo ra màn hình ngoài, nhận được thì in ra
Future firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    // ignore: avoid_print
    print('receive notification');
  }
}

void callInitialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  PushNotifications.init();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);
}
