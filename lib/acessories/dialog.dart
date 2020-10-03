import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constraints.dart';

void showStatusDialog(Icon icon, String status, String content) {
  Get.dialog(WillPopScope(
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
              onTap: () => Get.back(),
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
  Get.defaultDialog(barrierDismissible: false, title: "Đợi tý má ơi...", content: WillPopScope(
    onWillPop: (){},
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
  ), titleStyle: TextStyle(fontSize: 16));
}

Future<int> showOptionDialog(String text) async {
  int option;
  Get.dialog(AlertDialog(
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
              Get.back();
            },
          ),
          FlatButton(
            splashColor: kBackgroundGrey[3],
            child: Text("Không", style: TextStyle(color: kPrimary)),
            onPressed: () {
              option = 0;
              Get.back();
            },
          ),
        ],
      )
    ]),
  ));
  return option;
}

void hideDialog() {
  Get.back();
}
