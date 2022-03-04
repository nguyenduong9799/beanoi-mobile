import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class Update extends StatefulWidget {
  const Update({Key key, this.user}) : super(key: key);
  final AccountDTO user;

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final form = FormGroup({
    'name': FormControl(validators: [
      Validators.required,
      Validators.minLength(5),
      Validators.maxLength(255),
    ], touched: false),
    'phone': FormControl(validators: [
      Validators.required,
      Validators.pattern(phoneReg),
      // Validators.number,
    ], touched: false),
    'birthdate': FormControl<DateTime>(validators: [], touched: false),
    'email': FormControl(validators: [
      Validators.email,
    ], touched: false),
    'gender': FormControl(validators: [
      Validators.required,
    ], touched: false, value: 0),
  });

  @override
  void initState() {
    super.initState();

    final user = widget.user;
    // UPDATE USER INFO INTO FORM
    if (user != null) {
      form.value = {
        "name": user.name,
        "phone": user.phone,
        "birthdate": user.birthdate,
        "email": user.email,
        "gender": user.gender,
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: SignUpViewModel(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: ReactiveForm(
            formGroup: this.form,
            child: Container(
              color: Color(0xFFddf1ed),
              child: Column(
                children: [
                  // SIGN-UP FORM
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(16),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
                      child: Column(
                        children: [
                          // HELLO SECTION
                          Expanded(
                              child: ListView(
                            children: [
                              FormItem("Họ Tên", "vd: Nguyễn Văn A", "name"),
                              FormItem(
                                "Số Điện Thoại",
                                "012345678",
                                "phone",
                                isReadOnly: true,
                              ),
                              FormItem("Email", "vd: abc@gmail.com", "email"),
                              FormItem(
                                "Ngày sinh",
                                "01/01/2020",
                                "birthdate",
                                keyboardType: "datetime",
                              ),
                              FormItem(
                                "Giới tính",
                                null,
                                "gender",
                                keyboardType: "radio",
                                radioGroup: [
                                  {
                                    "title": "Nam",
                                    "value": 0,
                                  },
                                  {
                                    "title": "Nữ",
                                    "value": 1,
                                  },
                                  {
                                    "title": "Khác",
                                    "value": 2,
                                  }
                                ],
                              ),
                            ],
                          )),
                          ReactiveFormConsumer(builder: (context, form, child) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 2000),
                              curve: Curves.easeInOut,
                              margin: EdgeInsets.only(bottom: 16),
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
                                          ViewStatus
                                              .Completed) if (form.valid) {
                                        await model.updateUser(form.value);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: model.status == ViewStatus.Loading
                                          ? CircularProgressIndicator(
                                              backgroundColor:
                                                  Color(0xFFFFFFFF))
                                          : Text(
                                              form.valid
                                                  ? "Hoàn thành"
                                                  : "Bạn chưa điền xong",
                                              style: Get
                                                  .theme.textTheme.headline1
                                                  .copyWith(
                                                      color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          // FORM ITEM
                          //SIGN UP BUTTON
                        ],
                      ),
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
                        height: Get.height * 0.25 - 32,
                        padding: EdgeInsets.only(top: 8),
                        child: Image.asset(
                          'assets/images/sign_up_character.png',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          appBar: DefaultAppBar(
            title: "Cập nhật thông tin",
          ),
        ),
      ),
    );
  }
}
