import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/ViewModel/signup_viewModel.dart';
import 'package:unidelivery_mobile/utils/regex.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final form = FormGroup({
    'name': FormControl(validators: [
      Validators.required,
    ], touched: false),
    'phone': FormControl(validators: [
      Validators.required,
      Validators.pattern(phoneReg),
      // Validators.number,
    ], touched: false),
    'birthdate': FormControl(validators: [
      Validators.required,
    ], touched: false),
    'email': FormControl(validators: [
      Validators.required,
      Validators.email,
    ], touched: false),
    'gender': FormControl(validators: [
      Validators.required,
    ], touched: false),
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ScopedModel(
      model: SignUpViewModel(),
      child: SafeArea(
        child: Scaffold(
          body: ReactiveForm(
            formGroup: this.form,
            child: Stack(
              // fit: StackFit.expand,
              children: [
                // BACKGROUND
                Container(
                  color: Color(0xFFddf1ed),
                  // child: Center(
                  //   child: Text('SIGNUP'),
                  // ),
                ),
                // SIGN-UP FORM
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(25),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.fromLTRB(15, 15, 15, 0),
                      padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                      width: screenWidth,
                      height: screenHeight * 0.65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // HELLO SECTION
                          Text(
                            "Vài bước nữa là xong rồi nè!",
                            style: TextStyle(
                              color: Color(0xFF00d286),
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Giúp mình điền vài thông tin dưới đây nhé.",
                            style: TextStyle(
                              color: Color(0xFF00d286),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 30),
                          // FORM ITEM
                          Expanded(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                FormItem("Họ Tên", "Nguyễn Văn A", "name"),
                                FormItem("Số Điện Thoại", "012345678", "phone"),
                                FormItem("Email", "abc@gmail.com", "email"),
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
                            ),
                          ),

                          //SIGN UP BUTTON
                          ReactiveFormConsumer(builder: (context, form, child) {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 2000),
                              curve: Curves.easeInOut,
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Center(
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    // side: BorderSide(color: Colors.red),
                                  ),
                                  color: form.valid
                                      ? Color(0xFF00d286)
                                      : Colors.grey,
                                  onPressed: () {
                                    if (form.valid) print(form.value);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      form.valid
                                          ? "Hoàn thành"
                                          : "Bạn chưa điền xong",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -50,
                      left: screenWidth * 0.55,
                      child: ClipPath(
                        clipper: TriangleClipPath(),
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
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
  final List<Map<String, dynamic>> radioGroup;

  const FormItem(
    this.label,
    this.hintText,
    this.formName, {
    Key key,
    this.keyboardType,
    this.radioGroup,
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
            return Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                      ),
                    ),
                    RaisedButton(
                      child: Text("Ngày"),
                      onPressed: () {
                        picker.showPicker();
                      },
                    ),
                  ],
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
            ValidationMessage.pattern: ':('
          },
          formControlName: formName,
          textCapitalization: TextCapitalization.words,
          textAlignVertical: TextAlignVertical.center,
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
              borderSide: new BorderSide(color: Color(0xFFc7c3e4)),
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
      final isRequired = form.control(formName);
      print('$formName isRequried $isRequired');

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
