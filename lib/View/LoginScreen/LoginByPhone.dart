import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/countries.dart';

class LoginWithPhone extends StatefulWidget {
  LoginWithPhone({Key key}) : super(key: key);

  @override
  _LoginWithPhoneState createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  List<DropdownMenuItem<dynamic>> _dropdownMenuItems;
  String verificationId, phoneNb, countryCode = "+84";
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // pr = new ProgressDialog(
    //   context,
    //   showLogs: true,
    //   type: ProgressDialogType.Download,
    //   isDismissible: false,
    // );

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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      bottom: false,
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
        body: Form(
          key: _formKey,
          child: Container(
            child: Column(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      Container(
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Flexible(
                            //   flex: 1,
                            //   child: DropdownButtonHideUnderline(
                            //     child: DropdownButton(
                            //         value: countryCode,
                            //         items: _dropdownMenuItems,
                            //         onChanged: (value) => setState(() {
                            //               countryCode = value;
                            //             })),
                            //   ),
                            // ),
                            SizedBox(width: 5),
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                style:
                                    kTextPrimary.copyWith(color: Colors.white),
                                autofocus: true,
                                controller: _controller,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Bạn chưa nhập SDT kìa :(';
                                  }
                                  return null;
                                },
                                onChanged: (val) => setState(() {
                                  this.phoneNb = val;
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
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
                            onPressed: () {
                              if (_formKey.currentState.validate())
                                Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => LoginWithPhoneOTP(),
                                ));
                            },
                            child: Text(
                              "Xác nhận",
                              // style: kTextPrimary,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginWithPhoneOTP extends StatefulWidget {
  LoginWithPhoneOTP({Key key}) : super(key: key);

  @override
  _LoginWithPhoneOTPState createState() => _LoginWithPhoneOTPState();
}

class _LoginWithPhoneOTPState extends State<LoginWithPhoneOTP> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
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
          child: Column(
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
                    'assets/images/bi_password.png',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
