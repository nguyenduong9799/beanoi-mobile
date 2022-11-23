import 'package:dio/dio.dart';
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
  List<VoucherDTO> vouchers;
  PromotionDAO promoDao;

  AccountDAO _dao;
  AccountDTO currentUser;
  String version;
  List<bool> selections = [true, false];

  AccountViewModel() {
    _dao = AccountDAO();
    promoDao = new PromotionDAO();
  }

  Future<void> fetchUser({bool isRefetch = false}) async {
    try {
      if (isRefetch) {
        setState(ViewStatus.Refreshing);
      } else if (status != ViewStatus.Loading) {
        setState(ViewStatus.Loading);
      }

      final user = await _dao.getUser();
      currentUser = user;

      String token = await getToken();
      print(token.toString());

      if (version == null && isSmartPhoneDevice()) {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        version = packageInfo.version;
      }
      getVouchers();
      setState(ViewStatus.Completed);
    } catch (e, stacktrace) {
      print(e.toString() + stacktrace.toString());
      bool result = await showErrorDialog();
      if (result) {
        await fetchUser();
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> changeStatus(int index) async {
    selections = selections.map((e) => false).toList();
    selections[index] = true;
    notifyListeners();
    await getVouchers();
  }

  Future<void> getVouchers() async {
    setState(ViewStatus.Loading);
    if (selections[0] == true) {
      final voucherList = await promoDao.getPromotions();
      vouchers = voucherList;
    }
    setState(ViewStatus.Completed);
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
      bool result = await showErrorDialog(
          errorTitle: (e as DioError).response.data['error']['message']);
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
