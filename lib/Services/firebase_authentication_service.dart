import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unidelivery_mobile/Model/DAO/AccountDAO.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  AccountDAO dao = AccountDAO();

  Future<UserCredential> signIn(AuthCredential authCredential) async {
    UserCredential userCredential =
        await auth.signInWithCredential(authCredential);
    return userCredential;
  }

  signOut() async {
    // remove pref
    await auth.signOut();
  }

  // final request = MyRequest();

  Future<AuthCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return credential;
    } catch (err) {
      throw (err);
    }
  }

  Future<AuthCredential> signInWithOTP(String smsCode, String verId) async {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    return authCredential;
  }

  Future<UserCredential> signInWithOTPForWeb(
      String smsCode, ConfirmationResult confirmationResult) async {
    UserCredential userCredential = await confirmationResult.confirm(smsCode);
    return userCredential;
  }
}
