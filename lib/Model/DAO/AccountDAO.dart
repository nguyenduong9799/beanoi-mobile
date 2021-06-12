import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Services/firebase_authentication_service.dart';
import 'package:unidelivery_mobile/Services/push_notification_service.dart';
import 'package:unidelivery_mobile/Utils/index.dart';

import 'index.dart';


// TODO: Test Start_up Screen + FCM TOken

class AccountDAO extends BaseDAO {
  Future<AccountDTO> login(String idToken) async {
    try {
      String fcmToken =
          await PushNotificationService.getInstance().getFcmToken();

      Response response = await request
          .post("login", data: {"id_token": idToken, "fcm_token": fcmToken});
      // set access token
      final user = response.data["data"];
      final userDTO = AccountDTO.fromJson(user);
      final accessToken = user["access_token"] as String;
      // print("accessToken    $accessToken");
      requestObj.setToken = accessToken;
      setToken(accessToken);
      return userDTO;
    } catch (e) {
    }
    return null;
    // return AccountDTO(uid: idToken, name: "Default Name");
  }

  Future<bool> isUserLoggedIn() async {
    final token = await getToken();
    if (token != null) requestObj.setToken = token;
    return token != null;
  }

  Future<AccountDTO> getUser() async {
    Response response = await request.get("me");
    // set access token
    final user = response.data["data"];
    return AccountDTO.fromJson(user);
    // return AccountDTO(uid: idToken, name: "Default Name");
  }

  Future<String> getRefferalMessage(String refferalCode) async {
    Response response = await request.post("/me/refferal", data: "'$refferalCode'");
    // set access token
    return response.data['message'];
    // return AccountDTO(uid: idToken, name: "Default Name");
  }

  Future<void> sendFeedback(String feedBack) async {
    await request.post("/me/feedback", data: "'$feedBack'");
  }

  Future<void> logOut() async {
    await AuthService().signOut();
    String fcmToken = await PushNotificationService.getInstance().getFcmToken();
    await request.post("logout", data: {"fcm_token": fcmToken});
  }

  Future<AccountDTO> updateUser(AccountDTO updateUser) async {
    final updateJSON = updateUser.toJson();
    Response res = await request.put("me", data: updateUser.toJson());
    return AccountDTO.fromJson(res.data["data"]);
  }
}
