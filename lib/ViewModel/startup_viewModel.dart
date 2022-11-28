import 'package:get/get.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

import 'index.dart';

class StartUpViewModel extends BaseModel {
  StartUpViewModel() {
    handleStartUpLogic();
  }
  Future handleStartUpLogic() async {
    AccountDAO _accountDAO = AccountDAO();
    await Future.delayed(Duration(seconds: 3));
    bool isFirstOnBoard = await getIsFirstOnboard() ?? true;
    bool hasLoggedInUser = await _accountDAO.isUserLoggedIn();
    CampusDTO currentStore = await getStore();

    if (isFirstOnBoard) {
      Get.offAndToNamed(RouteHandler.ONBOARD);
    } else if (hasLoggedInUser) {
      // await Get.find<RootViewModel>().startUp();
      // Get.offAndToNamed(RouteHandler.NAV);
      Get.offAndToNamed(RouteHandler.SELECT_STORE);
    } else {
      Get.offAndToNamed(RouteHandler.LOGIN);
    }
  }
}
