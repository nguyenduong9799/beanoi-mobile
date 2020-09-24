import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class OrderDAO {
  Future<List<OrderListDTO>> getOrders(OrderFilter filter) async {
    final res = await request.get(
      '/orders',
    );
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
}
