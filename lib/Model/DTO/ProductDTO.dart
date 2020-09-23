class ProductDTO {
  String id, name;
  double price;
  String description;
  int type;
  String imageURL;
  List<String> atrributes;
  List<ProductDTO> listChild;
  String catergory_id;
  String store_id;
  String store_name;
  bool extra;

  @override
  String toString() {
    return 'ProductDTO{uid: $id, name: $name, price: $price, description: $description, type: $type, atrributes: $atrributes}';
  }

  ProductDTO(this.id,
      {this.name,
      this.imageURL,
      this.price,
      this.description,
      this.type = 6,
      this.atrributes = const ["size", "đá", "đường"],
      this.listChild,
      this.catergory_id,
      this.extra = true}); // balance. point;

  factory ProductDTO.fromJson(dynamic json) {
    var listChildJson = json['productChilds'] as List;
    if (listChildJson != null && listChildJson.isNotEmpty) {
      List<ProductDTO> listChild =
          listChildJson.map((e) => ProductDTO.fromJson(e)).toList();
      return ProductDTO(json["id"] as String,
          name: json['name'] as String,
          price: double.parse(json['price'].toString()),
          description: json['description'] as String,
          imageURL: json['imageURL'] as String,
          listChild: listChild);
    }

    return ProductDTO(json["id"] as String,
        name: json['name'] as String,
        price: double.parse(json['price'].toString()),
        description: json['description'] as String,
        type: json['type'] as int,
        imageURL: json['imageURL'] as String,
        catergory_id: json['catergory_id'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "description": description,
      "type": type,
      "imageURL": imageURL,
      "catergory_id": catergory_id,
    };
  }

  static List<ProductDTO> fromList(List list) =>
      list.map((map) => ProductDTO.fromJson(map)).toList();
}
