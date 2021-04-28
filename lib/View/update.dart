import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/regex.dart';

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
    'birthdate': FormControl(validators: [], touched: false),
    'email': FormControl(validators: [
      Validators.email,
    ], touched: false),
    'gender': FormControl(validators: [
      Validators.required,
    ], touched: false, value: 'nam'),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ScopedModel(
      model: SignUpViewModel(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
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
                                    "value": "nam",
                                  },
                                  {
                                    "title": "Nữ",
                                    "value": "nữ",
                                  }
                                ],
                              ),
                            ],
                          )),
                          ReactiveFormConsumer(builder: (context, form, child) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 2000),
                              curve: Curves.easeInOut,
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
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
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
                        height: screenHeight * 0.25 - 32,
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

class FormItem extends StatelessWidget {
  final String label;
  final String hintText;
  final String formName;
  final String keyboardType;
  final bool isReadOnly;

  final List<Map<String, dynamic>> radioGroup;

  const FormItem(
    this.label,
    this.hintText,
    this.formName, {
    Key key,
    this.keyboardType,
    this.radioGroup,
    this.isReadOnly = false,
  }) : super(key: key);

  Widget _getFormItemType(FormGroup form) {
    final formControl = form.control(formName);

    switch (keyboardType) {
      case "radio":
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...radioGroup
                .map((e) => Flexible(
                      child: Row(
                        children: [
                          ReactiveRadio(
                            value: e["value"],
                            formControlName: formName,
                          ),
                          Text(e["title"]),
                        ],
                      ),
                    ))
                .toList(),
          ],
        );
      case "datetime":
        return ReactiveDatePicker(
          firstDate: DateTime(1900),
          lastDate: DateTime(2030),
          formControlName: formName,
          builder: (BuildContext context, ReactiveDatePickerDelegate picker,
              Widget child) {
            return GestureDetector(
              onTap: () {
                picker.showPicker();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 72,
                child: Theme(
                  data: ThemeData.dark(),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          formControl.value != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format((formControl.value as DateTime))
                              : "Chọn ngày",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      default:
        return ReactiveTextField(
          validationMessages: {
            ValidationMessage.email: ':(',
            ValidationMessage.required: ':(',
            ValidationMessage.number: ':(',
            ValidationMessage.pattern: ':(',
            ValidationMessage.minLength: 'Tối thiểu 5 ký tự',
            ValidationMessage.maxLength: 'Tối đa 255 ký tự',
          },
          // enableInteractiveSelection: false,
          style: TextStyle(color: isReadOnly ? kPrimary : Colors.black),
          readOnly: isReadOnly,
          formControlName: formName,
          textCapitalization: TextCapitalization.words,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: this.label == "Email"
              ? TextInputAction.done
              : TextInputAction.next,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFf4f4f6),
            suffixIcon: AnimatedOpacity(
                duration: Duration(milliseconds: 700),
                opacity: formControl.valid ? 1 : 0,
                curve: Curves.fastOutSlowIn,
                child: Icon(Icons.check, color: Color(0xff00d286))),
            focusColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide: new BorderSide(
                  color: isReadOnly ? Colors.transparent : kPrimary),
              // borderRadius: new BorderRadius.circular(25.7),
            ),
            enabledBorder: InputBorder.none,
            // border: OutlineInputBorder(
            //   borderSide: BorderSide.none,
            // ),
            // focusColor: Colors.red,
            hintText: hintText,
            // labelText: label,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveFormConsumer(builder: (context, form, child) {
      return Container(
        margin: EdgeInsets.only(bottom: 15),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Text(
                label,
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Container(
                color: Color(0xFFf4f4f6),
                child: _getFormItemType(form),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class TriangleClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
