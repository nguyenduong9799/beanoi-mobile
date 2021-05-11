import 'package:unidelivery_mobile/Model/DTO/index.dart';

class OrderStatus {
  int statusCode;
  String code;
  String message;
  OrderDTO order;

  OrderStatus({
    this.statusCode,
    this.code,
    this.message,
    this.order,
  });
}

enum OrderFilter { NEW, ORDERING, DONE }
