import 'package:flutter/material.dart';

class GiftScreen extends StatelessWidget {
  const GiftScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            "Tính năng đổi quà đang được phát triển \n Tích điểm thật nhiều để sẵn saàng cho thật nhiều quà nhá ^0^",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
