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
  bool extra;

  @override
  String toString() {
    return 'ProductDTO{uid: $id, name: $name, price: $price, description: $description, type: $type, atrributes: $atrributes}';
  }

  ProductDTO(
    this.id, {
    this.name,
    this.imageURL,
    this.price,
    this.description,
    this.type = 6,
    this.atrributes = const ["size", "đá", "đường"],
    this.listChild,
    this.catergoryId,
    this.extra = true,
    this.storeId,
    this.storeName,
  }); // balance. point;

  factory ProductDTO.fromJson(dynamic json) {
    var listChildJson = json['productChilds'] as List;
    if (listChildJson != null && listChildJson.isNotEmpty) {
      List<ProductDTO> listChild =
          listChildJson.map((e) => ProductDTO.fromJson(e)).toList();
      return ProductDTO(
        json["product_in_menu_id"],
        name: json['product_name'] as String,
        price: double.parse(json['price'].toString()),
        description: json['description'] as String,
        type: json['product_type'] as int,
        imageURL: json['pic_url'] as String,
        listChild: listChild,
      );
    }

    return ProductDTO(
      json["product_in_menu_id"],
      name: json['product_name'] as String,
      price: double.parse(json['price'].toString()),
      description: json['description'] as String,
      type: json['product_type'] as int,
      imageURL: json['pic_url'] as String,
      catergoryId: json['extra_category_id'],
      storeId: json['storeId'],
      storeName: json['storeName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "description": description,
      "type": type,
      "imageURL": imageURL,
      "catergory_id": catergoryId,
    };
  }

  static List<ProductDTO> fromList(List list) =>
      list.map((map) => ProductDTO.fromJson(map)).toList();
}
