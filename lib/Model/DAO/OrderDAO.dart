import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';
import 'package:unidelivery_mobile/utils/request.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

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

  Future<bool> createOrders() async {
    Cart cart = await getCart();
    if(cart != null){
      final res = await request.post(
          '/api/orders', queryParameters: {"brand-id": },data: cart.toJsonAPi()
      );
      if (res.statusCode == 200) {
        return true;
      }
    }

    return false;
  }
}
