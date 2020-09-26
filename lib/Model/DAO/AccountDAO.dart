import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/utils/request.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

class AccountDAO {
  Future<AccountDTO> login(String idToken) async {
    Response response =
        await request.post("/login", data: {"id_token": idToken});
    // set access token
    final user = response.data["data"];
    final accessToken = user["access_token"] as String;
    requestObj.setToken = accessToken;
    setToken(accessToken);
    return AccountDTO.fromJson(user);
    // return AccountDTO(uid: idToken, name: "Default Name");
  }

  Future<AccountDTO> getUser() async {
    Response response = await request.get("/me");
    // set access token
    final user = response.data["data"];

    return AccountDTO.fromJson(user);
    // return AccountDTO(uid: idToken, name: "Default Name");
  }

  Future<AccountDTO> updateUser(AccountDTO updateUser) async {
    final updateJSON = updateUser.toJson();
    print('updateUser');
    print(updateJSON.toString());
    Response res = await request.put("/me", data: updateUser.toJson());
    final user = res.data["data"];
    return AccountDTO.fromJson(res.data["data"]);
    // return AccountDTO(
    //   uid: updateUser.uid,
    //   name: "${updateUser.name} Updated Name",
    //   phone: "0123456789",
    //   gender: "nam",
    //   email: "bemail@gmail.com",
    //   birthdate: DateTime.now(),
    // );
  }
}
