import 'package:firebase_core/firebase_core.dart';
import 'package:unidelivery_mobile/Services/push_notification_service.dart';

Future setUp() async {
  // setStore(null);
  // setCart(null);
  await Firebase.initializeApp();
  PushNotificationService ps = PushNotificationService.getInstance();
  await ps.init();
}
