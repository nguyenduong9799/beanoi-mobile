import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';

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
                          style: Get.theme.textTheme.headline4,
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
          style: isReadOnly
              ? Get.theme.textTheme.headline4.copyWith(color: kPrimary)
              : Get.theme.textTheme.headline4,
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
              child: Text(label, style: Get.theme.textTheme.headline4),
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
