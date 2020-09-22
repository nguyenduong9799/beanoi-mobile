

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/constraints.dart';

class OrderViewModel extends Model{
  int _count;
  Color _minusColor;
  Color _addColor;
  double _price, total;


  OrderViewModel(this._price, this._count){
    if(count > 1){
      _minusColor = kPrimary;
    }
    else _minusColor = kBackgroundGrey[5];
    _addColor = kPrimary;
    total = _price * count;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  int get count => _count;

  set count(int value) {
    _count = value;
  }


  Color get minusColor => _minusColor;

  set minusColor(Color value) {
    _minusColor = value;
  }

  void addQuantity(){
    if(count == 1){
      _minusColor = kPrimary;
    }
    count++;
    total = price * count;
    notifyListeners();
  }

  void deleteQuantity(){
    count = 0;
    notifyListeners();
  }

  void minusQuantity(){
    if(count > 1){
      count--;
      if(count == 1){
        _minusColor = kBackgroundGrey[5];
      }
      total = price * count;
      notifyListeners();
    }
  }

  Color get addColor => _addColor;

  set addColor(Color value) {
    _addColor = value;
  }
}