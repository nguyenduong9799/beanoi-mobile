import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/View/home.dart';
import 'package:unidelivery_mobile/ViewModel/login_viewModel.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/countries.dart';
import 'package:unidelivery_mobile/services/firebase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = new GlobalKey<FormState>();
  FocusNode phoneNbFocus;

  String phoneNb = "+84123456789", smsCode = "123456";
  bool smsSent = false;
  String verificationId, countryCode = "+84";
  FocusNode smsCodeFocus = FocusNode();
  ProgressDialog pr;
  List<DropdownMenuItem<dynamic>> _dropdownMenuItems;

  // double formWidth = 300;
  double formHeight = 180;

  @override
  void initState() {
    super.initState();
    phoneNbFocus = FocusNode();
    pr = new ProgressDialog(
      context,
      showLogs: true,
      type: ProgressDialogType.Download,
      isDismissible: false,
    );

    _dropdownMenuItems = countries
        .map(
          (country) => DropdownMenuItem(
            child: Text(
              "${country["code"]} (${country["dial_code"]})",
              style: kTextPrimary.copyWith(color: Colors.black, fontSize: 12),
            ),
            value: country["dial_code"],
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneNbFocus.dispose();
    // await pr.hide();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final formWidth = screenWidth - 30 - 60;
    return ScopedModel(
      model: LoginViewModel(),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.blueGrey,
                    child: Image.asset('assets/images/bi.png'),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.orangeAccent,
                    width: screenWidth,
                    height: screenHeight * 0.55,
                    child: Stack(
                      children: [
                        Container(
                          child: ScopedModelDescendant<LoginViewModel>(
                            builder: (BuildContext context, Widget child,
                                    LoginViewModel model) =>
                                _buildLoginForm(model),
                          ),
                        )
                      ],
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

  Widget _buildLoginForm(LoginViewModel model) {
    final user = model.user;

    Future<void> _handleLogin() async {
      if (!_formKey.currentState.validate()) return;
      await pr.show();
      smsSent
          ? await onsignInWithOTP(smsCode, verificationId, model)
          : await onLoginWithPhone(phoneNb, model);
      await pr.hide();
    }

    return Container(
      height: formHeight,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Align(
                  // alignment: Alignment.center,
                  child: Theme(
                    data: ThemeData(
                      primaryColor: Color(0xFF45822b),
                      accentColor: Colors.orange,
                      hintColor: Colors.white70,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30 - 60 - 35,
                      padding: EdgeInsets.only(top: 25),
                      // height: 70,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          !smsSent
                              ? Row(
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                            value: countryCode,
                                            items: _dropdownMenuItems,
                                            onChanged: (value) => setState(() {
                                                  countryCode = value;
                                                })),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Flexible(
                                      flex: 3,
                                      child: TextFormField(
                                        keyboardType: TextInputType.phone,
                                        style: kTextPrimary,
                                        focusNode: phoneNbFocus,
                                        // autofocus: true,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Bạn chưa nhập SDT kìa :(';
                                          }
                                          return null;
                                        },
                                        // autofocus: true,
                                        decoration: InputDecoration(
                                          hintText:
                                              "Nhập số điện thoại của bạn đi!",
                                        ),
                                        // initialValue: phoneNb,
                                        onChanged: (val) => setState(() {
                                          this.phoneNb = val;
                                        }),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          smsSent
                              ? TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: kTextPrimary,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      hintText: "Vui lòng nhập mã OTP"),
                                  initialValue: smsCode,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Bạn chưa điền kìa :(';
                                    }
                                    return null;
                                  },
                                  onChanged: (val) => setState(() {
                                    this.smsCode = val;
                                  }),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              IconButton(
                icon: Icon(Icons.accessibility_new),
                onPressed: () async {
                  await onSignInWithGmail(model);
                },
              ),

              // LOGIN BUTTON
              Container(
                width: MediaQuery.of(context).size.width - 30 - 60,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF438029),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      await _handleLogin();
                    },
                    child: Center(
                      child: smsSent
                          ? Text("Xác nhận",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20))
                          : Text(
                              "Đăng nhập",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // BACK BUTTON
          smsSent
              ? Positioned(
                  left: 15,
                  top: -10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        smsSent = false;
                        phoneNb = null;
                        verificationId = null;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            smsSent = false;
                            phoneNb = null;
                            verificationId = null;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                            ),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                smsSent = false;
                                phoneNb = null;
                                verificationId = null;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ))
              : Container(),
        ],
      ),
    );
  }

  Future<void> onSignInWithGmail(LoginViewModel model) async {
    try {
      final authCredential = await AuthService().signInWithGoogle();
      if (authCredential == null) return;
      final userInfo = await model.signIn(authCredential);

      await pr.hide();
      return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen(user: userInfo)),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      print("=====OTP Fail: ${e.message}  ");
      await _showMyDialog("Error", e.message);
    } finally {
      await pr.hide();
    }
  }

  Future<void> onsignInWithOTP(
      smsCode, verificationId, LoginViewModel model) async {
    print("DN = OTP");
    await pr.show();
    try {
      final authCredential =
          await AuthService().signInWithOTP(smsCode, verificationId);
      final userInfo = await model.signIn(authCredential);

      await pr.hide();
      return Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen(user: userInfo)),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      print("=====OTP Fail: ${e.message}  ");
      await _showMyDialog("Error", e.message);
    } finally {
      await pr.hide();
    }
  }

  Future<void> onLoginWithPhone(String phone, LoginViewModel model) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) async {
      await pr.show();
      // dem authuser cho controller xu ly check user
      final userInfo = await model.signIn(authCredential);
      // chuyen sang trang home

      // TODO: Kiem tra xem user moi hay cu
      await pr.hide();

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen(user: userInfo)),
          (route) => false);
      print("Login Success");
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print("===== Dang nhap fail: ${authException.message}");
      _showMyDialog("Error", authException.message);
    };

    final PhoneCodeSent phoneCodeSent = (String verId, [int forceResend]) {
      setState(() {
        this.verificationId = verId;
        smsSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout phoneTimeout = (String verId) {
      setState(() {
        this.verificationId = verId;
      });
    };

    await pr.show();
    print(countryCode + phone);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: countryCode + phone,
      timeout: Duration(seconds: 50),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: phoneTimeout,
    );
    print("Login Done");
    await pr.hide();
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
}
