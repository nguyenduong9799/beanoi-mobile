import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constraints.dart';

void showStatusDialog(
    BuildContext context, Icon icon, String status, String content) {
  showDialog<dynamic>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
          backgroundColor: Colors.white,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                Center(
                    child: Text(
                  status,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                SizedBox(
                  height: 10,
                ),
                Text(content),
                SizedBox(
                  height: 20,
                ),
                ButtonTheme(
                  minWidth: double.infinity,
                  child: FlatButton(
                    color: kPrimary,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("OK"),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          ));
    },
  );
  // Delaying the function for 200 milliseconds
}
