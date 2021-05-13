

import 'index.dart';

class OrderAmountDTO {
  double totalAmount;
  double finalAmount;
  double beanAmount;
  List<OtherAmount> others;
  Map<String, dynamic> message;

  OrderAmountDTO({
    this.totalAmount,
    this.others,
    this.finalAmount,
    this.beanAmount,
    this.message,
  });

  factory OrderAmountDTO.fromJson(dynamic json) {
    return OrderAmountDTO(
      totalAmount: json['total_amount'],
      finalAmount: json['final_amount'],
      others: (json["other_amounts"] as List)
          ?.map((otherAmountJSON) => OtherAmount.fromJSON(otherAmountJSON))
          ?.toList(),
      beanAmount: json['receive_bean'],
      message: json['message'],
    );
  }
}
