import 'package:unidelivery_mobile/Model/DTO/index.dart';

class AccountDAO {
  Future<AccountDTO> getUser(String uid) async {
    return AccountDTO(uid: uid, name: "Default Name");
  }
}
