
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/constraints.dart';

class ProductDetailViewModel extends Model{

  int index = 0;
  //List product không ảnh hưởng giá
  Map<String, List<String>> content;
  //List choice bắt buộc
  List<String> option;
  int count = 1;
  Color minusColor = kBackgroundGrey[5];
  Color addColor = kBackgroundGrey[5];
  double price, total;
  bool order = false;
  //List choice option
  Map<String, bool> extra;
  //Bật cờ để đổi radio thành checkbox
  bool isExtra;
  //List size
  List<ProductDTO> listChild;


  ProductDetailViewModel(ProductDTO dto){

    content = dto.atrributes;
    option = new List<String>();
    isExtra = false;

    this.extra = new Map<String, bool>();
    listChild = dto.listChild;

    if(listChild.isNotEmpty)
      this.price = dto.price;

    if(listChild.isNotEmpty)
      option.add("");

    for(int i = 0; i < content.keys.toList().length; i++){
      option.add("");
    }

    for(int i = 0; i < dto.topping.length; i++){
      this.extra[dto.topping[i]] = false;
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
      total  = price * count;
      notifyListeners();
    }
  }

  void changeAtrribute(String e){
    order = true;
    option[index] = e;
    if(index == 0){
      for(ProductDTO dto in listChild){
        if(dto.id == e){
          price = dto.price;
          total = price * count;
        }
      }
    }
    for(String s in option){
      if(s.isEmpty){
        order = false;
      }
    }
    if(order){
      addColor = kPrimary;
    }
    notifyListeners();
  }

  void changeIndex(int index){
    this.index = index;
    if(index == content.keys.toList().length + 1){
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