import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';

class Cart {
  List<CartItem> items;
  // User info
  String orderNote;

  Cart() {
    items = List();
  }

  bool get isEmpty => items != null && items.isEmpty;
  int get itemQuantity => items.length;

  void addItem(CartItem item) {
    items.add(item);
  }
}

class CartItem {
  ProductDTO masterProduct;
  int quantity;
  List<ProductDTO> productChild;

  CartItem(
    this.masterProduct,
    this.quantity,
    this.productChild,
  );
}