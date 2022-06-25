// "promotionId": "8c24b0a1-58b8-447f-b726-c217816da839",
//       "promotionTierId": "6899bcec-daf4-4881-95a4-89aa8e083a2b",
//       "promotionName": "[BeanOi] Test",
//       "promotionCode": "beanoi",
//       "actionName": "[BeanOi] Giảm 10K cho hóa đơn",
//       "voucherName": "[BeanOi] Test",
//       "imgUrl": "https://firebasestorage.googleapis.com/v0/b/promotion-engine-3a6dc.appspot.com/o/promo1.jpg?alt=media&token=d1ce7b18-3164-4d2a-af39-a05c55daf0bb",
//       "voucherCode": "beanoi0-9"

class VoucherDTO {
  final String promotionId;
  final String promotionTierId;
  final String promotionName;
  final String promotionCode;
  final String actionName;
  final String voucherName;
  final String imgUrl;
  final String voucherCode;
  final String startDate;
  final String endDate;
  final String description;

  VoucherDTO({
    this.promotionId,
    this.promotionTierId,
    this.promotionName,
    this.promotionCode,
    this.actionName,
    this.voucherName,
    this.imgUrl,
    this.voucherCode,
    this.startDate,
    this.endDate,
    this.description,
  });

  factory VoucherDTO.fromJson(dynamic json) {
    return VoucherDTO(
      promotionId: json['promotion_id'],
      promotionTierId: json['promotion_tier_id'],
      promotionName: json['promotion_name'],
      promotionCode: json['promotion_code'],
      actionName: json['action_name'],
      voucherName: json['voucher_name'],
      imgUrl: json['img_url'],
      voucherCode: json['voucher_code'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      description: json['description'],
    );
  }

  static List<VoucherDTO> fromList(dynamic jsonList) {
    var list = jsonList as List;
    return list.map((map) => VoucherDTO.fromJson(map)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> voucherJson = {
      'promotion_id': promotionId,
      'promotion_tier_id': promotionTierId,
      'promotion_name': promotionName,
      'promotion_code': promotionCode,
      'action_name': actionName,
      'voucher_name': voucherName,
      'img_url': imgUrl,
      'voucher_code': voucherCode,
      'start_date': startDate,
      'end_date': endDate,
      'description': description,
    };

    return voucherJson;
  }

  @override
  String toString() {
    // TODO: implement toString
    final promoCode = voucherCode?.split('-')[0];
    final voucherCodeStr = voucherCode?.split('-')[1];
    return {
      "promotionCode": promoCode,
      "voucherCode": voucherCodeStr,
    }.toString();
  }
}
