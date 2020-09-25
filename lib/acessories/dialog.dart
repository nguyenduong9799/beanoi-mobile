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

Future<int> getOption(BuildContext context, String text) async {
  int option;
  await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  splashColor: kBackgroundGrey[3],
                  child: Text("Không", style: TextStyle(color: kPrimary)),
                  onPressed: () {
                    option = 0;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ]),
        );
      });
  return option;
}
