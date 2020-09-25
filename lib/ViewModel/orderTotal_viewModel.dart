import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

class OrderViewModel extends Model {
  OrderViewModel() {}

  Future<Cart> get cart async {
    return await getCart();
  }
}
