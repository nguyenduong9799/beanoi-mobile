import 'dart:convert';

import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';

class NewsfeedDTO {
  String message;
  AccountDTO sender, receiver;
  List<ProductNewsfeedDTO> listProducts;
  OrderDTO order;
  String createAt;
  String feedType;
  bool isNewFeed;

  NewsfeedDTO(
      {this.message,
      this.sender,
      this.receiver,
      this.listProducts,
      this.order,
      this.createAt,
      this.feedType,
      this.isNewFeed});

  factory NewsfeedDTO.fromJson(dynamic json) {
    return NewsfeedDTO(
        message: json['message'],
        sender: AccountDTO.fromJson(json['sender']),
        receiver: json['receiver'] == {}
            ? null
            : AccountDTO.fromJson(json['receiver']),
        listProducts: ProductNewsfeedDTO.fromList(json['list_products']),
        createAt: json['created_at'],
        feedType: json['feed_type'],
        isNewFeed: false);
  }

  static fromList(data) {
    var list = data as List;
    return list.map((map) => NewsfeedDTO.fromJson(map)).toList();
  }
}

class ProductNewsfeedDTO {
  int productId;
  String productName;
  int quantity;
  String supplierStoreName;
  int supplierStoreId;
  int categoryId;
  bool isAvailable;
  String productCode;
  int productTypeId;

  ProductNewsfeedDTO({
    this.productId,
    this.productName,
    this.quantity,
    this.supplierStoreName,
    this.supplierStoreId,
    this.categoryId,
    this.isAvailable,
    this.productCode,
    this.productTypeId,
  });

  ProductNewsfeedDTO.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    quantity = json['quantity'];
    supplierStoreName = json['supplier_store_name'];
    supplierStoreId = json['supplier_store_id'];
    categoryId = json['category_id'];
    isAvailable = json['is_available'];
    productCode = json['product_code'];
    productTypeId = json['product_type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['quantity'] = this.quantity;
    data['supplier_store_name'] = this.supplierStoreName;
    data['supplier_store_id'] = this.supplierStoreId;
    data['category_id'] = this.categoryId;
    data['is_available'] = this.isAvailable;
    data['product_code'] = this.productCode;
    data['product_type_id'] = this.productTypeId;
    return data;
  }

  static fromList(data) {
    var list = data as List;
    return list.map((map) => ProductNewsfeedDTO.fromJson(map)).toList();
  }
}
