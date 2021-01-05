import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderAmountDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/order_status.dart';
import 'package:unidelivery_mobile/utils/request.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

class OrderDAO {
  Future<List<OrderListDTO>> getOrders(OrderFilter filter) async {
    final res = await request.get('/supplier-orders', queryParameters: {
      "delivery-status":
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
      '/supplier-orders/$orderId',
    );
    OrderDTO orderDetail;
    if (res.statusCode == 200) {
      orderDetail = OrderDTO.fromJSON(res.data['data']);
    }
    return orderDetail;
  }

  Future<OrderAmountDTO> prepareOrder(
      String note, int store_id, int payment) async {
    Cart cart = await getCart();
    if (cart != null) {
      // print("Request Note: " + note);
      cart.orderNote = note;
      cart.payment = payment;
      print(cart.toJsonAPi());
      final res = await request.post('/supplier-orders/prepare',
          queryParameters: {"store-id": store_id}, data: cart.toJsonAPi());
      print(cart.toString());
      if (res.statusCode == 200) {
        return OrderAmountDTO.fromJson(res.data['data']);
      }
      return null;
    }
    return null;
  }

  // TODO: nen dep cart ra ngoai truyen vao parameter
  Future<OrderStatus> createOrders(
      String note, int store_id, int payment) async {
    try {
      Cart cart = await getCart();
      if (cart != null) {
        // print("Request Note: " + note);
        cart.orderNote = note;
        cart.payment = payment;
        print(cart.toJsonAPi());
        final res = await request.post('/supplier-orders',
            queryParameters: {"store-id": store_id}, data: cart.toJsonAPi());
        if (res.statusCode == 200) {
          return OrderStatus.Success;
        }
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        print("Code: " + e.response.data['code'].toString());
        if (e.response.data['code'] == 'ERR_BALANCE')
          return OrderStatus.NoMoney;
        return OrderStatus.Timeout;
      }
      return OrderStatus.Fail;
    }
    return OrderStatus.Fail;
  }
}
