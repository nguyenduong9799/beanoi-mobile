import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';

class SignUpViewModel extends Model {
  static SignUpViewModel _instance;
  AccountDAO dao = AccountDAO();

  SignUpViewModel() {}
  static SignUpViewModel getInstance() {
    if (_instance == null) {
      _instance = SignUpViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  Future<AccountDTO> updateUser(AccountDTO user) async {
    try {
      final updatedUser = await dao.updateUser(user);
      return updatedUser;
    } on Exception catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
