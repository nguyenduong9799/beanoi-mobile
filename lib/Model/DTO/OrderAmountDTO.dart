class OrderAmountDTO {
  double totalAmount;
  double deliveryAmount;
  double finalAmount;

  OrderAmountDTO({this.totalAmount, this.deliveryAmount, this.finalAmount});

  factory OrderAmountDTO.fromJson(dynamic json) {
    double delivery = 0;
    var listOthers = json['other_amounts'] as List;
    if (listOthers != null) {
      listOthers.forEach((element) {
        if (element['name'] == "Delivery") delivery = element['amount'];
      });
    }
    return OrderAmountDTO(
        totalAmount: json['total_amount'], finalAmount: json['final_amount'], deliveryAmount: delivery);
  }
}