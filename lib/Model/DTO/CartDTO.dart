import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';

class Cart {
  List<CartItem> items;
  // User info
  String orderNote;
  String storeName;

  Cart.get({this.items, this.orderNote, this.storeName});

  Cart() {
    items = List();
    storeName = "Uni Delivery";
  }

  factory Cart.fromJson(dynamic json) {
    List<CartItem> list = new List();
    if (json["items"] != null) {
      var itemJson = json["items"] as List;
      list = itemJson.map((e) => CartItem.fromJson(e)).toList();
    }
    return Cart.get(
      items: list,
      storeName: json['storeName'] as String,
      orderNote: json['orderNote'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    List listCartItem = items.map((e) => e.toJson()).toList();
    print("Items: " + listCartItem.toString());
    return {
      "items": listCartItem,
      "storeName": storeName,
      "orderNote": orderNote,
    };
  }

  bool get isEmpty => items != null && items.isEmpty;
  int itemQuantity() {
    int quantity = 0;
    for (CartItem item in items) {
      quantity += item.quantity;
    }
    return quantity;
  }

  void addItem(CartItem item) {
    for (CartItem cart in items) {
      if (cart.findCartItem(item)) {
        cart.quantity += item.quantity;
        return;
      }
    }
    items.add(item);
  }

  void removeItem(CartItem item) {
    items.removeWhere((element) =>
        element.findCartItem(item) && element.quantity == item.quantity);
  }

  void updateQuantity(CartItem item) {
    for (CartItem cart in items) {
      if (cart.findCartItem(item)) {
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

  bool findCartItem(CartItem item) {
    bool found = true;
    if (this.products.length != item.products.length) {
      return false;
    }
    for (int i = 0; i < this.products.length; i++) {
      if (item.products[i].id != this.products[i].id) found = false;
    }
    if (item.description != this.description) {
      found = false;
    }
    return found;
  }

  factory CartItem.fromJson(dynamic json) {
    List<ProductDTO> list = new List();
    if (json["products"] != null) {
      var itemJson = json["products"] as List;
      list = itemJson.map((e) => ProductDTO.fromJson(e)).toList();
    }
    return CartItem(
      list,
      json['description'] as String,
      json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    List listProducts = products.map((e) => e.toJson()).toList();
    print("Products: " + listProducts.toString());
    return {
      "products": listProducts,
      "description": description,
      "quantity": quantity
    };
  }
}
