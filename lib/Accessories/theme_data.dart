import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        fontFamily: 'Gotham',
        primarySwatch: Colors.green,
        primaryColor: kPrimary,
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        toggleableActiveColor: kPrimary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline1: kHeadingTextStyle,
          headline2: kSubheadingTextStyle,
          headline3: kTitleTextStyle,
          headline4: kSubtitleTextStyle,
          headline5: kDescriptionTextStyle,
          headline6: kSubdescriptionTextStyle,
          subtitle1: kDashboardTextStyle,
          subtitle2: kSubdashboardTextStyle
        ));
  }
}
