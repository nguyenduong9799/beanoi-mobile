import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/utils/request.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

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

  Future<int> createOrders(String note) async {
    try {
      Cart cart = await getCart();
      if (cart != null) {
        print("Request Note: " + note);
        cart.orderNote = note;
        final res = await request.post('/orders',
            queryParameters: {"brand-id": UNIBEAN_STORE},
            data: cart.toJsonAPi());
        if (res.statusCode == 200) {
          return SUCCESS;
        }
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return NOT_ENOUGH_MONEY;
      }

      return FAIL;
    }

    return FAIL;
  }
}
