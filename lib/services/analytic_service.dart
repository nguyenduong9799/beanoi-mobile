import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();
  static AnalyticsService _instance;

  static AnalyticsService getInstance() {
    if (_instance == null) {
      _instance = AnalyticsService();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  // User properties tells us what the user is
  Future setUserProperties({@required String userId, String userRole}) async {
    await _analytics.setUserId(userId);
    await _analytics.setUserProperty(name: 'user_role', value: userRole);
    // property to indicate if it's a pro paying member
    // property that might tell us it's a regular poster, etc
  }

  Future logLogin(String method) async {
    print("LOG_LOGIN");
    await _analytics.logLogin(loginMethod: method);
  }

  Future logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  Future logOrderCreated({double total, bool hasImage}) async {
    await _analytics.logEvent(
      name: 'create_order',
      parameters: {'has_image': hasImage, "total": total},
    );
    print("Loged order");
  }
}
