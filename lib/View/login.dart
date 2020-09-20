import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/View/LoginScreen/LoginByPhone.dart';
import 'package:unidelivery_mobile/ViewModel/login_viewModel.dart';
import 'package:unidelivery_mobile/constraints.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: screenHeight * 0.1,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  // color: Colors.blue,
                  padding: EdgeInsets.all(0),
                  child: Image.asset(
                    'assets/images/bi.png',
                    alignment: Alignment.bottomRight,
                    fit: BoxFit.fitHeight,
                    // scale: 0.4,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(48, 24, 48, 16),
                height: screenHeight * 0.55,
                child: ButtonTheme(
                  minWidth: 200.0,
                  height: 48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RaisedButton(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          // side: BorderSide(color: Colors.red),
                        ),
                        onPressed: () {
                          // Navigator.of(context).push(PageRouteBuilder(
                          //   pageBuilder:
                          //       (context, animation, secondaryAnimation) =>
                          //           LoginWithPhone(),
                          //   transitionsBuilder: (context, animation,
                          //       secondaryAnimation, child) {
                          //     var begin = Offset(0.0, 1.0);
                          //     var end = Offset.zero;
                          //     var tween = Tween(begin: begin, end: end);
                          //     var offsetAnimation = animation.drive(tween);

                          //     return SlideTransition(
                          //       position: offsetAnimation,
                          //       child: child,
                          //     );
                          //   },
                          // ));
                          Navigator.of(context).push(CupertinoPageRoute(
                            builder: (context) => LoginWithPhone(),
                          ));
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.phone),
                              decoration: BoxDecoration(
                                color: Color(0xffffd24d),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Đăng nhập bằng số điện thoại",
                                style: TextStyle(color: kPrimary, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      RaisedButton(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          // side: BorderSide(color: Colors.red),
                        ),
                        onPressed: null,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Icon(FontAwesome.google),
                              decoration: BoxDecoration(
                                color: Color(0xffffd24d),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Đăng nhập bằng Gmail",
                                style: TextStyle(color: kPrimary, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: kPrimary,
              //       borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(16),
              //         topRight: Radius.circular(16),
              //       ),
              //     ),
              //     width: screenWidth,
              //     height: screenHeight * 0.55,
              //     child: Stack(
              //       children: [
              //         Container(
              //           child: ScopedModelDescendant<LoginViewModel>(
              //             builder: (BuildContext context, Widget child,
              //                     LoginViewModel model) =>
              //                 _buildLoginForm(model),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
