import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';

class SignUpViewModel extends Model {
  static SignUpViewModel _instance;
  AccountDAO dao = AccountDAO();
  bool isUpdating = false;
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

  Future<AccountDTO> updateUser(Map<String, dynamic> user) async {
    try {
      isUpdating = true;
      notifyListeners();
      final userDTO = AccountDTO(
        name: user["name"],
        email: user["email"],
        birthdate: user["birthdate"],
        phone: user["phone"],
        gender: user["gender"],
      );
      final updatedUser = await dao.updateUser(userDTO);
      await Future.delayed(Duration(seconds: 3));
      return updatedUser;
    } on Exception catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
