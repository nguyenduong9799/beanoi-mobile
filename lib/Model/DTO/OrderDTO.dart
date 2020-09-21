import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';

class OrderDTO {
  final String id;
  final int quantity;
  final double total;
  final OrderFilter status;
  final String orderTime;

  OrderDTO(this.id, {this.orderTime, this.quantity, this.total, this.status});

  factory OrderDTO.fromJSON(Map<String, dynamic> map) => OrderDTO(
        map["id"],
        quantity: map["quantity"],
        total: double.parse(map["total"]),
        orderTime: map["orderTime"],
        status: (map["status"] as String) == "ordering"
            ? OrderFilter.ORDERING
            : OrderFilter.DONE,
      );

  static List<OrderDTO> fromList(List<dynamic> list) =>
      list.map((e) => OrderDTO.fromJSON(e)).toList();
}
