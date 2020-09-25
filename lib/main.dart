import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/View/home.dart';
import 'package:unidelivery_mobile/View/login.dart';
import 'package:unidelivery_mobile/View/nav_screen.dart';
import 'package:unidelivery_mobile/View/orderHistory.dart';
import 'package:unidelivery_mobile/View/signup.dart';
import 'package:unidelivery_mobile/constraints.dart';
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
      theme: ThemeData(
        fontFamily: 'SourceSansPro',
        primarySwatch: Colors.blue,
        primaryColor: kPrimary,
        scaffoldBackgroundColor: Color(0xFFF0F2F5),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NavScreen(),
    );
  }

  Widget checkAuthorize() {
    // return token != null ? HomeScreen() : LoginScreen();
    return FutureBuilder(
        future: getToken(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          // AccountDAO dao = AccountDAO();
          String token = snapshot.data;
          requestObj.setToken = token;
          // cho nay co can gui token lai cho server khong
          // neu khong thi lay thong tin user tu token ma thoi
          return token != null ? NavScreen() : LoginScreen();
        });
    // return FutureBuilder<SharedPreferences>(
    //   future: SharedPreferences.getInstance(),
    //   builder:
    //       (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
    //     PushNotificationService ps = new PushNotificationService();
    //     ps.init(navigatorKey.currentState.overlay.context);
    //     if (snapshot.hasData) {
    //       String user = snapshot.data.getString("USER");
    //       if (user != null) {
    //         return HomeScreen();
    //       }
    //     }
    //     return LoginScreen();
    //   },
    // );
  }
}
