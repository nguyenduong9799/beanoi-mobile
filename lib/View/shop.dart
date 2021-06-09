import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Constraints/constraints.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key key}) : super(key: key);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    //     statusBarColor: kPrimary, // Color for Android
    //     statusBarBrightness:
    //         Brightness.dark // Dark == white status bar -- for IOS.
    //     ));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimary,
        title: Text(
          "Bean Shop",
          style: kHeadingTextStyle.copyWith(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              width: Get.width,
              height: 70,
              color: Colors.white,
              child: Center(child: Text("Search section")),
            ),
            SizedBox(height: 16),
            Flexible(
              child: ListView(
                children: [
                  Container(
                    color: Colors.white,
                    child: Center(child: Text("Category section")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
