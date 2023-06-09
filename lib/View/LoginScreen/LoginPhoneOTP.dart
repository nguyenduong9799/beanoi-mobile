import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:flutter/foundation.dart';

class LoginWithPhoneOTP extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final ConfirmationResult confirmationResult;

  LoginWithPhoneOTP(
      {Key key,
      this.verificationId,
      @required this.phoneNumber,
      this.confirmationResult})
      : super(key: key);

  @override
  _LoginWithPhoneOTPState createState() => _LoginWithPhoneOTPState();
}

class _LoginWithPhoneOTPState extends State<LoginWithPhoneOTP> {
  StreamController<ErrorAnimationType> errorController;

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
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ScopedModel<LoginViewModel>(
      model: LoginViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  color: BeanOiTheme.palettes.primary300,
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
            onPressed: () => Get.back(),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    // color: Colors.blue,
                    padding: EdgeInsets.only(right: 16),
                    child: Image.asset(
                      'assets/images/bi_password.png',
                      alignment: Alignment.bottomRight,
                      fit: BoxFit.fitHeight,
                      // scale: 0.4,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: BeanOiTheme.palettes.primary300,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(48, 24, 48, 16),
                  height: screenHeight * 0.55,
                  width: screenWidth,
                  child: ScopedModelDescendant<LoginViewModel>(
                    builder: (BuildContext context, Widget child,
                        LoginViewModel model) {
                      return ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Nhập mã OTP',
                              style: BeanOiTheme.typography.h1
                                  .copyWith(color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 30.0, vertical: 8),
                          //   // child: RichText(
                          //   //   text: TextSpan(
                          //   //       text: "Nhập code được gửi tới số\n",
                          //   //       children: [
                          //   //         TextSpan(
                          //   //             text: widget.phoneNumber,
                          //   //             style: TextStyle(
                          //   //                 color: Colors.white,
                          //   //                 fontWeight: FontWeight.bold,
                          //   //                 fontSize: 15)),
                          //   //       ],
                          //   //       style: TextStyle(
                          //   //           color: Colors.black54, fontSize: 15)),
                          //   //   textAlign: TextAlign.center,
                          //   // ),
                          // ),
                          _buildOTPForm(context, model),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                                model.status == ViewStatus.Error
                                    ? "Bạn chưa nhập đủ mã OTP :(."
                                    : "",
                                style: Get.theme.textTheme.headline4
                                    .copyWith(color: Colors.red)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // RichText(
                          //   textAlign: TextAlign.center,
                          //   text: TextSpan(
                          //       text: "Chưa nhận được code?",
                          //       style: TextStyle(
                          //           color: Colors.black54, fontSize: 15),
                          //       children: [
                          //         TextSpan(
                          //           text: " Gửi lại",
                          //           // recognizer: onTapRecognizer,
                          //           style: TextStyle(
                          //               color: Colors.blue[800],
                          //               fontWeight: FontWeight.bold,
                          //               fontSize: 16),
                          //         )
                          //       ]),
                          // ),
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
                                if (!form.valid) {
                                  errorController.add(ErrorAnimationType
                                      .shake); // Triggering error shake animation
                                  model.setState(ViewStatus.Loading);
                                } else {
                                  if ((form.value["otp"] as String).length !=
                                      6) {
                                    errorController.add(ErrorAnimationType
                                        .shake); // Triggering error shake animation
                                    model.setState(ViewStatus.Error);
                                  } else {
                                    if (kIsWeb) {
                                      await model.onsignInWithOTPForWeb(
                                          form.value["otp"],
                                          widget.confirmationResult);
                                    } else {
                                      // await model.onsignInWithOTPForWeb(
                                      //     form.value["otp"],
                                      //     widget.confirmationResult);
                                      await model.onsignInWithOTP(
                                          form.value["otp"],
                                          widget.verificationId);
                                    }
                                  }
                                }
                              },
                              child: Center(
                                  child: Text("Xác nhận".toUpperCase(),
                                      style: BeanOiTheme.typography.h1)),
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
    );
  }

  Widget _buildOTPForm(BuildContext context, LoginViewModel model) {
    return PinCodeTextField(
      textStyle: Get.theme.textTheme.headline1,
      length: 6,
      animationType: AnimationType.fade,
      obscureText: false,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        inactiveColor: kBackgroundGrey[0],
        selectedFillColor: Colors.white,
        inactiveFillColor: BeanOiTheme.palettes.primary300,
        activeFillColor: Colors.white,
        activeColor: BeanOiTheme.palettes.primary300,
        selectedColor: BeanOiTheme.palettes.primary300,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: 50,
        fieldWidth: 40,
      ),
      animationDuration: Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      enableActiveFill: true,
      errorAnimationController: errorController,
      onCompleted: (value) {},
      onChanged: (value) {
        form.control('otp').value = value;
        if (value?.length == 6) {
          model.onsignInWithOTP(value, widget.verificationId);
        }
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
