import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/order_status.dart';
import 'package:unidelivery_mobile/utils/index.dart';
import 'package:unidelivery_mobile/utils/request.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

import '../../route_constraint.dart';

class OrderDAO {
  Future<List<OrderListDTO>> getOrders(OrderFilter filter) async {
    final res = await request.get('/orders', queryParameters: {
      "status":
          filter == OrderFilter.ORDERING ? ORDER_NEW_STATUS : ORDER_DONE_STATUS
    });
    List<OrderListDTO> orderSummaryList;
    if (res.statusCode == 200) {
      orderSummaryList = OrderListDTO.fromList(res.data['data']);
    }
    return orderSummaryList;
  }

  Future<OrderDTO> getOrderDetail(int orderId) async {
    final res = await request.get(
      '/orders/$orderId',
    );
    OrderDTO orderDetail;
    if (res.statusCode == 200) {
      orderDetail = OrderDTO.fromJSON(res.data['data']);
    }
    return orderDetail;
  }

  Future<OrderStatus> createOrders(String note) async {
    try {
      Cart cart = await getCart();
      if (cart != null) {
        print("Request Note: " + note);
        cart.orderNote = note;
        final res = await request.post('/orders',
            queryParameters: {
              "brand-id": UNIBEAN_BRAND,
              "store-id": UNIBEAN_STORE
            },
            data: cart.toJsonAPi());
        if (res.statusCode == 200) {
          return OrderStatus.Success;
        }
      }
    } on DioError catch (e) {
      if(e.response == null) {
        return OrderStatus.Network;
      } else if (e.response.statusCode == 401) {
        await showStatusDialog(
            Icon(
              Icons.error_outline,
              color: kFail,
            ),
            "Lỗi",
            "Vui lòng đang nhập lại");

        Get.offAllNamed(RouteHandler.LOGIN);
      }
      else if (e.response.statusCode == 400) {
        if (e.response.data['code'] == 'ERR_BALANCE')
          return OrderStatus.NoMoney;
        return OrderStatus.Timeout;
      }
      return OrderStatus.Network;
    }
    return OrderStatus.Fail;
  }
}
