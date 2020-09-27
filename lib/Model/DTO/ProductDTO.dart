import 'package:unidelivery_mobile/constraints.dart';

class ProductDTO {
  int id;
  String name;
  double price;
  String description;
  int type;
  String imageURL;
  List<String> atrributes;
  List<ProductDTO> listChild;
  int catergoryId;
  int storeId;
  String storeName;

  @override
  String toString() {
    return 'ProductDTO{id: $id, name: $name, price: $price, description: $description, type: $type, imageURL: $imageURL, atrributes: $atrributes, listChild: $listChild, catergoryId: $catergoryId, storeId: $storeId, storeName: $storeName}';
  }

  ProductDTO(
    this.id, {
    this.name,
    this.imageURL,
    this.price,
    this.description,
    this.type,
    this.atrributes,
    this.listChild,
    this.catergoryId,
    this.storeId,
    this.storeName,
  }); // balance. point;

  factory ProductDTO.fromJson(dynamic json) {
    var type = json['product_type'] as int;
    if (type == MASTER_PRODUCT) {
      var listChildJson = json['child_products'] as List;
      List<ProductDTO> listChild =
          listChildJson.map((e) => ProductDTO.fromJson(e)).toList();
      var listDynamic = json['attributes'] as List;
      var attributes = listDynamic.cast<String>().toList();
      return ProductDTO(
        json["product_in_menu_id"],
        name: json['product_name'] as String,
        price: double.parse(json['price'].toString()),
        description: json['description'] as String,
        type: type,
        imageURL: json['pic_url'] as String,
        atrributes: attributes,
        listChild: listChild,
        catergoryId: json['category_id'],
      );
    }

    return ProductDTO(
      json["product_in_menu_id"],
      name: json['product_name'] as String,
      price: double.parse(json['price'].toString()),
      description: json['description'] as String,
      type: type,
      imageURL: json['pic_url'] as String,
      catergoryId: json['category_id'],
      storeId: json['storeId'],
      storeName: json['storeName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    if (type == MASTER_PRODUCT) {
      List listProducts = listChild.map((e) => e.toJson()).toList();
      return {
        "product_in_menu_id": id,
        "product_name": name,
        "price": price,
        "description": description,
        "product_type": type,
        "pic_url": imageURL,
        "catergory_id": catergoryId,
        "child_products": listProducts,
        "attributes": atrributes
      };
    }
    return {
      "product_in_menu_id": id,
      "product_name": name,
      "price": price,
      "description": description,
      "product_type": type,
      "pic_url": imageURL,
      "catergory_id": catergoryId,
      "storeName": storeName
    };
  }

  static List<ProductDTO> fromList(List list) =>
      list.map((map) => ProductDTO.fromJson(map)).toList();
}
