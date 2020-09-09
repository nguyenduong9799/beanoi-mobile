import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:unidelivery_mobile/screens/home.dart';
import 'package:unidelivery_mobile/screens/login.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  handleAuth() {
    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) =>
          snapshot.hasData ? HomeScreen(user: snapshot.data) : LoginScreen(),
    );
  }

  signIn(AuthCredential authCredential) async {
    UserCredential userCredential =
        await auth.signInWithCredential(authCredential);
    // check from server whether has info that user
    getUserFromServer(userCredential.user.uid);
  }

  signOut() {
    auth.signOut();
  }

  signInWithOTP(String smsCode, String verId) {
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    this.signIn(authCredential);
  }

  // TODO: Implement this
  getUserFromServer(String uid) {}
}
