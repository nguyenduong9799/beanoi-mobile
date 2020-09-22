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

  @override
  String toString() {
    return 'ProductDTO{uid: $id, name: $name, price: $price, size: $size, quantity: $quantity, topping: $topping, description: $description, type: $type, atrributes: $atrributes}';
  }

  ProductDTO(
    this.id, {
    this.name,
    this.imageURL,
    this.price,
    this.size,
    this.quantity,
    this.topping = const ["Trân châu", "Bánh flan", "Thạch 7 màu"],
    this.description,
    this.type = 6,
    this.atrributes = const ["size", "đá", "đường"], this.listChild
  }); // balance. point;

  factory ProductDTO.fromJson(dynamic json){

    var listChildJson = json['productChilds'] as List;
    if(listChildJson != null){
      List<ProductDTO> listChild = listChildJson.map((e) => ProductDTO.fromJson(e)).toList();
      return ProductDTO(
          json["id"] as String,
          name: json['name'] as String,
          price: double.parse(json['price']),
          size: json['size'] as String,
          quantity: json['quantity'] as int,
          description: json['description'] as String,
          imageURL: json['imageURL'] as String,
          listChild: listChild
      );
    }

    return ProductDTO(
        json["id"] as String,
        name: json['name'] as String,
        price: double.parse(json['price']),
        size: json['size'] as String,
        quantity: json['quantity'] as int,
        description: json['description'] as String,
        type: json['type'] as int,
        imageURL: json['imageURL'] as String,
    );
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
