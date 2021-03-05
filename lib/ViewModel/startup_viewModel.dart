import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/route_constraint.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

class StartUpViewModel extends BaseModel {
  static StartUpViewModel _instance;

  static StartUpViewModel getInstance() {
    if (_instance == null) {
      _instance = StartUpViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  StartUpViewModel() {
    handleStartUpLogic();
  }

  Future handleStartUpLogic() async {
    AccountDAO _accountDAO = AccountDAO();
    await Future.delayed(Duration(seconds: 3));
    var hasLoggedInUser = await _accountDAO.isUserLoggedIn();
    bool isFirstOnBoard = await getIsFirstOnboard() ?? true;

    if (isFirstOnBoard) {
      Get.offAndToNamed(RouteHandler.ONBOARD);
    } else if (hasLoggedInUser) {
      Get.offAndToNamed(RouteHandler.NAV);
    } else {
      Get.offAndToNamed(RouteHandler.LOGIN);
    }
  }
}
