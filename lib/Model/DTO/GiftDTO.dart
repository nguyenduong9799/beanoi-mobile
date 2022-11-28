class GiftDTO {
  int id;
  int userId;
  String userName;
  String voucherCode;
  String description;
  bool isUsed;
  String name;
  int menuId;
  String senderName;
  String createdAt;
  Voucher voucher;
  VoucherInfo voucherInfo;

  GiftDTO(
      {this.id,
      this.userId,
      this.userName,
      this.voucherCode,
      this.description,
      this.isUsed,
      this.name,
      this.menuId,
      this.senderName,
      this.createdAt,
      this.voucher,
      this.voucherInfo});

  GiftDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    userId = json['user_id'] as int;
    userName = json['user_name'] as String;
    voucherCode = json['voucher_code'] as String;
    description = json['description'] as String;
    isUsed = json['is_used'];
    name = json['name'] as String;
    menuId = json['menu_id'] as int;
    senderName = json['sender_name'] as String;
    createdAt = json['created_at'] as String;
    voucher =
        json['voucher'] != null ? new Voucher.fromJson(json['voucher']) : null;
    voucherInfo = json['voucher_info'] != null
        ? new VoucherInfo.fromJson(json['voucher_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['voucher_code'] = this.voucherCode;
    data['description'] = this.description;
    data['is_used'] = this.isUsed;
    data['name'] = this.name;
    data['menu_id'] = this.menuId;
    data['sender_name'] = this.senderName;
    data['created_at'] = this.createdAt;
    if (this.voucher != null) {
      data['voucher'] = this.voucher.toJson();
    }
    if (this.voucherInfo != null) {
      data['voucher_info'] = this.voucherInfo.toJson();
    }
    return data;
  }

  static List<GiftDTO> fromList(dynamic jsonList) {
    var list = jsonList as List;
    return list.map((map) => GiftDTO.fromJson(map)).toList();
  }
}

class Voucher {
  String promotionId;
  String promotionTierId;
  String promotionName;
  String description;
  String promotionCode;
  String actionName;
  String voucherName;
  String imgUrl;
  String voucherCode;
  String isUsed;
  int menuId;
  String senderName;
  String startDate;
  String endDate;

  Voucher(
      {this.promotionId,
      this.promotionTierId,
      this.promotionName,
      this.description,
      this.promotionCode,
      this.actionName,
      this.voucherName,
      this.imgUrl,
      this.voucherCode,
      this.isUsed,
      this.menuId,
      this.senderName,
      this.startDate,
      this.endDate});

  Voucher.fromJson(Map<String, dynamic> json) {
    promotionId = json['promotion_id'];
    promotionTierId = json['promotion_tier_id'];
    promotionName = json['promotion_name'];
    description = json['description'];
    promotionCode = json['promotion_code'];
    actionName = json['action_name'];
    voucherName = json['voucher_name'];
    imgUrl = json['img_url'];
    voucherCode = json['voucher_code'];
    isUsed = json['is_used'];
    menuId = json['menu_id'];
    senderName = json['sender_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promotion_id'] = this.promotionId;
    data['promotion_tier_id'] = this.promotionTierId;
    data['promotion_name'] = this.promotionName;
    data['description'] = this.description;
    data['promotion_code'] = this.promotionCode;
    data['action_name'] = this.actionName;
    data['voucher_name'] = this.voucherName;
    data['img_url'] = this.imgUrl;
    data['voucher_code'] = this.voucherCode;
    data['is_used'] = this.isUsed;
    data['menu_id'] = this.menuId;
    data['sender_name'] = this.senderName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}

class VoucherInfo {
  int id;
  String productName;
  String productNameEng;
  double price;
  String picUrl;
  int catId;
  bool isAvailable;
  String code;
  int productType;
  int generalProductId;
  String description;
  int supplierId;

  VoucherInfo(
      {this.id,
      this.productName,
      this.productNameEng,
      this.price,
      this.picUrl,
      this.catId,
      this.isAvailable,
      this.code,
      this.productType,
      this.generalProductId,
      this.description,
      this.supplierId});

  VoucherInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    productName = json['product_name'] as String;
    productNameEng = json['product_name_eng'] as String;
    price = json['price'] as double;
    picUrl = json['pic_url'] as String;
    catId = json['cat_id'] as int;
    isAvailable = json['is_available'];
    code = json['code'] as String;
    productType = json['product_type'] as int;
    generalProductId = json['general_product_id'] as int;
    description = json['description'] as String;
    supplierId = json['supplier_id'] as int;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['product_name_eng'] = this.productNameEng;
    data['price'] = this.price;
    data['pic_url'] = this.picUrl;
    data['cat_id'] = this.catId;
    data['is_available'] = this.isAvailable;
    data['code'] = this.code;
    data['product_type'] = this.productType;
    data['general_product_id'] = this.generalProductId;
    data['description'] = this.description;
    data['supplier_id'] = this.supplierId;
    return data;
  }
}
