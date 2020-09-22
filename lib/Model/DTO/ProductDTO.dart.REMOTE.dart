class ProductDTO {
  String id, name;
  double price;
  String size;
  int quantity;
  List<String> topping;
  String description;
  int type;
  String imageURL;
  List<String> atrributes;
  List<ProductDTO> listChild;
  String catergory_id;
  String store_id;
  String store_name;

  @override
  String toString() {
    return 'ProductDTO{uid: $id, name: $name, price: $price, size: $size, quantity: $quantity, topping: $topping, description: $description, type: $type, atrributes: $atrributes}';
  }

  ProductDTO(this.id,
      {this.name,
      this.imageURL,
      this.price,
      this.size,
      this.quantity,
      this.topping = const ["Trân châu", "Bánh flan", "Thạch 7 màu"],
      this.description,
      this.type = 6,
      this.atrributes = const ["size", "đá", "đường"],
      this.listChild,
      this.catergory_id,
      this.store_id,
      this.store_name}); // balance. point;

  factory ProductDTO.fromJson(dynamic json) {
    var listChildJson = json['productChilds'] as List;
    if (listChildJson != null) {
      List<ProductDTO> listChild =
          listChildJson.map((e) => ProductDTO.fromJson(e)).toList();
      return ProductDTO(json["id"] as String,
          name: json['name'] as String,
          price: double.parse(json['price'].toString()),
          size: json['size'] as String,
          quantity: json['quantity'] as int,
          description: json['description'] as String,
          imageURL: json['imageURL'] as String,
          listChild: listChild);
    }

    return ProductDTO(json["id"] as String,
        name: json['name'] as String,
        price: double.parse(json['price']),
        size: json['size'] as String,
        quantity: json['quantity'] as int,
        description: json['description'] as String,
        type: json['type'] as int,
        imageURL: json['imageURL'] as String,
        store_id: json["store_id"] as String,
        store_name: json["store_name"] as String,
        catergory_id: json['catergory_id'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": id,
      "name": name,
    };
  }

  static List<ProductDTO> fromList(List list) =>
      list.map((map) => ProductDTO.fromJson(map)).toList();
}
