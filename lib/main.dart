import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/View/design_screen.dart';
import 'package:unidelivery_mobile/View/index.dart';
import 'package:unidelivery_mobile/View/referral.dart';
import 'package:unidelivery_mobile/View/transaction.dart';
import 'package:unidelivery_mobile/View/transactionDetail.dart';
import 'package:unidelivery_mobile/View/voucher.dart';
import 'package:unidelivery_mobile/View/voucherDetail.dart';
import 'package:unidelivery_mobile/setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  await setUp();
  createRouteBindings();
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
                      confirmationResult: map["confirmationResult"],
                    ),
                settings: settings);
          case RouteHandler.LOGIN:
            return ScaleRoute(page: LoginScreen());
          case RouteHandler.SEACH_PAGE:
            return ScaleRoute(page: SearchScreen());
          case RouteHandler.GIFT:
            return CupertinoPageRoute(
                builder: (context) => GiftScreen(), settings: settings);
          case RouteHandler.HOME:
            return CupertinoPageRoute(
                builder: (context) => HomeScreen(), settings: settings);
          case RouteHandler.BANNER_DETAIL:
            return FadeRoute(
              page: BannerDetailScreen(blog: settings.arguments),
            );
          case RouteHandler.HOME_DETAIL:
            return CupertinoPageRoute<bool>(
                builder: (context) => SupplierScreen(
                      supplier: settings.arguments,
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
          case RouteHandler.DYNAMIC_LINK:
            return CupertinoPageRoute(
                builder: (context) => DynamicScreen(), settings: settings);
          case RouteHandler.ORDER_HISTORY:
            return CupertinoPageRoute(
                builder: (context) => OrderHistoryScreen(), settings: settings);
          case RouteHandler.ORDER_HISTORY_DETAIL:
            return SlideBottomRoute(
              page: OrderHistoryDetail(order: settings.arguments),
            );
          case RouteHandler.PRODUCT_DETAIL:
            return CupertinoPageRoute<bool>(
                builder: (context) => ProductDetailScreen(
                      dto: settings.arguments,
                    ),
                settings: settings);
          case RouteHandler.PRODUCT_FILTER_LIST:
            return CupertinoPageRoute<bool>(
                builder: (context) => ProductsFilterPage(
                      params: settings.arguments,
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
          case RouteHandler.SIGN_UP_REFERRAL:
            return CupertinoPageRoute<bool>(
                builder: (context) => ReferralScreen(), settings: settings);
          case RouteHandler.UPDATE:
            return CupertinoPageRoute<bool>(
                builder: (context) => Update(
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
          case RouteHandler.BEAN_MART:
            return ScaleRoute(page: ShopScreen());
          case RouteHandler.WEBVIEW:
            return FadeRoute(
              page: WebViewScreen(url: settings.arguments),
            );
          case RouteHandler.TRANSACTION:
            return CupertinoPageRoute(
                builder: (context) => TransactionScreen(), settings: settings);
          case RouteHandler.TRANSACTION_DETAIL:
            return SlideBottomRoute(
              page: TransactionDetailScreen(transaction: settings.arguments),
            );
          case RouteHandler.VOUCHER:
            return CupertinoPageRoute<bool>(
                builder: (context) => VouchersListPage(), settings: settings);
          case RouteHandler.VOUCHER_DETAIL:
            return CupertinoPageRoute<bool>(
                builder: (context) => VoucherDetailListPage(),
                settings: settings);
          case RouteHandler.DESIGN:
            return CupertinoPageRoute<bool>(
                builder: (context) => DesignScreen(), settings: settings);
          default:
            return CupertinoPageRoute(
                builder: (context) => NotFoundScreen(), settings: settings);
        }
      },
      theme: CustomTheme.lightTheme,
      // home: Scaffold(
      home: StartUpView(),
    );
  }
}
