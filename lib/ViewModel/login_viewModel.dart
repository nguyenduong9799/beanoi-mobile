import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Services/analytic_service.dart';
import 'package:unidelivery_mobile/Services/firebase_authentication_service.dart';
import 'package:unidelivery_mobile/Services/push_notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'index.dart';

class LoginViewModel extends BaseModel {
  AccountDAO dao = AccountDAO();
  String verificationId;
  AnalyticsService _analyticsService;

  AccountDTO user;

  LoginViewModel() {
    _analyticsService = AnalyticsService.getInstance();
  }

  Future<AccountDTO> signIn(UserCredential userCredential,
      [String method = "phone"]) async {
    try {
      // lay thong tin user tu firebase

      await _analyticsService.logLogin(method);
      // TODO: Thay uid = idToken
      String token = await userCredential.user.getIdToken();
      final userInfo = await dao.login(token);
      await PushNotificationService.getInstance().init();

      await _analyticsService.setUserProperties(userInfo);
      return userInfo;
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await signIn(userCredential);
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> onLoginWithPhone(String phone) async {
    Get.toNamed(RouteHandler.LOADING);
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) async {
      try {
        showLoadingDialog();
        final userCredential = await AuthService().signIn(authCredential);
        final userInfo = await signIn(userCredential);
        hideDialog();
        // TODO: Kiem tra xem user moi hay cu
        if (userInfo.isFirstLogin) {
          // Navigate to sign up screen
          await Get.offAllNamed(RouteHandler.SIGN_UP, arguments: userInfo);
        } else {
          await Get.offAllNamed(RouteHandler.NAV);
          // chuyen sang trang home
        }
      } catch (e) {
        await showStatusDialog("assets/images/global_error.png",
            "Lỗi khi đăng nhập", e.toString());
        Get.back();
      }
      // dem authuser cho controller xu ly check user
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) async {
      await showStatusDialog("assets/images/global_error.png", "Xảy ra lỗi",
          authException.message);
      Get.back();
    };

    final PhoneCodeSent phoneCodeSent =
        (String verId, [int forceResend]) async {
      await Get.offNamed(RouteHandler.LOGIN_OTP,
          arguments: {"verId": verId, "phoneNumber": phone});
    };

    final PhoneCodeAutoRetrievalTimeout phoneTimeout = (String verId) {
      verificationId = verId;
    };
    if (isSmartPhoneDevice()) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 30),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: phoneCodeSent,
        codeAutoRetrievalTimeout: phoneTimeout,
      );
    } else {
      final confirmationResult =
          await FirebaseAuth.instance.signInWithPhoneNumber(phone);
      await Get.offNamed(RouteHandler.LOGIN_OTP, arguments: {
        "confirmationResult": confirmationResult,
        "phoneNumber": phone
      });
    }
  }

  Future<void> onSignInWithGmail() async {
    try {
      final authCredential = await AuthService().signInWithGoogle();
      if (authCredential == null) return;

      showLoadingDialog();
      return Get.offAllNamed(RouteHandler.NAV);
    } on FirebaseAuthException catch (e) {
      await showStatusDialog(
          "assets/images/global_error.png", "Error", e.message);
    } finally {
      hideDialog();
    }
  }

  Future<void> onsignInWithOTP(smsCode, verificationId) async {
    showLoadingDialog();

    try {
      final authCredential =
          await AuthService().signInWithOTP(smsCode, verificationId);
      final userCredential = await AuthService().signIn(authCredential);
      final userInfo = await signIn(userCredential);

      if (userInfo.isFirstLogin || userInfo.isFirstLogin == null) {
        // Navigate to sign up screen
        await Get.offAndToNamed(RouteHandler.SIGN_UP, arguments: userInfo);
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
      await showStatusDialog(
          "assets/images/global_error.png", "Error", e.message);
    } catch (e) {
      await showStatusDialog(
          "assets/images/global_error.png", "Error", e.toString());
    } finally {
      hideDialog();
    }
  }

  Future<void> onsignInWithOTPForWeb(
      smsCode, ConfirmationResult confirmationResult) async {
    showLoadingDialog();

    try {
      final userCredential =
          await AuthService().signInWithOTPForWeb(smsCode, confirmationResult);
      final userInfo = await signIn(userCredential);
      if (userInfo.isFirstLogin || userInfo.isFirstLogin == null) {
        // Navigate to sign up screen
        await Get.offAndToNamed(RouteHandler.SIGN_UP, arguments: userInfo);
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
      await showStatusDialog(
          "assets/images/global_error.png", "Error", e.message);
    } catch (e) {
      await showStatusDialog(
          "assets/images/global_error.png", "Error", e.toString());
    } finally {
      hideDialog();
    }
  }
}
