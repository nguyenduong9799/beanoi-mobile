

class ProductDTO {
  String id, name;
  double price;
  String size;
  int quantity;
  List<String> topping;
  String description;
  int type;
  String imageURL;
  Map<String, List<String>> atrributes;

  @override
  String toString() {
    return 'ProductDTO{uid: $id, name: $name, price: $price, size: $size, quantity: $quantity, topping: $topping, description: $description, type: $type, atrributes: $atrributes}';
  }

  ProductDTO(this.id, {this.name, this.price, this.size, this.quantity,
      this.topping = const ["Trân châu", "Bánh flan", "Thạch 7 màu"], this.description = "Trà sữa là loại thức uống đa dạng được tìm thấy ở nhiều nền văn hóa, bao gồm một vài cách kết hợp giữa trà và sữa. Các loại thức uống khác nhau tùy thuộc vào lượng thành phần chính của mỗi loại, phương pháp pha chế, và các thành phần khác được thêm vào. Bột trà sữa pha sẵn là một sản phẩm được sản xuất hàng loạt.",
    this.type, this.atrributes = const {"size" : ["Size M", "Size L", "Size S"], "đá" : ["0%", "25%", "50%", "75%", "100%"], "đường" : ["0%", "25%", "50%", "75%", "100%"],}, this.imageURL}); // balance. point;


  factory ProductDTO.fromJson(Map<String, dynamic> map) =>
      ProductDTO(map["id"] as String,
          name: map["name"] as String,
          price: double.parse(map["price"]),
          imageURL: map["imageURL"] as String);


  static List<ProductDTO> fromList(List list) =>
      list.map((map) => ProductDTO.fromJson(map)).toList();
}