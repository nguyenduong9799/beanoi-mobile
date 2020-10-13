import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Services/firebase.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

import '../constraints.dart';
import '../route_constraint.dart';

class LoginViewModel extends BaseModel {
  static LoginViewModel _instance;
  AccountDAO dao = AccountDAO();
  String verificationId;

  static LoginViewModel getInstance() {
    if (_instance == null) {
      _instance = LoginViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  AccountDTO user;

  LoginViewModel() {}

  Future<AccountDTO> signIn(AuthCredential authCredential) async {
    try {
      // lay thong tin user tu firebase
      final userCredential = await AuthService().signIn(authCredential);
      // lay thong tin user tu sereer
      // TODO: Thay uid = idToken
      final userInfo = await dao.login(await userCredential.user.getIdToken());
      // await setToken(userInfo.toString());
      return userInfo;
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await signIn(authCredential);
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> signOut() async {
    await AuthService().signOut();
    await setToken(null);
  }

  Future<void> onLoginWithPhone(String phone) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) async {
      try {
        showLoadingDialog();
        final userInfo = await signIn(authCredential);
        // TODO: Kiem tra xem user moi hay cu
        if (userInfo.isFirstLogin) {
          // Navigate to sign up screen
          await Get.offAllNamed(RouteHandler.SIGN_UP);
        } else {
          await Get.offAllNamed(RouteHandler.NAV);
          // chuyen sang trang home
        }
      } catch (e) {
        await showStatusDialog(
            Icon(
              Icons.error_outline,
              color: kFail,
            ),
            "Lỗi khi đăng nhập",
            e.toString());
      } finally {
        hideDialog();
      }
      // dem authuser cho controller xu ly check user
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) async {
      print(
          "===== Dang nhap fail: ${authException.toString()} ${authException.message}");
      await showStatusDialog(
          Icon(
            Icons.error_outline,
            color: kFail,
          ),
          "Nhập sai OTP",
          authException.message);
    };

    final PhoneCodeSent phoneCodeSent =
        (String verId, [int forceResend]) async {
      await Get.toNamed(RouteHandler.LOGIN_OTP,
          arguments: {"verId": verId, "phoneNumber": phone});
    };

    final PhoneCodeAutoRetrievalTimeout phoneTimeout = (String verId) {
      verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 10),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: phoneTimeout,
    );
    print("Login Done");
  }

  Future<void> onSignInWithGmail() async {
    try {
      final authCredential = await AuthService().signInWithGoogle();
      if (authCredential == null) return;

      showLoadingDialog();
      return Get.offAllNamed(RouteHandler.NAV);
    } on FirebaseAuthException catch (e) {
      print("=====OTP Fail: ${e.message}  ");
      await await showStatusDialog(
          Icon(
            Icons.error_outline,
            color: kFail,
          ),
          "Error",
          e.message);
    } finally {
      hideDialog();
    }
  }

  Future<void> onsignInWithOTP(smsCode, verificationId) async {
    print("DN = OTP");
    showLoadingDialog();
    try {
      final authCredential =
          await AuthService().signInWithOTP(smsCode, verificationId);
      final userInfo = await signIn(authCredential);

      print("User info: " + userInfo.toString());

      if (userInfo.isFirstLogin) {
        // Navigate to sign up screen
        await Get.offAndToNamed(RouteHandler.SIGN_UP);
      } else {
        Get.rawSnackbar(
            message: "Đăng nhập thành công!!",
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 32),
            borderRadius: 8);
        await Get.offAllNamed(RouteHandler.NAV);
      }
    } on FirebaseAuthException catch (e) {
      print("Error: " + e.toString());
      print("=====OTP Fail: ${e.message}  ");
      await showStatusDialog(
          Icon(
            Icons.error_outline,
            color: kFail,
          ),
          "Error",
          e.message);
    } catch (e, strack) {
      print("Error: " + e.toString() + strack.toString());
      await showStatusDialog(
          Icon(
            Icons.error_outline,
            color: kFail,
          ),
          "Error",
          e.toString());
    } finally {
      hideDialog();
    }
  }
}
