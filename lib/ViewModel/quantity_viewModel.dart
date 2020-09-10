

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class QuantityViewModel extends Model{
  int _count = 1;
  Color _minusColor = Colors.grey;
  Color _addColor = Colors.orange;

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
      _minusColor = Colors.orange;
    }
    count++;
    notifyListeners();
  }

  void minusQuantity(){
    if(count > 1){
      count--;
      if(count == 1){
        _minusColor = Colors.grey;
      }
      notifyListeners();
    }
  }

  Color get addColor => _addColor;

  set addColor(Color value) {
    _addColor = value;
  }
}