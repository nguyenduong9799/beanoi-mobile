import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';

import '../route_constraint.dart';

class SignUpViewModel extends BaseModel {
  AccountDAO dao = AccountDAO();

  SignUpViewModel() {}

  Future<void> updateUser(Map<String, dynamic> user) async {
    try {
      setState(ViewStatus.Loading);
      final userDTO = AccountDTO(
        name: user["name"],
        email: user["email"],
        birthdate: user["birthdate"],
        phone: user["phone"],
        gender: user["gender"],
      );
      await dao.updateUser(userDTO);
      // setToken here
      setState(ViewStatus.Completed);
      Get.back(result: true);
      // await Future.delayed(Duration(seconds: 3));
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await updateUser(user);
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> signupUser(Map<String, dynamic> user) async {
    try {
      setState(ViewStatus.Loading);
      final userDTO = AccountDTO(
        name: user["name"],
      );
      await dao.updateUser(userDTO);
      // setToken here
      setState(ViewStatus.Completed);
      Get.offAllNamed(RouteHandler.NAV);
      // await Future.delayed(Duration(seconds: 3));
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await signupUser(user);
      } else
        setState(ViewStatus.Error);
    }
  }
}
