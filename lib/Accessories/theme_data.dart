import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
        fontFamily: 'Inter',
        primarySwatch: Colors.green,
        primaryColor: BeanOiTheme.palettes.primary300,
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        toggleableActiveColor: kPrimary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
            headline1: BeanOiTheme.typography.h1,
            headline2: BeanOiTheme.typography.h2,
            headline3: kTitleTextStyle,
            headline4: kSubtitleTextStyle,
            headline5: kDescriptionTextStyle,
            headline6: kSubdescriptionTextStyle,
            subtitle1: BeanOiTheme.typography.subtitle1,
            subtitle2: BeanOiTheme.typography.subtitle2));
  }
}

// TODO: Setup design system (constants)
// TODO: Map to theme data