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
  final String promotionName;
  final String voucherName;
  final String imgUrl;
  final String voucherCode;

  VoucherDTO(
      {this.promotionId,
      this.promotionName,
      this.voucherName,
      this.imgUrl,
      this.voucherCode});

  factory VoucherDTO.fromJson(dynamic json) {
    return VoucherDTO(
      promotionId: json['promotion_id'],
      promotionName: json['promotion_name'],
      voucherName: json['voucher_name'],
      imgUrl: json['img_url'],
      voucherCode: json['voucher_code'],
    );
  }

  static List<VoucherDTO> fromList(dynamic jsonList) {
    var list = jsonList as List;
    return list.map((map) => VoucherDTO.fromJson(map)).toList();
  }

  @override
  String toString() {
    // TODO: implement toString
    final promoCode = voucherCode;
    final voucherCodeStr = voucherCode;
    return {
      "promotionCode": promoCode,
      "voucherCode": voucherCodeStr,
    }.toString();
  }
}
