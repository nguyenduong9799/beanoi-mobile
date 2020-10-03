import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/View/index.dart';
import 'package:unidelivery_mobile/utils/index.dart';
import 'package:unidelivery_mobile/utils/request.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

import '../main.dart';

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
