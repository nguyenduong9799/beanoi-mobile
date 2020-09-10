import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DAO/AccountDAO.dart';
import 'package:unidelivery_mobile/View/home.dart';
import 'package:unidelivery_mobile/View/order.dart';
import 'package:unidelivery_mobile/ViewModel/login_viewModel.dart';
import 'package:unidelivery_mobile/services/firebase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = new GlobalKey<FormState>();

  String phoneNb = "+84123456789", smsCode = "123456";
  bool smsSent = false;
  String verificationId;
  FocusNode smsCodeFocus = FocusNode();
  ProgressDialog pr;
  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(
      context,
      showLogs: true,
      type: ProgressDialogType.Download,
      isDismissible: false,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // await pr.hide();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: LoginViewModel(),
      child: SafeArea(
        child: Scaffold(
          body: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: ScopedModelDescendant<LoginViewModel>(
                builder: (BuildContext context, Widget child,
                        LoginViewModel model) =>
                    _buildLoginForm(model),
              ),
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
      smsSent
          ? await onsignInWithOTP(smsCode, verificationId, model)
          : await onLoginWithPhone(phoneNb, model);
    }

    return Center(
      child: Container(
        height: 200,
        margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
        decoration: BoxDecoration(
          color: Color(0xFF619a46),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.center,
          overflow: Overflow.visible,
          children: [
            SizedBox(height: 70),
            Center(
              child: Theme(
                data: ThemeData(
                  primaryColor: Color(0xFF45822b),
                  accentColor: Colors.orange,
                  hintColor: Colors.white70,
                ),
                child: Container(
                  width: 300,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 700),
                        curve: Curves.easeIn,
                        left: smsSent ? -300 : 0,
                        top: 10,
                        child: Container(
                          width: 300,
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            style: TextStyle(color: Colors.white),
                            autofocus: true,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Vui lòng nhập số điện thoại';
                              }
                              return null;
                            },
                            // autofocus: true,
                            decoration: InputDecoration(
                              hintText: "Nhập số điện thoại của bạn đi",
                            ),
                            // initialValue: phoneNb,
                            onChanged: (val) => setState(() {
                              this.phoneNb = val;
                            }),
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.easeIn,
                        left: smsSent ? 0 : 300,
                        top: 10,
                        child: Container(
                          width: 300,
                          child: true
                              ? TextFormField(
                                  keyboardType: TextInputType.number,
                                  autofocus: true,
                                  decoration:
                                      InputDecoration(hintText: "Nhập mã OTP"),
                                  initialValue: smsCode,
                                  onChanged: (val) => setState(() {
                                    this.smsCode = val;
                                  }),
                                )
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // AnimatedPositioned(
            //   duration: Duration(seconds: 1),
            //   curve: Curves.easeIn,
            //   left: smsSent ? -400 : 15,
            //   top: 10,
            //   child: Container(
            //     width: 200,
            //     height: 50,
            //     child: TextFormField(
            //       keyboardType: TextInputType.phone,
            //       style: TextStyle(color: Colors.white),
            //       autofocus: true,
            //       validator: (value) {
            //         if (value.isEmpty) {
            //           return 'Vui lòng nhập số điện thoại';
            //         }
            //         return null;
            //       },
            //       // autofocus: true,
            //       decoration: InputDecoration(
            //         hintText: "Nhập số điện thoại của bạn đi",
            //       ),
            //       // initialValue: phoneNb,
            //       onChanged: (val) => setState(() {
            //         this.phoneNb = val;
            //       }),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(15),
            //   child: Theme(
            //     data: new ThemeData(
            //       primaryColor: Color(0xFF45822b),
            //       accentColor: Colors.orange,
            //       hintColor: Colors.white70,
            //     ),
            //     child: Column(
            //       children: [
            //         SizedBox(height: 20),
            //         // !smsSent
            //         //     ? TextFormField(
            //         //         keyboardType: TextInputType.phone,
            //         //         style: TextStyle(color: Colors.white),
            //         //         autofocus: true,
            //         //         validator: (value) {
            //         //           if (value.isEmpty) {
            //         //             return 'Vui lòng nhập số điện thoại';
            //         //           }
            //         //           return null;
            //         //         },
            //         //         // autofocus: true,
            //         //         decoration: InputDecoration(
            //         //           hintText: "Nhập số điện thoại của bạn đi",
            //         //         ),
            //         //         // initialValue: phoneNb,
            //         //         onChanged: (val) => setState(() {
            //         //           this.phoneNb = val;
            //         //         }),
            //         //       )
            //         //     : Container(),
            //         smsSent
            //             ? TextFormField(
            //                 keyboardType: TextInputType.number,
            //                 autofocus: true,
            //                 decoration:
            //                     InputDecoration(hintText: "Nhập mã OTP"),
            //                 initialValue: smsCode,
            //                 onChanged: (val) => setState(() {
            //                   this.smsCode = val;
            //                 }),
            //               )
            //             : Container(),
            //       ],
            //     ),
            //   ),
            // ),

            // LOGIN BUTTON
            Positioned(
              left: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderScreen(),));
                  //await _handleLogin();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF438029),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: smsSent
                        ? Text(
                            "Verify",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        : Text(
                            "Đăng nhập",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                  ),
                ),
              ),
            ),

            smsSent
                ? Positioned(
                    left: 15,
                    top: -25,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          smsSent = false;
                          phoneNb = null;
                          verificationId = null;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
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
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> onsignInWithOTP(
      smsCode, verificationId, LoginViewModel model) async {
    print("DN = OTP");
    await pr.show();
    try {
      final authCredential =
          await AuthService().signInWithOTP(smsCode, verificationId);
      final userInfo = await model.signInByPhone(authCredential);

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
      final userInfo = await model.signInByPhone(authCredential);
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
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
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
