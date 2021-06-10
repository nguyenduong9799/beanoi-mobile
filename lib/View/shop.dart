import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/CacheImage.dart';
import 'package:unidelivery_mobile/Accessories/section.dart';
import 'package:unidelivery_mobile/Accessories/touchopacity.dart';
import 'package:unidelivery_mobile/Constraints/constraints.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/View/index.dart';

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
        backgroundColor: Colors.white,
        title: Text(
          "Bean Shop",
          style: kHeadingTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            TouchOpacity(
              onTap: () {
                // GO TO SEARCH PAGE
                Get.toNamed(RouteHandler.SEACH_PAGE);
              },
              child: Container(
                width: Get.width,
                height: 64,
                color: Colors.white,
                padding: EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      "🔍 Tìm sản phẩm",
                      style: kSubdescriptionTextStyle.copyWith(fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Flexible(
              child: ListView(
                children: [
                  Section(
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(8),
                        width: Get.width,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              List.generate(8, (_) => buildCategoryItem()),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryItem() {
    return TouchOpacity(
      onTap: () {
        print('Click category');
        Get.toNamed(RouteHandler.PRODUCT_FILTER_LIST,
            arguments: {"category-id": 1});
      },
      child: Container(
        width: Get.width / 4 - 20,
        height: Get.width / 4 - 20 + 35,
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipOval(
                child: Container(
                  child: CacheImage(
                    imageUrl: null,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Text(
                "Item asdasa-s asdasds",
                style: kTitleTextStyle.copyWith(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
