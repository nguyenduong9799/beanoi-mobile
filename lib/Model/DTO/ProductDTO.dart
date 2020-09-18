class ProductDTO {
  final String id;
  final String name;
  final String imageURL;
  final double price;

  ProductDTO(this.id, {this.name, this.imageURL, this.price});

  factory ProductDTO.fromJson(Map<String, dynamic> map) =>
      ProductDTO(map["id"] as String,
          name: map["name"] as String,
          price: double.parse(map["price"]),
          imageURL: map["imageURL"] as String);

  static List<ProductDTO> fromList(List list) =>
      list.map((map) => ProductDTO.fromJson(map)).toList();
}
