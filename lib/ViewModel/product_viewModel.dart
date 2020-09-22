
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/constraints.dart';

class ProductDetailViewModel extends Model{

  int unaffectIndex = 0;

  int affectIndex = 0;
  //List product không ảnh hưởng giá
  Map<String, List<String>> unaffectPriceContent;
  //List choice bắt buộc không ảnh hưởng giá
  Map<String, String> unaffectPriceChoice;
  //List product ảnh hưởng giá
  Map<String, List<ProductDTO>> affectPriceContent;
  //List choice bắt buộc không ảnh hưởng giá
  Map<String, String> affectPriceChoice;
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



  ProductDetailViewModel(ProductDTO dto){

    isExtra = false;

    this.extra = new Map<String, bool>();

    this.unaffectPriceContent = new Map<String, List<String>>();
    this.affectPriceContent = new Map();

    this.unaffectPriceChoice = new Map<String, String>();
    this.affectPriceChoice = new Map<String, String>();
    //
    if(dto.type != 6){
      this.price = dto.price;
      this.total = price * count;
    }
    else{
      for(String s in dto.atrributes){
        if(s.toUpperCase() == "ĐÁ" || s.toUpperCase() == "ĐƯỜNG"){
          unaffectPriceContent[s] = ["0%", "25%", "50%", "75%", "100%"];
          unaffectPriceChoice[s] = "";
        }
        else{
         affectPriceContent[s] = dto.listChild;
         affectPriceChoice[s] = "";
        }
      }
    }


    if(dto.topping != null){
      for(int i = 0; i < dto.topping.length; i++){
        this.extra[dto.topping[i]] = false;
      }
      if(unaffectPriceContent.keys.toList().length == 0){
        isExtra = true;
      }
    }


    verifyOrder();
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

  void changeAffectPriceAtrribute(String e){
    affectPriceChoice[affectPriceContent.keys.elementAt(affectIndex)] = e;
    for(ProductDTO dto in affectPriceContent[affectPriceContent.keys.elementAt(affectIndex)]){
      if(dto.id == e){
        price = dto.price;
      }
    }
    total = price * count;

    verifyOrder();
    notifyListeners();
  }

  void changeUnAffectPriceAtrribute(String e){
    unaffectPriceChoice[unaffectPriceContent.keys.elementAt(unaffectIndex)] = e;

    verifyOrder();
    notifyListeners();
  }

  void changeUnAffectIndex(int index){
    this.unaffectIndex = index;
    if(index == unaffectPriceContent.keys.toList().length){
      isExtra = true;
    }
    else isExtra = false;
    notifyListeners();
  }

  void changeAffectIndex(int index){
    this.affectIndex = index;
    notifyListeners();
  }

  void verifyOrder(){
    order = true;
    for(int i = 0; i < affectPriceContent.keys.toList().length; i++){
      if(affectPriceChoice[affectPriceContent.keys.elementAt(i)].isEmpty){
        order = false;
      }
    }

    for(int i = 0; i < unaffectPriceContent.keys.toList().length; i++){
      if(unaffectPriceChoice[unaffectPriceContent.keys.elementAt(i)].isEmpty){
        order = false;
      }
    }

    if(order){
      addColor = kPrimary;
    }
  }

  void changExtra(bool value, int i){
    extra[extra.keys.elementAt(i)] = value;
    notifyListeners();
  }

}