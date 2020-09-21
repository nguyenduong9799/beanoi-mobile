import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Services/firebase.dart';
import 'package:unidelivery_mobile/View/LoginScreen/LoginPhoneOTP.dart';
import 'package:unidelivery_mobile/View/home.dart';
import 'package:unidelivery_mobile/View/signup.dart';
import 'package:unidelivery_mobile/ViewModel/login_viewModel.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/countries.dart';
import 'package:unidelivery_mobile/utils/regex.dart';

class LoginWithPhone extends StatefulWidget {
  LoginWithPhone({Key key}) : super(key: key);

  @override
  _LoginWithPhoneState createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  List<DropdownMenuItem<dynamic>> _dropdownMenuItems;
  String verificationId;
  bool smsSent = false;
  String smsCode;

  ProgressDialog pr;

  final form = FormGroup({
    'phone': FormControl(validators: [
      Validators.required,
      // Validators.pattern(phoneReg),
      // Validators.number,
    ], touched: false),
    'countryCode': FormControl(validators: [
      Validators.required,
      // Validators.pattern(phoneReg),
      // Validators.number,
    ], touched: false, value: "+84"),
  });

  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(
      context,
      showLogs: true,
      type: ProgressDialogType.Download,
      isDismissible: false,
    );

    _dropdownMenuItems = countries
        .map(
          (country) => DropdownMenuItem(
            child: SizedBox(
              width: 72,
              child: Text(
                "${country["code"]} (${country["dial_code"]})",
                textAlign: TextAlign.center,
                style: kTextPrimary.copyWith(color: Colors.black, fontSize: 12),
              ),
            ),
            value: country["dial_code"],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
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
              ],
            ),
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ScopedModel<LoginViewModel>(
        model: LoginViewModel(),
        child: ReactiveForm(
          formGroup: this.form,
          child: Container(
            child: Stack(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Container(
                  // color: Colors.blue,
                  padding: EdgeInsets.all(0),
                  child: Image.asset(
                    'assets/images/bi.png',
                    alignment: Alignment.topRight,
                    fit: BoxFit.fitHeight,
                    // scale: 0.4,
                  ),
                ),
                // PHONE FORM
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
                    width: screenWidth,
                    height: screenHeight * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Nhập số điện thoại",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24),
                        // INPUT
                        Container(
                          width: double.infinity,
                          // color: Colors.grey[300],
                          child: Row(
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  // padding: EdgeInsets.all(4),
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Color(0xFFf4f4f6),
                                  ),
                                  child: ReactiveDropdownField(
                                    formControlName: 'countryCode',
                                    items: _dropdownMenuItems,
                                    style: TextStyle(fontSize: 20),
                                    // onChanged: (value) => setState(() {
                                    //   countryCode = value;
                                    // }),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: ReactiveFormConsumer(
                                    builder: (context, form, child) {
                                  return Container(
                                    height: 48,
                                    // height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Color(0xFFf4f4f6),
                                    ),
                                    child: ReactiveTextField(
                                      validationMessages: {
                                        ValidationMessage.email: ':(',
                                        ValidationMessage.required: ':(',
                                        ValidationMessage.number: ':(',
                                        ValidationMessage.pattern: ':('
                                      },
                                      formControlName: 'phone',
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xFFf4f4f6),
                                        focusColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(
                                            color: Color(0xFFc7c3e4),
                                          ),
                                          // borderRadius: new BorderRadius.circular(25.7),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: new BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: new BorderSide(
                                            color: Colors.red,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        ScopedModelDescendant<LoginViewModel>(
                          builder: (context, child, model) => ButtonTheme(
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
                                onPressed: () {
                                  // marks all children as touched
                                  form.touch();
                                  if (form.valid) {
                                    _handleLogin(model);
                                  } else {
                                    print("Nopt valid form ${form.errors}");
                                  }
                                },
                                child: Text(
                                  "Xác nhận",
                                )),
                          ),
                        ),
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

  Future<void> _handleLogin(LoginViewModel model) async {
    if (!form.valid) return;
    await pr.show();
    String phone = form.value["countryCode"] + form.value["phone"];
    print("phone $phone");
    await onLoginWithPhone(phone, model);
    await pr.hide();
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

  Future<void> onLoginWithPhone(String phone, LoginViewModel model) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) async {
      try {
        await pr.show();
        final userInfo = await model.signIn(authCredential);
        // TODO: Kiem tra xem user moi hay cu
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
          await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => HomeScreen(user: userInfo)),
              (route) => false);
          print("Login Success");
          // chuyen sang trang home
        }
      } on Exception catch (e) {
        _showMyDialog("Lỗi khi đăng nhập", e.toString());
      } finally {
        await pr.hide();
      }
      // dem authuser cho controller xu ly check user
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print("===== Dang nhap fail: ${authException.message}");
      _showMyDialog("Error", authException.message);
    };

    final PhoneCodeSent phoneCodeSent =
        (String verId, [int forceResend]) async {
      await Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => LoginWithPhoneOTP(
          verificationId: verId,
          phoneNumber: phone,
        ),
      ));
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
