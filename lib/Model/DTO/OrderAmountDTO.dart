import 'package:unidelivery_mobile/Model/DTO/index.dart';

class OrderAmountDTO {
  double totalAmount;
  double finalAmount;
  double beanAmount;
  List<OtherAmount> others;

  OrderAmountDTO(
      {this.totalAmount, this.others, this.finalAmount, this.beanAmount});

  factory OrderAmountDTO.fromJson(dynamic json) {
    return OrderAmountDTO(
        totalAmount: json['total_amount'],
        finalAmount: json['final_amount'],
        others: (json["other_amounts"] as List)
            ?.map((otherAmountJSON) => OtherAmount.fromJSON(otherAmountJSON))
            ?.toList(),
        beanAmount: json['receive_bean']);
  }
}
