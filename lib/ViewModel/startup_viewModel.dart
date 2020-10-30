import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/route_constraint.dart';

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
    // Register for push notifications
    // await _pushNotificationService.initialise();
    await Future.delayed(Duration(seconds: 5));
    var hasLoggedInUser = await _accountDAO.isUserLoggedIn();
    bool isFirstOnBoard = true;

    if (isFirstOnBoard) {
      Get.offAndToNamed(RouteHandler.ONBOARD);
    } else if (hasLoggedInUser) {
      Get.offAndToNamed(RouteHandler.NAV);
    } else {
      Get.offAndToNamed(RouteHandler.LOGIN);
    }
  }
}
