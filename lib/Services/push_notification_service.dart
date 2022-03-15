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

    FirebaseMessaging.onMessage.listen( (event) async {
      hideSnackbar();
      RemoteNotification notification = event.notification;
      await showStatusDialog("assets/images/option.png", notification.title, notification.body);

    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      var screen = event.data['screen'];
      if(screen == RouteHandler.PRODUCT_FILTER_LIST) {
        Get.toNamed(RouteHandler.PRODUCT_FILTER_LIST,
          arguments: event.data,
        );
      }
    });
  }

  Future<String> getFcmToken() async {
    if (!isSmartPhoneDevice()) return null;
    String token = await _fcm.getToken();
    return token;
  }
}
