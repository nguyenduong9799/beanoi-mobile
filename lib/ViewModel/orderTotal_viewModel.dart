import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/order_status.dart';
import 'package:unidelivery_mobile/route_constraint.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';
import '../constraints.dart';

class OrderViewModel extends BaseModel {
  OrderViewModel() {}

  Future<Cart> get cart async {
    return await getCart();
  }

  Future<void> orderCart(String orderNote) async {
    showLoadingDialog();
    OrderDAO dao = new OrderDAO();
    OrderStatus result = await dao.createOrders(orderNote);
    if (result == OrderStatus.Success) {
      await deleteCart();
      hideDialog();
      Get.back(result: true);
    } else if (result == OrderStatus.Fail) {
      hideDialog();
      showStatusDialog(
          Icon(
            Icons.error_outline,
            color: kFail,
          ),
          "Thất bại :(",
          "Vui lòng thử lại sau");
    } else if (result == OrderStatus.NoMoney) {
      hideDialog();
      showStatusDialog(
          Icon(
            Icons.error_outline,
            color: kFail,
          ),
          "Thất bại :(",
          "Có đủ tiền đâu mà mua (>_<)");
    } else if (result == OrderStatus.Timeout){
      hideDialog();
      showStatusDialog(
          Icon(
            MaterialCommunityIcons.timer_off,
            color: kFail,
          ),
          "Thất bại :(",
          "Hết giờ rồi bạn ơi, mai đặt sớm nhen <3");
    } else if (result == OrderStatus.Network){
      hideDialog();
      Get.offNamed(RouteHandler.NETWORK_ERROR);
    }
  }
}
