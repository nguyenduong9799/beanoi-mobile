import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/constraints.dart';

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

  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool _initialized = false;

  Future init() async {
    if (!_initialized) {
      if (Platform.isIOS) {
        _fcm.requestNotificationPermissions(IosNotificationSettings());
      } else {
        _fcm.requestNotificationPermissions();
      }
      _fcm.configure(
        //Called when the app is in the foreground and we receive a push notification
        onMessage: (Map<String, dynamic> message) async {
          hideSnackbar();
          Get.snackbar(
              Platform.isIOS
                  ? message['aps']['alert']['title']
                  : message['notification']['title'], // title
              Platform.isIOS
                  ? message['aps']['alert']['body']
                  : message['notification']['body'],
              colorText: kBackgroundGrey[0],
              shouldIconPulse: true,
              backgroundColor: kPrimary,
              isDismissible: true,
              duration: Duration(minutes: 1),
              mainButton: FlatButton(
                color: kPrimary,
                child: Text(
                  "Đồng ý",
                  style: kTextPrimary,
                ),
                onPressed: () {
                  hideSnackbar();
                },
              ));
        },
        //Called when the app has been closed completely and its opened
        onLaunch: (Map<String, dynamic> message) async {},
        //Called when the app is in the background
        onResume: (Map<String, dynamic> message) async {},
      );
      _initialized = true;
    }
  }

  Future<String> getFcmToken() async {
    String token = await _fcm.getToken();
    return token;
  }
}
