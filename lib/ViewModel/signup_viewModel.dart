import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';

import 'index.dart';

class SignUpViewModel extends BaseModel {
  AccountDAO dao;

  SignUpViewModel() {
    dao = AccountDAO();
  }

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
      Get.toNamed(RouteHandler.SIGN_UP_REFERRAL);

      // await Future.delayed(Duration(seconds: 3));
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await signupUser(user);
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> addReferralCode(String refferalCode) async {
    try {
      if (refferalCode != null && refferalCode.isNotEmpty) {
        showLoadingDialog();
        String message = await dao.getRefferalMessage(refferalCode);
        await showStatusDialog("assets/images/option.png", "", message);
        await Get.find<RootViewModel>().startUp();
        Get.offAllNamed(RouteHandler.NAV);
        hideDialog();
      } else {
        await Get.find<RootViewModel>().startUp();
        Get.offAllNamed(RouteHandler.NAV);
      }
    } catch (e, stacktrace) {
      print(e.toString() + stacktrace.toString());
      bool result = await showErrorDialog(
          errorTitle: (e as DioError).response.data['error']['message']);
    }
  }
}
