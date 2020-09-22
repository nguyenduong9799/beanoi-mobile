import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';

Future<bool> setFCMToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('FCMToken', value);
}

Future<String> getFCMToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('FCMToken');
}

Future<bool> setToken(String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('token', value);
}

Future<String> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<Cart> setCart(Cart cart) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('CART', jsonEncode(cart));
  return cart;
}

Future<Cart> getCart() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String encodedCart = prefs.getString('CART');
  if(encodedCart != null){
    Cart cart = jsonDecode(encodedCart);
    return cart;
  }
  return null;
}

Future<void> addItemToCart(List<ProductDTO> products, int quantity, String description) async {
  Cart cart = await getCart();
  if(cart == null){
    cart = new Cart();
  }
  cart.addItem(CartItem(products, description, quantity));
  setCart(cart);
}

Future<void> removeItemFromCart(List<ProductDTO> products, int quantity, String description) async {
  Cart cart = await getCart();
  if(cart == null){
    return;
  }
  cart.removeItem(CartItem(products, description, quantity));
  setCart(cart);
}



// Future<bool> setUser(A value) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.setString('token', value);
// }

// Future<String> getToken() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token');
// }
