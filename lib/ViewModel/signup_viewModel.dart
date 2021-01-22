import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';

class SignUpViewModel extends BaseModel {
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

  Future<AccountDTO> updateUser(Map<String, dynamic> user) async {
    try {
      setState(ViewStatus.Loading);
      final userDTO = AccountDTO(
        name: user["name"],
        email: user["email"],
        birthdate: user["birthdate"],
        phone: user["phone"],
        gender: user["gender"],
      );
      final updatedUser = await dao.updateUser(userDTO);
      // setToken here
      setState(ViewStatus.Completed);
      // await Future.delayed(Duration(seconds: 3));
      return updatedUser;
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await updateUser(user);
      } else
        setState(ViewStatus.Error);
    }
  }
}
