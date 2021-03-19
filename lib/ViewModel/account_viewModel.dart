import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';
import '../route_constraint.dart';
import 'index.dart';

class AccountViewModel extends BaseModel {
  AccountDAO _dao;
  AccountDTO currentUser;
  static AccountViewModel _instance;
  String version;

  static AccountViewModel getInstance() {
    if (_instance == null) {
      _instance = AccountViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  AccountViewModel() {
    _dao = AccountDAO();
    fetchUser();
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
      String refferalCode = await inputDialog("Nhập mã giới thiệu 🤩", "Xác nhận");
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

  Future<void> processSignout() async {
    int option = await showOptionDialog("Mình sẽ nhớ bạn lắm ó huhu :'(((");
    if (option == 1) {
      await _dao.logOut();
      await removeALL();
      destroyInstance();
      HomeViewModel.destroyInstance();
      GiftViewModel.getInstance();
      RootViewModel.destroyInstance();
      Get.offAllNamed(RouteHandler.LOGIN);
    }
  }
}
