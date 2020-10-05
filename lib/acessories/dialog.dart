import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                child: InkWell(
                  onTap: () {
                    result = false;
                    hideDialog();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      width: 32,
                      height: 32,
                      image: AssetImage("assets/images/icons/error.png"),
                    ),
                  ),
                ),
              ),
              Text(
                "Có một chút trục trặc nhỏ!!",
                style: TextStyle(fontSize: 18, color: kPrimary),
              ),
              SizedBox(
                height: 8,
              ),
              Image(
                width: 72,
                height: 72,
                image: AssetImage("assets/images/error.png"),
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                color: kPrimary,
                elevation: 16,
                child: InkWell(
                  onTap: () {
                    result = true;
                    hideDialog();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        "Thử lại",
                        style: kTextPrimary,
                      ),
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
  await Get.dialog(AlertDialog(
    title: Center(child: Text(text)),
    content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            splashColor: kBackgroundGrey[3],
            child: Text(
              "Có",
              style: TextStyle(color: kPrimary),
            ),
            onPressed: () {
              option = 1;
              hideDialog();
            },
          ),
          FlatButton(
            splashColor: kBackgroundGrey[3],
            child: Text("Không", style: TextStyle(color: kPrimary)),
            onPressed: () {
              option = 0;
              hideDialog();
            },
          ),
        ],
      )
    ]),
  ));
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
