import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';
import 'package:unidelivery_mobile/utils/request.dart';

class OrderDAO {
  Future<List<OrderDTO>> getOrders(OrderFilter filter) async {
    final res = await request.get(
      '/orders',
    );
    List<OrderDTO> orders;
    if (res.statusCode == 200) {
      orders = OrderDTO.fromList(res.data);
    }
    return orders;
  }
}
