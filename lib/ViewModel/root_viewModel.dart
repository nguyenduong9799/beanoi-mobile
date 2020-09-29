import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DAO/AccountDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';

class RootViewModel extends Model {
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
}
