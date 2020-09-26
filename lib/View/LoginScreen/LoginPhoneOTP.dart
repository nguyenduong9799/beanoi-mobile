import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Services/firebase.dart';
import 'package:unidelivery_mobile/View/home.dart';
import 'package:unidelivery_mobile/View/nav_screen.dart';
import 'package:unidelivery_mobile/View/signup.dart';
import 'package:unidelivery_mobile/ViewModel/login_viewModel.dart';
import 'package:unidelivery_mobile/constraints.dart';

class LoginWithPhoneOTP extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  LoginWithPhoneOTP({Key key, this.verificationId, this.phoneNumber})
      : super(key: key);

  @override
  _LoginWithPhoneOTPState createState() => _LoginWithPhoneOTPState();
}

class _LoginWithPhoneOTPState extends State<LoginWithPhoneOTP> {
  ProgressDialog pr;
  StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final form = FormGroup({
    'otp': FormControl(validators: [
      Validators.required,
      // Validators.number,
    ], touched: false),
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    pr = new ProgressDialog(
      context,
      showLogs: true,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: ScopedModel<LoginViewModel>(
        model: LoginViewModel(),
        child: Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(2, 2), // changes position of shadow
                      ),
                    ]),
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Container(
            child: Stack(
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Container(
                  // color: Colors.blue,
                  padding: EdgeInsets.all(0),
                  child: Image.asset(
                    'assets/images/bi_password.png',
                    alignment: Alignment.bottomRight,
                    fit: BoxFit.fitHeight,
                    // scale: 0.4,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(48, 24, 48, 16),
                    height: screenHeight * 0.55,
                    width: screenWidth,
                    child: ScopedModelDescendant<LoginViewModel>(
                      builder:
                          (BuildContext context, Widget child, Model model) {
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Vui lòng xác nhận mã OTP',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 8),
                              child: RichText(
                                text: TextSpan(
                                    text: "Nhập code được gửi tới số\n",
                                    children: [
                                      TextSpan(
                                          text: widget.phoneNumber,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ],
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 15)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            _buildOTPForm(context),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text(
                                hasError ? "Bạn chưa nhập đủ mã OTP :(." : "",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: "Chưa nhận được code?",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 15),
                                  children: [
                                    TextSpan(
                                      text: " Gửi lại",
                                      // recognizer: onTapRecognizer,
                                      style: TextStyle(
                                          color: Colors.blue[800],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )
                                  ]),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            ButtonTheme(
                              minWidth: 150.0,
                              height: 48,
                              child: RaisedButton(
                                color: Colors.white,
                                padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  // side: BorderSide(color: Colors.red),
                                ),
                                onPressed: () async {
                                  form.touch();
                                  if (!form.valid) {
                                    errorController.add(ErrorAnimationType
                                        .shake); // Triggering error shake animation
                                    setState(() {
                                      hasError = true;
                                    });
                                  } else {
                                    await onsignInWithOTP(form.value["otp"],
                                        widget.verificationId, model);
                                  }
                                },
                                child: Center(
                                    child: Text(
                                  "Xác nhận".toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onsignInWithOTP(
      smsCode, verificationId, LoginViewModel model) async {
    print("DN = OTP");
    await pr.show();
    try {
      if (smsCode.length != 6) {
        errorController
            .add(ErrorAnimationType.shake); // Triggering error shake animation
        setState(() {
          hasError = true;
        });
      } else {
        final authCredential =
            await AuthService().signInWithOTP(smsCode, verificationId);
        final userInfo = await model.signIn(authCredential);

        if (userInfo.isFirstLogin) {
          // Navigate to sign up screen
          await Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => SignUp(
                  user: userInfo,
                ),
              ),
              (route) => false);
        } else {
          setState(() {
            hasError = false;
          });
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Đăng nhập thành công!!"),
            duration: Duration(seconds: 3),
          ));
          await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => RootScreen()),
              (route) => false);
        }
      }
    } on FirebaseAuthException catch (e) {
      print("=====OTP Fail: ${e.message}  ");
      await _showMyDialog("Error", e.message);
    } catch (e) {
      await _showMyDialog("Error", e.toString());
    } finally {
      await pr.hide();
    }
  }

  Future<void> _showMyDialog(String title, String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('$content'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildOTPForm(BuildContext context) {
    return PinCodeTextField(
      length: 6,
      animationType: AnimationType.fade,
      obscureText: false,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        inactiveColor: Colors.grey,
        selectedFillColor: Colors.white,
        inactiveFillColor: kBackgroundGrey[3],
        activeFillColor: Colors.white,
        activeColor: Colors.grey,
        selectedColor: Colors.grey,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
      ),
      animationDuration: Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      errorAnimationController: errorController,
      onCompleted: (v) {
        print("Completed");
      },
      onChanged: (value) {
        print(value);
        form.control('otp').value = value;
      },
      validator: (v) {
        if (v.length < 3) {
          return "I'm from validator";
        } else {
          return null;
        }
      },
      appContext: context,
    );
  }
}
