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
          print('onMessage: $message');
          hideSnackbar();
          Get.snackbar(
              message['aps']['alert']['title'], // title
              message['aps']['alert']['body'],
              colorText: kPrimary,
              icon: Icon(Icons.alarm),
              shouldIconPulse: true,
              backgroundColor: kBackgroundGrey[0],
              isDismissible: true,
              duration: Duration(minutes: 1),
              mainButton: FlatButton(
                child: Text(
                  "OK",
                  style: kTextPrimary,
                ),
                onPressed: () {
                  hideSnackbar();
                },
              ));
          // Get.rawSnackbar(
          //     message: message['notification']['title'],
          //     duration: ,
          //     snackPosition: SnackPosition.TOP,
          //     margin: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 32),
          //     backgroundColor: kPrimary,
          //     borderRadius: 8);
          // await showStatusDialog(
          //     Icon(Icons.info_outline),
          //     message['notification']['title'],
          //     message['notification']['body']);
        },
        //Called when the app has been closed completely and its opened
        onLaunch: (Map<String, dynamic> message) async {
          print('onLaunch: $message');
        },
        //Called when the app is in the background
        onResume: (Map<String, dynamic> message) async {
          print('onResume: $message');
        },
      );
      _initialized = true;
    }
  }

  Future<String> getFcmToken() async {
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");
    return token;
  }
}
