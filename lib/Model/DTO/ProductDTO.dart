import 'package:unidelivery_mobile/constraints.dart';

class ProductDTO {
  int id;
  String name;
  double price;
  String description;
  int type;
  String imageURL;
  List<ProductChild> listChild;
  int catergoryId;
  List<int> extraId;
  String supplierId;

  @override
  String toString() {
    return 'ProductDTO{id: $id, name: $name, price: $price, description: $description, type: $type, imageURL: $imageURL, listChild: $listChild, catergoryId: $catergoryId, extraId: $extraId}';
  }

  ProductDTO(this.id,
      {this.name,
      this.imageURL,
      this.price,
      this.description,
      this.type,
      this.listChild,
      this.catergoryId,
      this.extraId,
      this.supplierId}); // balance. point;

  factory ProductDTO.fromJson(dynamic json) {
    var type = json['product_type'] as int;
    var jsonExtra = json['extra_category_id'] as List;
    List<int> listExtra = jsonExtra.cast<int>().toList();
    if (type == MASTER_PRODUCT) {
      var listChildJson = json['child_products'] as List;

      List<ProductChild> listChild =
          listChildJson.map((e) => ProductChild.fromJson(e)).toList();

      return ProductDTO(json["product_in_menu_id"],
          name: json['product_name'] as String,
          price: double.parse(json['price'].toString()),
          description: json['description'] as String,
          type: type,
          imageURL: json['pic_url'] as String,
          listChild: listChild,
          catergoryId: json['category_id'],
          extraId: listExtra,
          supplierId: json['supplier_id'] as String
      );
    }

    return ProductDTO(json["product_in_menu_id"],
        name: json['product_name'] as String,
        price: double.parse(json['price'].toString()),
        description: json['description'] as String,
        type: type,
        imageURL: json['pic_url'] as String,
        catergoryId: json['category_id'],
        supplierId: json['supplier_id'] as String,
        extraId: listExtra);
  }

  Map<String, dynamic> toJson() {
    print('Product: '  + this.toString());
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
        "extra_category_id": extraId,
        "supplier_id": supplierId
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
      "supplier_id": supplierId,
      "extra_category_id": extraId
    };
  }

  static List<ProductDTO> fromList(dynamic jsonList){
    var list = jsonList as List;
    return list.map((map) => ProductDTO.fromJson(map)).toList();
  }

}

class ProductChild{
  String attribute;
  List<ProductDTO> list;

  ProductChild({this.attribute, this.list});

  Map<String, dynamic> toJson(){
    List listProducts = list.map((e) => e.toJson()).toList();
    return {
      "attribute_name" : attribute,
      "products": listProducts
    };
  }

  factory ProductChild.fromJson(dynamic json){
    List<ProductDTO> listProducts = ProductDTO.fromList(json['products']);
    return ProductChild(
      attribute: json["attribute_name"] as String,
      list: listProducts,
    );
  }

}
