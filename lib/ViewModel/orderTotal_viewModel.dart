import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/order_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

import '../constraints.dart';
import '../locator.dart';

class OrderViewModel extends Model {
  NavigationService _navigationService = locator<NavigationService>();
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
      _navigationService.back(result: true);
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
    } else {
      hideDialog();
      showStatusDialog(
          Icon(
            MaterialCommunityIcons.timer_off,
            color: kFail,
          ),
          "Thất bại :(",
          "Hết giờ rồi bạn ơi, mai đặt sớm nhen <3");
    }
  }
}
