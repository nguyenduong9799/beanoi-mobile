import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class AccountDAO {
  Future<AccountDTO> getUser(String idToken) async {
    // Response response = await Dio().post(
    //     "http://192.168.88.12:45455/api/authen",
    //     options: RequestOptions(connectTimeout: 10),
    //     data: {"id_token": idToken});
    return AccountDTO(uid: idToken, name: "Default Name");
  }

  Future<AccountDTO> updateUser(AccountDTO updateUser) async {
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
