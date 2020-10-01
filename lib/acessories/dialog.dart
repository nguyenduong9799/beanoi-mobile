import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked_services/stacked_services.dart';

import '../constraints.dart';
import '../locator.dart';

NavigationService _navigationService = locator<NavigationService>();

void showStatusDialog(Icon icon, String status, String content) {
  Get.dialog(Dialog(
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
            onTap: () => _navigationService.back(),
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
  ));
}

void showLoadingDialog() {
  Get.dialog(
      WillPopScope(
        onWillPop: () {},
        child: Dialog(
          backgroundColor: Colors.white,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/images/loading.gif"),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Đợi tý má ơi...",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false);
}

void hideDialog() {
  _navigationService.back();
}
