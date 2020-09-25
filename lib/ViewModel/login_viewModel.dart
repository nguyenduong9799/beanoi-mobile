import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Services/firebase.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

class LoginViewModel extends Model {
  static LoginViewModel _instance;
  AccountDAO dao = AccountDAO();

  static LoginViewModel getInstance() {
    if (_instance == null) {
      _instance = LoginViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  bool isLoading = false;
  String text;

  AccountDTO user;

  LoginViewModel() {}

  Future<AccountDTO> signIn(AuthCredential authCredential) async {
    // lay thong tin user tu firebase
    final userCredential = await AuthService().signIn(authCredential);
    // lay thong tin user tu sereer
    // TODO: Thay uid = idToken
    final userInfo = await dao.getUser(await userCredential.user.getIdToken());
    // await setToken(userInfo.toString());
    return userInfo;
  }

  Future<void> signOut() async {
    await AuthService().signOut();
    await setToken(null);
  }

  Future<AccountDTO> changeEventLogin(String uid) async {
    isLoading = true;
    text = "";
    notifyListeners();
    try {
      AccountDTO dto = await dao.getUser(uid);
      return dto;
    } on Exception {
      text = "An error has ocured. Please try app later!";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
