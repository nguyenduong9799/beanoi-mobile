import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/services/firebase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = new GlobalKey<FormState>();

  bool smsSent = false;
  String phoneNb, verificationId, smsCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Center(
            child: Text("Login screen"),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: "Enter your number"),
                onChanged: (val) => setState(() {
                  this.phoneNb = val;
                }),
              ),
              smsSent
                  ? TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(hintText: "Enter your OTP"),
                      onChanged: (val) => setState(() {
                        this.smsCode = val;
                      }),
                    )
                  : Container(),
              RaisedButton(
                onPressed: () {
                  smsSent
                      ? AuthService().signInWithOTP(smsCode, verificationId)
                      : onLoginWithPhone(phoneNb);
                },
                child: smsSent ? Text("Verify") : Text("Login"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onLoginWithPhone(String phone) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) {
      print("Login Success");
      AuthService().signIn(authCredential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print("${authException.message}");
    };

    final PhoneCodeSent phoneCodeSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        smsSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout phoneTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: phoneTimeout,
    );
  }
}
