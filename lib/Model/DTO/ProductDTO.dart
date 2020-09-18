
class ProductDTO {
  final String uid, name;
  final double price;
  final String size;
  final int quantity;
  final List<String> topping;
  final String description;
  final int type;
  final Map<String, List<String>> atrributes;


  @override
  String toString() {
    return 'ProductDTO{uid: $uid, name: $name, price: $price, size: $size, quantity: $quantity, topping: $topping, description: $description, type: $type, atrributes: $atrributes}';
  }

  ProductDTO({this.uid, this.name, this.price, this.size, this.quantity,
      this.topping, this.description, this.type, this.atrributes}); // balance. point;


  factory ProductDTO.fromJson(dynamic json) => ProductDTO(
    uid: json["userId"] as String,
    name: json['name'] as String,
    price: json['price'] as double,
    size: json['size'] as String,
    quantity: json['quantity'] as int,
    topping: json['topping'] as List,
    description: json['description'] as String,
    type: json['type'] as int,
    atrributes: json['map'] as Map,
  );

  Map<String, dynamic> toJson() {
    return {
      "userId": uid,
      "name": name,
    };
  }
}