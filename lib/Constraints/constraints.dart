import 'package:flutter/material.dart';

const kPrimary = Color(0xFF4fba6f);
const kSecondary = Color(0xFF438029);
const kBean = Color(0xffffe844);
const kSuccess = Colors.green;
const kFail = Colors.red;
// final kBackgroundGrey = Color(0xfff2f6f8);
const kBackgroundGrey = [
  Color(0xFFFFFFFF),
  Color(0xfffafafa),
  Color(0xfff5f5f5),
  Color(0xffe0e0e0),
  Color(0xffbdbdbd),
  Color(0xff9e9e9e),
  Color(0xff757575),
  Color(0xfff2f6f8),
];
const kGreyTitle = Color(0xFF575757);

const kTextSecondary = TextStyle(color: Colors.grey);

// Colors
const kTextColor = Color(0xFF0D1333);
const kBlueColor = Color(0xFF6E8AFA);
const kBestSellerColor = Color(0xffF1A23A);
const kGreenColor = Color(0xFF49CC96);
const kDescriptionTextColor = Color(0xffaaaaaa);

// My Text Styles
const kHeadingTextStyle = TextStyle(
  fontSize: 24,
  color: kPrimary,
  fontWeight: FontWeight.bold,
);

const kSubheadingTextStyle = TextStyle(
  fontSize: 16,
  color: kPrimary,
);

const kTitleTextStyle = TextStyle(
  fontSize: 16,
  color: kTextColor,
  fontWeight: FontWeight.bold,
);

const kSubtitleTextStyle = TextStyle(
  fontSize: 14,
  color: kTextColor,
  // fontWeight: FontWeight.bold,
);

const kDescriptionTextStyle = TextStyle(
  fontSize: 14,
  color: kDescriptionTextColor,
  fontWeight: FontWeight.w100,
);

const kSubdescriptionTextStyle = TextStyle(
  fontSize: 12,
  color: kDescriptionTextColor,
);

const kDashboardTextStyle = TextStyle(
  fontSize: 22,
  color: kPrimary,
  fontWeight: FontWeight.bold,
);

const kSubdashboardTextStyle = TextStyle(
  fontSize: 20,
  color: kPrimary,
);

const String CART_TAG = "cartTag";

const UNIBEAN_STORE = 150;
const UNIBEAN_BRAND = 10;
const double DIALOG_ICON_SIZE = 60;
const String defaultImage =
    "https://firebasestorage.googleapis.com/v0/b/unidelivery-fad6f.appspot.com/o/images%2Fdefault_image.png?alt=media&token=3c1cf2f4-52be-4df1-aed5-cdb5fd4990d8";
const String defaultPromotionImage =
    "https://firebasestorage.googleapis.com/v0/b/unidelivery-fad6f.appspot.com/o/images%2Fstores%2Ffood-drink-banner.jpg?alt=media&token=96b3c6dc-c93b-4066-b3fa-dacc64f14edc";

const List<String> TIMES = ["12:00 PM - 12:10 PM"];
const String VERSION = "0.0.1";
const int ORDER_NEW_STATUS = 1;
const int ORDER_DONE_STATUS = 3;
const int ORDER_CANCEL_STATUS = 4;
const int VIRTUAL_STORE_TYPE = 8;
const int DEFAULT_SIZE = 50;
const phoneReg = r'^(0|\+)([0-9])+$';

class ProductType {
  static const int EXTRA_PRODUCT = 5;
  static const int MASTER_PRODUCT = 6;
  static const int DETAIL_PRODUCT = 7;
  static const int COMPLEX_PRODUCT = 10;
  static const int GIFT_PRODUCT = 12;
}

class TransactionStatus {
  static const int NEW = 0;
  static const int APPROVE = 1;
  static const int CANCEL = 2;
}
