
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/constraints.dart';

class ProductDetailViewModel extends Model{

  int index = 0;
  Map<String, List<String>> content;
  List<String> option;
  int count = 1;
  Color minusColor = kBackgroundGrey[5];
  Color addColor = kBackgroundGrey[5];
  double price, total;
  Color buttonColor = kBackgroundGrey[5];
  Map<String, bool> extra;
  bool isExtra;



  ProductDetailViewModel(Map<String, List<String>> attribute, List<String> extra, this.price){
    content = attribute;
    option = new List<String>();
    isExtra = false;
    total = price * count;
    this.extra = new Map<String, bool>();

    for(int i = 0; i < content.keys.toList().length; i++){
      option.add("");
    }

    for(int i = 0; i < extra.length; i++){
      this.extra[extra[i]] = false;
    }
  }

  void addQuantity(){
    if(addColor == kPrimary){
      if(count == 1){
        minusColor = kPrimary;
      }
      count++;
      total = price * count;
      notifyListeners();
    }
  }

  void deleteQuantity(){
    count = 0;
    notifyListeners();
  }

  void minusQuantity(){
    if(count > 1){
      count--;
      if(count == 1){
        minusColor = kBackgroundGrey[5];
      }
      total = price * count;
      notifyListeners();
    }
  }

  void changeAtrribute(String e){
    bool order = true;
    option[index] = e;
    for(String s in option){
      if(s.isEmpty){
        order = false;
      }
    }
    if(order){
      addColor = kPrimary;
      buttonColor = kPrimary;
    }
    notifyListeners();
  }

  void changeIndex(int index){
    this.index = index;
    if(index == content.keys.toList().length){
      isExtra = true;
    }
    else isExtra = false;
    notifyListeners();
  }

  void changExtra(bool value, int i){
    extra[extra.keys.elementAt(i)] = value;
    notifyListeners();
  }



}