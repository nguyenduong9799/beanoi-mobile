import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:flutter/foundation.dart';
import 'package:unidelivery_mobile/Utils/index.dart';

class PushNotificationService {
  static PushNotificationService _instance;

  static PushNotificationService getInstance() {
    if (_instance == null) {
      _instance = PushNotificationService();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future init() async {
    if ((defaultTargetPlatform == TargetPlatform.iOS)) {
      await _fcm.requestPermission();
      _fcm.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
    }

    RemoteMessage message =
        await FirebaseMessaging.instance.getInitialMessage();
    print("onInit: $message");

    FirebaseMessaging.onMessage.listen((event) {
      hideSnackbar();
      RemoteNotification notification = event.notification;
      Get.snackbar(
          notification.title, // title
          notification.body,
          colorText: kPrimary,
          shouldIconPulse: true,
          backgroundColor: Colors.white.withOpacity(0.8),
          isDismissible: true,
          duration: Duration(minutes: 1),
          mainButton: TextButton(
            child: Text(
              "Đồng ý",
              style: Get.theme.textTheme.headline4.copyWith(color: kPrimary),
            ),
            onPressed: () {
              hideSnackbar();
            },
          ));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('onResume: $event');
    });
  }

  Future<String> getFcmToken() async {
    if (!isSmartPhoneDevice()) return null;
    String token = await _fcm.getToken();
    return token;
  }
}
