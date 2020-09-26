import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DAO/AccountDAO.dart';

class RootViewModel extends Model {
  AccountDAO _dao;

  RootViewModel() {
    _dao = AccountDAO();
  }

  void fetchUser() {}
}
