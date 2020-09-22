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

  void removeItem(CartItem item){
    items.removeWhere((element) => element.findCartItem(item) && element.quantity == item.quantity);
  }

  void updateQuantity(CartItem item){
    for(CartItem cart in items){
      if(cart.findCartItem(item)){
        cart.quantity = item.quantity;
      }
    }
  }


}

class CartItem {
  List<ProductDTO> products;
  String description;
  int quantity;

  CartItem(this.products, this.description, this.quantity);

  bool findCartItem(CartItem item){
    bool found = true;
    if(this.products.length != item.products.length){
      return false;
    }
    for(int i = 0; i < this.products.length; i++){
      if(item.products[i].id != this.products[i].id)
        found = false;
    }
    if(item.description != this.description){
      found = false;
    }
    return found;
  }
}
