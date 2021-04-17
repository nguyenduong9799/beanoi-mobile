import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';

Future<bool> setIsFirstOnboard(bool isFirstOnboard) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool('isFirstOnBoard', isFirstOnboard);
}

Future<bool> getIsFirstOnboard() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isFirstOnBoard');
}

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
  prefs.setString('CART', jsonEncode(cart.toJson()));
  return cart;
}

Future<Cart> getCart() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String encodedCart = prefs.getString('CART');
  if (encodedCart != null) {
    Cart cart = Cart.fromJson(jsonDecode(encodedCart));
    return cart;
  }
  return null;
}

Future<void> addItemToCart(CartItem item) async {
  Cart cart = await getCart();
  if (cart == null) {
    cart = new Cart();
  }
  cart.addItem(item);
  setCart(cart);
}

Future<bool> removeItemFromCart(CartItem item) async {
  Cart cart = await getCart();
  if (cart == null) {
    return false;
  }
  cart.removeItem(item);

  if (cart.items.length == 0) {
    deleteCart();
    return true;
  } else {
    setCart(cart);
    return false;
  }
}

Future<void> deleteCart() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("CART");
}

Future<void> updateItemFromCart(CartItem item) async {
  Cart cart = await getCart();
  if (cart == null) {
    return;
  }
  cart.updateQuantity(item);
  setCart(cart);
}

Future<void> setStore(CampusDTO dto) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (dto != null) {
    print(dto.toJson().toString());
    prefs.setString('STORE', jsonEncode(dto?.toJson()));
  }
}

Future<CampusDTO> getStore() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String encodedCart = prefs.getString('STORE');
  if (encodedCart != null) {
    return CampusDTO.fromJson(jsonDecode(encodedCart));
  }
  return null;
}

Future<void> removeALL() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await setIsFirstOnboard(false);
}

// Future<bool> setUser(A value) async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.setString('token', value);
// }

// Future<String> getToken() async {
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getString('token');
// }
