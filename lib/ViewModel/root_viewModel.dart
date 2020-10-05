import 'package:get/get.dart';

import 'package:unidelivery_mobile/Model/DAO/AccountDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';

import '../route_constraint.dart';

class RootViewModel extends BaseModel {
  AccountDAO _dao;
  AccountDTO currentUser;
  String error;

  RootViewModel() {
    _dao = AccountDAO();
    setState(ViewStatus.Loading);
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      setState(ViewStatus.Loading);
      final user = await _dao.getUser();
      currentUser = user;
      setState(ViewStatus.Completed);
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await fetchUser();
      } else
        setState(ViewStatus.Error);
    } finally {}
  }

  Future<void> signOut() async {
    await _dao.logOut();
  }

  Future<void> processSignout() async {
    int option = await showOptionDialog("Bạn có chắc không");
    if (option == 1) {
      await signOut();
      Get.offAllNamed(RouteHandler.LOGIN);
    }
  }
}
