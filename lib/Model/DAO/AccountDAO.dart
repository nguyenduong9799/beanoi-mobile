import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class AccountDAO {
  Future<AccountDTO> getUser(String idToken) async {
    Response response =
        await Dio().post("http://115.165.166.32:14254/api/authen",
            // options: RequestOptions(connectTimeout: 10),
            data: {"id_token": idToken});
    // set access token
    requestObj.setToken = response.data["data"]["access_token"] as String;
    return AccountDTO.fromJson(response.data["data"]);
    // return AccountDTO(uid: idToken, name: "Default Name");
  }

  Future<AccountDTO> updateUser(AccountDTO updateUser) async {
    // Response res = await Dio().put(
    //   "http://115.165.166.32:14254/api/customers/me",
    //   // options: RequestOptions(connectTimeout: 10),
    //   data: updateUser,
    // );
    // return AccountDTO.fromJson(res.data["data"]);
    return AccountDTO(
      uid: updateUser.uid,
      name: "${updateUser.name} Updated Name",
      phone: "0123456789",
      gender: "nam",
      email: "bemail@gmail.com",
      birthdate: DateTime.now(),
    );
  }
}
