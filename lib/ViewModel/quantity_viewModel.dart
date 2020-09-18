

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/constraints.dart';

class QuantityViewModel extends Model{
  int _count = 1;
  Color _minusColor = kBackgroundGrey[5];
  Color _addColor = kPrimary;
  double _price, total;


  QuantityViewModel(this._price){
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