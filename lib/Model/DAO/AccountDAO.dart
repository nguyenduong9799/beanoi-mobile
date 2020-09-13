import 'package:unidelivery_mobile/Model/DTO/index.dart';

class AccountDAO {
  Future<AccountDTO> getUser(String uid) async {
    return AccountDTO(uid: uid, name: "Default Name");
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
