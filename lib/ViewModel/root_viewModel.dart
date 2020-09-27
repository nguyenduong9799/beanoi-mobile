import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DAO/AccountDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/utils/enum.dart';

class RootViewModel extends Model {
  AccountDAO _dao;
  AccountDTO currentUser;
  Status status;
  String error;

  RootViewModel() {
    _dao = AccountDAO();
    status = Status.Loading;
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      status = Status.Loading;
      notifyListeners();
      final user = await _dao.getUser();
      currentUser = user;
      status = Status.Completed;
      notifyListeners();
    } catch (e) {
      status = Status.Error;
      error = e.toString();
      notifyListeners();
    } finally {}
  }

  Future<void> signOut() async {
    await _dao.logOut();
  }
}
