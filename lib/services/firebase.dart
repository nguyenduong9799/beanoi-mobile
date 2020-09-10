import 'package:firebase_auth/firebase_auth.dart';
import 'package:unidelivery_mobile/Model/DAO/AccountDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  AccountDAO dao = AccountDAO();

  Future<UserCredential> signIn(AuthCredential authCredential) async {
    UserCredential userCredential =
        await auth.signInWithCredential(authCredential);
    print(await userCredential.user.getIdToken());
    return userCredential;
  }

  signOut() {
    // remove pref
    auth.signOut();
  }

  Future<AuthCredential> signInWithOTP(String smsCode, String verId) async {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    return authCredential;
  }
}
