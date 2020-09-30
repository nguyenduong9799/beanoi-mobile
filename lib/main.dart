import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/View/LoginScreen/LoginByPhone.dart';
import 'package:unidelivery_mobile/View/LoginScreen/LoginPhoneOTP.dart';
import 'package:unidelivery_mobile/View/gift.dart';
import 'package:unidelivery_mobile/View/home.dart';
import 'package:unidelivery_mobile/View/login.dart';
import 'package:unidelivery_mobile/View/nav_screen.dart';
import 'package:unidelivery_mobile/View/order.dart';
import 'package:unidelivery_mobile/View/orderHistory.dart';
import 'package:unidelivery_mobile/View/order_detail.dart';
import 'package:unidelivery_mobile/View/product_detail.dart';
import 'package:unidelivery_mobile/View/profile.dart';
import 'package:unidelivery_mobile/View/signup.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/route_constraint.dart';
import 'package:unidelivery_mobile/utils/index.dart';
import 'package:unidelivery_mobile/utils/pageNavigation.dart';
import 'package:unidelivery_mobile/utils/request.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch(settings.name){
          case RouteHandler.LOGIN_PHONE:
            return CupertinoPageRoute(builder: (context) => LoginWithPhone(), settings: settings);
          case RouteHandler.LOGIN_OTP:
            return CupertinoPageRoute(builder: (context) => LoginWithPhoneOTP(), settings: settings);
          case RouteHandler.LOGIN:
            return FadeRoute(page: LoginScreen());
          case RouteHandler.GIFT:
            return CupertinoPageRoute(builder: (context) => GiftScreen(), settings: settings);
          case RouteHandler.HOME:
            return CupertinoPageRoute(builder: (context) => HomeScreen(), settings: settings);
          case RouteHandler.NAV:
            return CupertinoPageRoute(builder: (context) => RootScreen(), settings: settings);
          case RouteHandler.ORDER:
            return CupertinoPageRoute<bool>(builder: (context) => OrderScreen(), settings: settings);
          case RouteHandler.ORDER_DETAIL:
            return CupertinoPageRoute(builder: (context) => OrderDetailScreen(), settings: settings);
          case RouteHandler.ORDER_HISTORY:
            return CupertinoPageRoute(builder: (context) => OrderHistoryScreen(), settings: settings);
          case RouteHandler.PRODUCT_DETAIL:
            return CupertinoPageRoute<bool>(builder: (context) => ProductDetailScreen(dto: settings.arguments,), settings: settings);
          case RouteHandler.PROFILE:
            return CupertinoPageRoute(builder: (context) => ProfileScreen(dto: settings.arguments,), settings: settings);
          case RouteHandler.SIGN_UP:
            return CupertinoPageRoute(builder: (context) => SignUp(), settings: settings);
          case RouteHandler.NETWORK_ERROR:
            return CupertinoPageRoute(builder: (context) => NetworkErrorScreen(), settings: settings);
        }
      },

      theme: ThemeData(
        fontFamily: 'SourceSansPro',
        primarySwatch: Colors.blue,
        primaryColor: kPrimary,
        scaffoldBackgroundColor: Color(0xFFF0F2F5),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: checkNetwork(),
      // home: ProfileScreen(new AccountDTO(name: "Mít tơ Bin")),
    );
  }

  Widget checkNetwork() {
    return FutureBuilder(
      future: checkNetworkAvailable(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // AccountDAO dao = AccountDAO();
        if (!snapshot.hasData) return LoadingScreen();
        bool hasNetwork = snapshot.data;
        return hasNetwork ? checkAuthorize() : NetworkErrorScreen();
      },
    );
  }

  Widget checkAuthorize() {
    // return token != null ? HomeScreen() : LoginScreen();
    return FutureBuilder(
      future: getToken(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AccountDAO dao = AccountDAO();
        String token = snapshot.data;
        if (token != null) requestObj.setToken = token;
        // cho nay co can gui token lai cho server khong
        // neu khong thi lay thong tin user tu token ma thoi
        return token != null ? RootScreen() : LoginScreen();
      },
    );
  }
}

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            "Không có kết nối Internet vui lòng thử lại",
            style: TextStyle(
              color: kPrimary,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          // width: 250.0,
          child: Center(
            child: TextLiquidFill(
              text: 'UniDelivery',
              waveColor: kPrimary,
              boxBackgroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: 45.0,
                fontWeight: FontWeight.bold,
              ),
              boxHeight: 300.0,
            ),
          ),
        ),
      ),
    );
  }
}
