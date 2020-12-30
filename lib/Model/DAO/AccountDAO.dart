import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Services/firebase.dart';
import 'package:unidelivery_mobile/services/push_notification_service.dart';
import 'package:unidelivery_mobile/utils/request.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

// TODO: Test Start_up Screen + FCM TOken

class AccountDAO {
  Future<AccountDTO> login(String idToken) async {
    try {
      String fcmToken =
          await PushNotificationService.getInstance().getFcmToken();
      print("FCM_token: " + fcmToken);

      Response response = await request
          .post("/login", data: {"id_token": idToken, "fcm_token": fcmToken});
      print('idToken $idToken');
      // set access token
      final user = response.data["data"];
      final userDTO = AccountDTO.fromJson(user);
      final accessToken = user["access_token"] as String;
      print("accessToken    $accessToken");
      requestObj.setToken = accessToken;
      setToken(accessToken);
      return userDTO;
    } catch (e) {
      print("error: " + e.toString());
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
    Response response = await request.get("/me");
    // set access token
    final user = response.data["data"];

    return AccountDTO.fromJson(user);
    // return AccountDTO(uid: idToken, name: "Default Name");
  }

  Future<void> logOut() async {
    await AuthService().signOut();
    String fcmToken = await PushNotificationService.getInstance().getFcmToken();
    await request.post("/logout", data: {"fcm_token": fcmToken});
  }

  Future<AccountDTO> updateUser(AccountDTO updateUser) async {
    final updateJSON = updateUser.toJson();
    print('updateUser');
    print(updateJSON.toString());
    Response res = await request.put("/me", data: updateUser.toJson());
    return AccountDTO.fromJson(res.data["data"]);
  }
}
