import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get/get.dart' as Get;
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/route_constraint.dart';

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}

class ExpiredException extends AppException {
  ExpiredException([String message]) : super(message, "Token Expired: ");
}

class CustomInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) async {
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    return super.onError(err);
  }
}

// or new Dio with a BaseOptions instance.

class MyRequest {
  static BaseOptions options = new BaseOptions(
      baseUrl: 'https://beanapi.unibean.net/api/',
      // baseUrl: "http://13.212.101.182:8090/api/",
      headers: {
        Headers.contentTypeHeader: "application/json",
      },
      sendTimeout: 15000,
      receiveTimeout: 5000);
  Dio _inner;
  MyRequest() {
    _inner = new Dio(options);
    _inner.interceptors.add(
        DioCacheManager(CacheConfig(baseUrl: options.baseUrl)).interceptor);
    _inner.interceptors.add(CustomInterceptors());
    _inner.interceptors.add(InterceptorsWrapper(
      onResponse: (Response response) async {
        // Do something with response data
        return response; // continue
      },
      onError: (DioError e) async {
        // Do something with response
        print(e.response.toString());
        if (e.response.statusCode == 401) {
          await showStatusDialog("assets/images/global_error.png", "Lỗi",
              "Vui lòng đăng nhập lại");
          Get.Get.offAllNamed(RouteHandler.LOGIN);
        } else {
          throw e;
        }
        //continue
      },
    ));
  }

  Dio get request {
    return _inner;
  }

  set setToken(token) {
    options.headers["Authorization"] = "Bearer $token";
  }
}

final requestObj = new MyRequest();
final request = requestObj.request;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
