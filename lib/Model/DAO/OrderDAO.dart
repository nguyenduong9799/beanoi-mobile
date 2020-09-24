import 'package:dio/dio.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';
import 'package:unidelivery_mobile/constraints.dart';
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

  Future<bool> createOrders(String note) async {
    Cart cart = await getCart();
    if (cart != null) {
      cart.orderNote = note;
      final res = await request.post('/orders',
          queryParameters: {"brand-id": UNIBEAN_STORE}, data: cart.toJsonAPi());
      if (res.statusCode == 200) {
        return true;
      }
    }

    return false;
  }
}
