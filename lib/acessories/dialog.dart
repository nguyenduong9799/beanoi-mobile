import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

import '../constraints.dart';

Future<void> showStatusDialog(Icon icon, String status, String content) async {
  await Get.dialog(WillPopScope(
    onWillPop: () {},
    child: Dialog(
      backgroundColor: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            SizedBox(
              height: 8,
            ),
            Text(
              status,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              // Complete the dialog when you're done with it to return some data
              onTap: () => hideDialog(),
              child: Container(
                child: Text("OK"),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ));
}

void showLoadingDialog() {
  Get.defaultDialog(
      barrierDismissible: false,
      title: "Đợi tý má ơi...",
      content: WillPopScope(
        onWillPop: () {},
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image(
                width: 72,
                height: 72,
                image: AssetImage("assets/images/loading.gif"),
              ),
            ],
          ),
        ),
      ),
      titleStyle: TextStyle(fontSize: 16));
}

Future<bool> showErrorDialog() async {
  hideDialog();
  bool result;
  await Get.dialog(
      WillPopScope(
        onWillPop: () {},
        child: Dialog(
          backgroundColor: Colors.white,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: Icon(AntDesign.closecircleo, color: Colors.red,),
                    onPressed: (){
                      hideDialog();
                    },
                  ),
                ),
              ),
              Text(
                "Có một chút trục trặc nhỏ!!",
                style: kTextSecondary,
              ),
              SizedBox(
                height: 16,
              ),
              Image(
                width: 72,
                height: 72,
                image: AssetImage("assets/images/error.png"),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: kPrimary,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8))),
                child: InkWell(
                  splashColor: kBackgroundGrey[2],
                  onTap: () {
                    result = true;
                    hideDialog();
                  },
                  child: Center(
                    child: Text(
                      "Thử lại",
                      style: kTextPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false);
  return result;
}

Future<int> showOptionDialog(String text) async {
  int option;
  await Get.dialog(
      WillPopScope(
        onWillPop: () {},
        child: Dialog(
          backgroundColor: Colors.white,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: Stack(
            overflow: Overflow.visible,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(AntDesign.closecircleo, color: Colors.red,),
                      onPressed: (){
                        option = 0;
                        hideDialog();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 44,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                     text,
                      style: kTextSecondary,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16))),
                    child: InkWell(
                      splashColor: kBackgroundGrey[2],
                      child: Center(
                        child: Text(
                          "Đồng ý",
                          style: kTextPrimary,
                        ),
                      ),
                      onTap: () {
                        option = 1;
                        hideDialog();
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                top: -80,
                right: -8,
                child: Image(
                  image: AssetImage("assets/images/option.png"),
                  width: 160,
                  height: 160,
                ),
              )

            ],
          ),
        ),
      ),
      barrierDismissible: false);
  return option;
}

void hideDialog() {
  if (Get.isDialogOpen) {
    Get.back();
  }
}

void hideSnackbar() {
  if (Get.isSnackbarOpen) {
    Get.back();
  }
}

Future<void> changeAddressDialog(RootViewModel model, Function function) async {
  hideDialog();
  await Get.dialog(
      WillPopScope(
        onWillPop: () {},
        child: ScopedModel(
          model: model,
          child: ScopedModelDescendant<RootViewModel>(
              builder: (context, child, model) {
            return Dialog(
              backgroundColor: Colors.white,
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 32,
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(AntDesign.closecircleo, color: Colors.red,),
                          onPressed: (){
                            hideDialog();
                            model.changeAddress = false;
                            model.notifyListeners();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  for (int i = 0; i < model.list.length; i++)
                    RadioListTile(
                      activeColor: kFail,
                      groupValue: model.tmp.id,
                      value: model.list[i].id,
                      title: Text(
                        model.list[i].location,
                        style: kTextSecondary,
                      ),
                      onChanged: (value) {
                        model.changeLocation(value);
                      },
                    ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: kPrimary,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16))),
                    child: InkWell(
                      splashColor: kBackgroundGrey[2],
                      onTap: function,
                      child: Center(
                        child: Text(
                          "Xác nhận",
                          style: kTextPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
      barrierDismissible: false);
}
