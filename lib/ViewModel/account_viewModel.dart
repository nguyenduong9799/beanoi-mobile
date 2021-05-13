import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'index.dart';

class AccountViewModel extends BaseModel {
  AccountDAO _dao;
  AccountDTO currentUser;
  static AccountViewModel _instance;
  String version;

  AccountViewModel() {
    _dao = AccountDAO();
  }

  Future<void> fetchUser() async {
    try {
      if (status != ViewStatus.Loading) {
        setState(ViewStatus.Loading);
      }
      final user = await _dao.getUser();
      currentUser = user;

      String token = await getToken();
      print(token.toString());

      if (version == null) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        version = packageInfo.version;
      }

      setState(ViewStatus.Completed);
    } catch (e, stacktrace) {
      bool result = await showErrorDialog();
      if (result) {
        await fetchUser();
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> showRefferalMessage() async {
    try {
      String refferalCode =
          await inputDialog("Nhập mã giới thiệu 🤩", "Xác nhận", maxLines: 1);
      if (refferalCode != null && refferalCode.isNotEmpty) {
        showLoadingDialog();
        String message = await _dao.getRefferalMessage(refferalCode);
        await showStatusDialog("assets/images/option.png", "", message);
      }
    } catch (e, stacktrace) {
      print(e.toString() + stacktrace.toString());
      bool result = await showErrorDialog();
      if (result) {
        await showRefferalMessage();
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> sendFeedback(
      [String title = "Bạn cho mình xin góp ý nha 🤗"]) async {
    try {
      String feedback = await inputDialog(title, "Gửi thôi 💛");
      if (feedback != null && feedback.isNotEmpty) {
        showLoadingDialog();
        await _dao.sendFeedback(feedback);
        await showStatusDialog("assets/images/option.png", "Cảm ơn bạn",
            "Góp ý của bạn sẽ giúp tụi mình cải thiện app tốt hơn 😊");
      }
    } catch (e, stacktrace) {
      print(e.toString() + stacktrace.toString());
      bool result = await showErrorDialog();
      if (result) {
        await showRefferalMessage();
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> processSignout() async {
    int option = await showOptionDialog("Mình sẽ nhớ bạn lắm ó huhu :'(((");
    if (option == 1) {
      await _dao.logOut();
      await removeALL();
      Get.offAllNamed(RouteHandler.LOGIN);
    }
  }
}
