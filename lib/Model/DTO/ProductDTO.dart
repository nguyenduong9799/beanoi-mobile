import 'package:flutter/foundation.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';


class ProductDTO {
  int id;
  int productInMenuId;
  String name;
  String description;
  int type;
  String imageURL;
  List<ProductDTO> listChild;
  int catergoryId;
  int supplierId;
  String supplierName;
  List<ProductDTO> extras;
  // update
  double price;
  bool hasExtra;
  Map attributes;
  int defaultQuantity;
  int min;
  int max;
  bool isAnd;
  int generalId;
  double minPrice;
  List<int> collections;
  int bean;

  @override
  String toString() {
    return 'ProductDTO{id: $id, name: $name, description: $description, type: $type, imageURL: $imageURL, listChild: $listChild, catergoryId: $catergoryId, supplierId: $supplierId, extras: $extras, prices: $price, hasExtra: $hasExtra, attributes: $attributes, defaultQuantity: $defaultQuantity, min: $min, max: $max, isAnd: $isAnd}';
  }

  ProductDTO(this.id,
      {this.name,
      this.productInMenuId,
      this.imageURL,
      this.description,
      this.type,
      this.listChild,
      this.catergoryId,
      this.price,
      this.supplierId,
      this.supplierName,
      this.attributes,
      this.hasExtra,
      this.defaultQuantity,
      this.isAnd,
      this.max,
      this.min,
      this.generalId,
      this.minPrice,
      this.collections,
      this.bean}); // balance. point;

  factory ProductDTO.fromJson(dynamic json) {
    var type = json['product_type_id'] as int;
    // List<int> listExtra = jsonExtra.cast<int>().toList();

    Map attribute = json['attributes'] as Map;
    if (attribute != null) {
      for (int i = 0; i < attribute.keys.length; i++) {
        if (attribute.values.elementAt(i) == null) {
          attribute.remove(attribute.keys.elementAt(i));
        }
      }
    }

    ProductDTO product = ProductDTO(json["product_id"],
        name: json['product_name'] as String,
        productInMenuId: json['product_in_menu_id'],
        description: json['description'] as String,
        type: type,
        imageURL: json['pic_url'] as String,
        catergoryId: json['category_id'],
        supplierId: json['supplier_id'] as int,
        supplierName: json['supplier_name'],
        // prices: prices,
        // extraId: listExtra,
        hasExtra: json['has_extra'] as bool,
        attributes: attribute,
        defaultQuantity: json["default"] ?? 0,
        min: json["min"] ?? 0,
        max: json["max"] ?? 0,
        generalId: json['general_product_id'],
        bean: json['bean']);

    if (json['collection_id'] != null) {
      var listCollection = json['collection_id'] as List;
      product.collections = listCollection.cast<int>().toList();
    }
    product.price = json["price"];

    switch (type) {
      case ProductType.MASTER_PRODUCT:
        var listChildJson = json['child_products'] as List ?? [];

        List<ProductDTO> listChild =
            listChildJson.map((e) => ProductDTO.fromJson(e)).toList();

        product.listChild = listChild;
        product.minPrice = json['min_price'];
        break;
      case ProductType.COMPLEX_PRODUCT:
        if (product.hasExtra != null && product.hasExtra) {
          var listExtraJson = json['extras'] as List;

          List<ProductDTO> listExtra =
              listExtraJson?.map((e) => ProductDTO.fromJson(e))?.toList();

          product.extras = listExtra;
        }
        break;
      default:
        break;
    }

    return product;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> prodJson = {
      "product_id": id,
      "product_in_menu_id": productInMenuId,
      "product_name": name,
      // price: double.parse(json['price'].toString()),
      "description": description,
      "product_type_id": type,
      "pic_url": imageURL,
      "catergory_id": catergoryId,
      "child_products": listChild,
      "supplier_id": supplierId,
      "supplier_name": supplierName,
      "hasExtra": hasExtra,
      "attributes": attributes,
      "default": defaultQuantity,
      "min": min,
      "max": max,
      "extras": extras,
      "general_product_id": generalId,
      "min_price": minPrice,
      "collection_id": collections,
      "price": price,
      "bean": bean
    };

    return prodJson;
  }

  static List<ProductDTO> fromList(dynamic jsonList) {
    var list = jsonList as List;
    return list.map((map) => ProductDTO.fromJson(map)).toList();
  }

  ProductDTO getChildByAttributes(Map attributes) {
    return this
        .listChild
        .firstWhere((child) => mapEquals(child.attributes, attributes));
  }
}
