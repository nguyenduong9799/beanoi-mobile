import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';

class DynamicLinkService {
  static Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;

      if (deepLink != null) {
        print("Link: ${deepLink.path}");
        handleNaviagtion(deepLink.path);
      }else{
      print("Resume WTF");
    }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });

    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      print("Link: ${deepLink.path}");
      // ignore: unawaited_futures
      Timer.periodic(Duration(milliseconds: 500), (timer) {
            if(Get.key.currentState == null)
              return;
            handleNaviagtion(deepLink.path);
            timer.cancel();
          });
    }else{
      print("Init WTF");
    }
  }

  static void handleNaviagtion(String path) {
      switch (path) {
        case RouteHandler.HOME:
          Get.toNamed(RouteHandler.NAV, arguments: 0);
          break;
        case RouteHandler.GIFT:
          Get.toNamed(RouteHandler.NAV, arguments: 1);
          break;
        case RouteHandler.PROFILE:
          Get.toNamed(RouteHandler.NAV, arguments: 2);
          break;
        default:
          Get.toNamed(path);
    }
  }
}
