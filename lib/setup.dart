import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Services/push_notification_service.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

Future setUp() async {
  await Firebase.initializeApp();
  PushNotificationService ps = PushNotificationService.getInstance();
  await ps.init();
}

void createRouteBindings() async {
  Get.put(RootViewModel());
  Get.put(HomeViewModel());
  Get.put(GiftViewModel());
  Get.put(AccountViewModel());
  Get.put(OrderHistoryViewModel());
}
