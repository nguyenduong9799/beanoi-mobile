import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationService {
  PushNotificationService._();

  factory PushNotificationService() => _instance;

  static final PushNotificationService _instance = PushNotificationService._();

  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init(BuildContext context) async {
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
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: Text(message['notification']['title']),
              content: Text(message['notification']['body']),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                )
              ],
            );
          },);
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
