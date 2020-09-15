import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unidelivery_mobile/Model/DAO/AccountDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/View/home.dart';
import 'package:unidelivery_mobile/View/login.dart';
import 'package:unidelivery_mobile/View/order.dart';
import 'package:unidelivery_mobile/services/push_notification_service.dart';
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
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }

  Widget checkAuthorize() {
    // return token != null ? HomeScreen() : LoginScreen();
    return FutureBuilder(
        future: getToken(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          // AccountDAO dao = AccountDAO();
          String token = snapshot.data;
          // cho nay co can gui token lai cho server khong
          // neu khong thi lay thong tin user tu token ma thoi
          return token != null
              ? HomeScreen(user: AccountDTO(uid: '123', name: 'Hung Bui'))
              : LoginScreen();
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
