import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class ReferralScreen extends StatefulWidget {

  @override
  _ReferralScreenState createState() => _ReferralScreenState();

  ReferralScreen();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final form = FormGroup({
    'ref_code': FormControl(touched: false),
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: SignUpViewModel(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: ReactiveForm(
            formGroup: this.form,
            child: Container(
              color: Color(0xFFddf1ed),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(16),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HELLO SECTION
                        Text("Mã giới thiệu",
                            style: Get.theme.textTheme.headline1),
                        SizedBox(height: 16),
                        FormItem("Mã Giới Thiệu", "Nếu có", "ref_code"),

                        //SIGN UP BUTTON
                        ReactiveFormConsumer(builder: (context, form, child) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 2000),
                            curve: Curves.easeInOut,
                            margin: EdgeInsets.fromLTRB(0, 8, 0, 10),
                            child: Center(
                              child: ScopedModelDescendant<SignUpViewModel>(
                                builder: (context, child, model) =>
                                    RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    // side: BorderSide(color: Colors.red),
                                  ),
                                  color: form.valid
                                      ? Color(0xFF00d286)
                                      : Colors.grey,
                                  onPressed: () async {
                                    if (model.status ==
                                        ViewStatus.Completed){
                                      var refCode = form.value['ref_code']  as String;
                                        await model.addReferralCode(refCode);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: model.status == ViewStatus.Loading
                                        ? CircularProgressIndicator(
                                            backgroundColor: Color(0xFFFFFFFF))
                                        : Text(
                                            (form.value['ref_code'] as String) == null || (form.value['ref_code'] as String).isEmpty
                                                ? "Đăng ký không cần mã"
                                                : "Đăng ký",
                                            style: Get.theme.textTheme.headline1
                                                .copyWith(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        // BACK TO NAV SCREEN
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipPath(
                        clipper: TriangleClipPath(),
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        height: Get.height * 0.25,
                        // width: 250,
                        child: Image.asset(
                          'assets/images/sign_up_character.png',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
