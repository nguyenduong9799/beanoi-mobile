import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';

class OrderDTO {
  final int id;

  final double total;
  final OrderFilter status;
  final String orderTime;
  final List<OrderItemDTO> orderItems;

  OrderDTO(
    this.id, {
    this.orderTime,
    this.total,
    this.status,
    this.orderItems,
  });

  factory OrderDTO.fromJSON(Map<String, dynamic> map) => OrderDTO(
        map["rent_id"],
        total: map["final_amount"],
        orderTime: map["check_in_date"],
        status: (map["delivery_status"]) == 0
            ? OrderFilter.ORDERING
            : OrderFilter.DONE,
        orderItems: OrderItemDTO.fromList(map["list_order_details"]),
      );

  static List<OrderDTO> fromList(List list) =>
      list?.map((e) => OrderDTO.fromJSON(e))?.toList();
}

class OrderItemDTO {
  final String masterProductName;
  final String masterProductId;
  final double amount;
  final int quantity;
  final List<OrderItemDTO> productChilds;

  OrderItemDTO({
    this.masterProductName,
    this.masterProductId,
    this.amount,
    this.productChilds,
    this.quantity,
  });

  factory OrderItemDTO.fromJSON(Map<String, dynamic> map) => OrderItemDTO(
        masterProductName: map["product_name"],
        quantity: map["quantity"],
        amount: map["final_amount"],
        productChilds: OrderItemDTO.fromList(map["list_of_childs"]),
      );

  static List<OrderItemDTO> fromList(List list) =>
      list?.map((e) => OrderItemDTO.fromJSON(e))?.toList();
}

class OrderListDTO {
  final checkInDate;
  final List<OrderDTO> orders;

  OrderListDTO(this.checkInDate, this.orders);

  factory OrderListDTO.fromJSON(Map<String, dynamic> map) => OrderListDTO(
        map["check_in_date"],
        OrderDTO.fromList(map["list_of_orders"]),
      );

  static List<OrderListDTO> fromList(List list) =>
      list?.map((e) => OrderListDTO.fromJSON(e))?.toList();
}
