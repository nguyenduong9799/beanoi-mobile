import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DAO/BaseDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderAmountDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/order_status.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class OrderDAO extends BaseDAO {
  Future<List<OrderListDTO>> getOrders(OrderFilter filter,
      {int page, int size}) async {
    final res = await request.get('me/orders', queryParameters: {
      "order-status":
          filter == OrderFilter.NEW ? ORDER_NEW_STATUS : ORDER_DONE_STATUS,
      "size": size ?? DEFAULT_SIZE,
      "page": page ?? 1
    });
    List<OrderListDTO> orderSummaryList;
    if (res.statusCode == 200) {
      metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
      orderSummaryList = OrderListDTO.fromList(res.data['data']);
    }
    return orderSummaryList;
  }

  Future<OrderDTO> getOrderDetail(int orderId) async {
    final res = await request.get(
      'me/orders/$orderId',
    );
    OrderDTO orderDetail;
    if (res.statusCode == 200) {
      orderDetail = OrderDTO.fromJSON(res.data['data']);
    }
    return orderDetail;
  }

  Future<OrderAmountDTO> prepareOrder(int store_id, Cart cart) async {
    if (cart != null) {
      // print("Request Note: " + note);
      final res = await request.post('orders/prepare',
          queryParameters: {"store-id": store_id}, data: cart.toJsonAPi());
      if (res.statusCode == 200) {
        return OrderAmountDTO.fromJson(res.data['data']);
      }
      return null;
    }
    return null;
  }

  Future<bool> cancelOrder(int orderId, int storeId) async {
    final res = await request.put(
      '/stores/$storeId/orders/$orderId',
      data: ORDER_CANCEL_STATUS,
    );

    return res.statusCode == 200;
  }

  // TODO: nen dep cart ra ngoai truyen vao parameter
  Future<OrderStatus> createOrders(int store_id, Cart cart) async {
    try {
      if (cart != null) {
        // print("Request Note: " + note);
        final res = await request.post('/orders',
            queryParameters: {"location-id": store_id}, data: cart.toJsonAPi());
        return OrderStatus(
          statusCode: res.statusCode,
          code: res.data['code'],
          message: res.data['message'],
          order: OrderDTO.fromJSON(res.data['data']),
        );
      }
    } on DioError catch (e) {
      return OrderStatus(
          statusCode: e.response.statusCode,
          code: e.response.data['code'],
          message: e.response.data['message']);
    }
    return null;
  }

  Future<Map<String, dynamic>> getPayments() async {
    final res = await request.get("payments/methods");
    var jsonList = res.data['data'] as Map<String, dynamic>;
    return jsonList;
  }
}
