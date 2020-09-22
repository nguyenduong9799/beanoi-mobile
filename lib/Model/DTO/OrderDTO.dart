import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';

class OrderDTO {
  final String id;

  final double total;
  final OrderFilter status;
  final String orderTime;

  OrderDTO(this.id, {this.orderTime, this.total, this.status});

  factory OrderDTO.fromJSON(Map<String, dynamic> map) => OrderDTO(
        map["id"],
        total: double.parse(map["total"]),
        orderTime: map["orderTime"],
        status: (map["status"] as String) == "ordering"
            ? OrderFilter.ORDERING
            : OrderFilter.DONE,
      );

  static List<OrderDTO> fromList(List<dynamic> list) =>
      list.map((e) => OrderDTO.fromJSON(e)).toList();
}

class OrderItemDTO {
  final String masterProductName;
  final String masterProductId;
  final double amount;
  final int quantity;
  final List productChilds;

  OrderItemDTO({
    this.masterProductName,
    this.masterProductId,
    this.amount,
    this.productChilds,
    this.quantity,
  });
}
