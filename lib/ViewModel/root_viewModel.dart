import 'package:scoped_model/scoped_model.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:unidelivery_mobile/Model/DAO/AccountDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';

import '../locator.dart';
import '../route_constraint.dart';

class RootViewModel extends Model {
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  AccountDAO _dao;
  AccountDTO currentUser;
  ViewStatus status;
  String error;

  RootViewModel() {
    _dao = AccountDAO();
    status = ViewStatus.Loading;
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      status = ViewStatus.Loading;
      notifyListeners();
      final user = await _dao.getUser();
      currentUser = user;
      status = ViewStatus.Completed;
      notifyListeners();
    } catch (e) {
      status = ViewStatus.Error;
      error = e.toString();
      notifyListeners();
    } finally {}
  }

  Future<void> signOut() async {
    await _dao.logOut();
  }

  Future<void> processSignout() async {
    DialogResponse option = await _dialogService.showConfirmationDialog(
        barrierDismissible: false,
        cancelTitle: "Không",
        confirmationTitle: "Có",
        description: "Bạn có chắc không?");
    if (option.confirmed) {
      await signOut();
      _navigationService.clearStackAndShow(RouteHandler.LOGIN);
    }
  }
}
