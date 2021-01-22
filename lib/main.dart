import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/View/home_detail.dart';
import 'package:unidelivery_mobile/View/onboard.dart';
import 'package:unidelivery_mobile/View/start_up.dart';
import 'package:unidelivery_mobile/acessories/product_promotion.dart';
import 'package:unidelivery_mobile/route_constraint.dart';
import 'package:unidelivery_mobile/setup.dart';
import 'package:unidelivery_mobile/utils/pageNavigation.dart';
import 'package:unidelivery_mobile/constraints.dart';

import 'package:unidelivery_mobile/View/index.dart';
import 'package:unidelivery_mobile/utils/request.dart';

import 'Model/DTO/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();

  await setUp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      title: 'BeanOi',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RouteHandler.LOGIN_PHONE:
            return CupertinoPageRoute(
                builder: (context) => LoginWithPhone(), settings: settings);
          case RouteHandler.LOGIN_OTP:
            Map map = settings.arguments;
            return CupertinoPageRoute(
                builder: (context) => LoginWithPhoneOTP(
                      phoneNumber: map["phoneNumber"],
                      verificationId: map["verId"],
                    ),
                settings: settings);
          case RouteHandler.LOGIN:
            return ScaleRoute(page: LoginScreen());
          case RouteHandler.GIFT:
            return CupertinoPageRoute(
                builder: (context) => GiftScreen(), settings: settings);
          case RouteHandler.HOME:
            return CupertinoPageRoute(
                builder: (context) => HomeScreen(), settings: settings);
          case RouteHandler.HOME_DETAIL:
            return CupertinoPageRoute<bool>(
                builder: (context) => HomeScreenDetail(
                      store: settings.arguments,
                    ),
                settings: settings);
          case RouteHandler.NAV:
            return CupertinoPageRoute(
                builder: (context) => RootScreen(
                      initScreenIndex: settings.arguments ?? 0,
                    ),
                settings: settings);
          case RouteHandler.ORDER:
            return CupertinoPageRoute<bool>(
                builder: (context) => OrderScreen(), settings: settings);
          // case RouteHandler.ORDER_DETAIL:
          //   return CupertinoPageRoute(
          //       builder: (context) => OrderDetailScreen(), settings: settings);
          case RouteHandler.ORDER_HISTORY:
            return CupertinoPageRoute(
                builder: (context) => OrderHistoryScreen(), settings: settings);
          case RouteHandler.PRODUCT_DETAIL:
            return CupertinoPageRoute<bool>(
                builder: (context) => ProductDetailScreen(
                      dto: settings.arguments,
                    ),
                settings: settings);
          case RouteHandler.PROFILE:
            return CupertinoPageRoute(
                builder: (context) => ProfileScreen(), settings: settings);
          case RouteHandler.SIGN_UP:
            return CupertinoPageRoute<bool>(
                builder: (context) => SignUp(
                      user: settings.arguments,
                    ),
                settings: settings);
          case RouteHandler.LOADING:
            return CupertinoPageRoute<bool>(
                builder: (context) => LoadingScreen(
                      title: settings.arguments ?? "Đang xử lý...",
                    ),
                settings: settings);
          case RouteHandler.ONBOARD:
            return ScaleRoute(page: OnBoardScreen());
          default:
            return CupertinoPageRoute(
                builder: (context) => NotFoundScreen(), settings: settings);
        }
      },
      theme: ThemeData(
        fontFamily: 'Gotham',
        primarySwatch: Colors.green,
        primaryColor: kPrimary,
        scaffoldBackgroundColor: Color(0xFFF0F2F5),
        toggleableActiveColor: kPrimary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: Scaffold(
      //   body: Container(
      //       margin: EdgeInsets.only(top: 16),
      //       child: StorePromotion(new ProductDTO(1, name: "Test", description: "abc", prices: [1500, 2000000000]))),
      // ),
      home: StartUpView(),
    );
  }
}
