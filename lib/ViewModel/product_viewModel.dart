import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DAO/ProductDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/utils/enum.dart';

class ProductDetailViewModel extends Model {
  int unaffectIndex = 0;
  Status status;
  int affectIndex = 0;
  //List product không ảnh hưởng giá
  Map<String, List<String>> unaffectPriceContent;
  //List choice bắt buộc không ảnh hưởng giá
  Map<String, String> unaffectPriceChoice;
  //List product ảnh hưởng giá
  Map<String, List<ProductDTO>> affectPriceContent;
  //List choice bắt buộc không ảnh hưởng giá
  Map<String, ProductDTO> affectPriceChoice;
  int count = 1;
  Color minusColor = kBackgroundGrey[5];
  Color addColor = kBackgroundGrey[5];
  double total, fixTotal, extraTotal = 0;
  bool order = false;
  //List choice option
  Map<ProductDTO, bool> extra;
  //Bật cờ để đổi radio thành checkbox
  bool isExtra;
  //List size
  bool isLoading = false;

  ProductDetailViewModel(ProductDTO dto) {
    isExtra = false;
    this.extra = new Map<ProductDTO, bool>();

    this.unaffectPriceContent = new Map<String, List<String>>();
    this.affectPriceContent = new Map();

    this.unaffectPriceChoice = new Map<String, String>();
    this.affectPriceChoice = new Map<String, ProductDTO>();
    //
    if (dto.type != MASTER_PRODUCT) {
      this.fixTotal = dto.price * count;
    } else {
      for (String s in dto.atrributes) {
        if (s.toUpperCase() == "ĐÁ" || s.toUpperCase() == "ĐƯỜNG") {
          unaffectPriceContent[s] = ["0%", "25%", "50%", "75%", "100%"];
          unaffectPriceChoice[s] = "";
        } else {
          affectPriceContent[s] = dto.listChild;
          affectPriceChoice[s] = null;
        }
      }
    }

    if (unaffectPriceContent.keys.toList().length == 0 &&
        dto.catergoryId != null) {
      isExtra = true;
    }

    if (fixTotal != null) {
      total = (fixTotal + extraTotal) * count;
    }

    verifyOrder();
  }

  Future<void> getExtra(int cat_id) async {
    status = Status.Loading;
    notifyListeners();
    try {
      ProductDAO dao = new ProductDAO();
      List<ProductDTO> products = await dao.getExtraProducts(cat_id);
      for (ProductDTO dto in products) {
        extra[dto] = false;
      }
      status = Status.Completed;
    } catch (e) {
      print("EXCEPTION $e");
      status = Status.Error;
    } finally {
      notifyListeners();
    }
  }

  void addQuantity() {
    if (addColor == kPrimary) {
      if (count == 1) {
        minusColor = kPrimary;
      }
      count++;
      total = (extraTotal + fixTotal) * count;
      notifyListeners();
    }
  }

  void deleteQuantity() {
    count = 0;
    notifyListeners();
  }

  void minusQuantity() {
    if (count > 1) {
      count--;
      if (count == 1) {
        minusColor = kBackgroundGrey[5];
      }
      total = (extraTotal + fixTotal) * count;
      notifyListeners();
    }
  }

  void changeAffectPriceAtrribute(ProductDTO e) {
    fixTotal = 0;
    affectPriceChoice[affectPriceContent.keys.elementAt(affectIndex)] = e;

    for (int i = 0; i < affectPriceContent.keys.toList().length; i++) {
      for (ProductDTO dto
          in affectPriceContent[affectPriceContent.keys.elementAt(i)]) {
        if (dto.id == e.id) {
          fixTotal += dto.price;
        }
      }
    }
    total = (fixTotal + extraTotal) * count;

    verifyOrder();
    notifyListeners();
  }

  void changeUnAffectPriceAtrribute(String e) {
    unaffectPriceChoice[unaffectPriceContent.keys.elementAt(unaffectIndex)] = e;

    verifyOrder();
    notifyListeners();
  }

  void changeUnAffectIndex(int index) {
    this.unaffectIndex = index;
    if (index == unaffectPriceContent.keys.toList().length) {
      isExtra = true;
    } else
      isExtra = false;
    notifyListeners();
  }

  void changeAffectIndex(int index) {
    this.affectIndex = index;
    notifyListeners();
  }

  void verifyOrder() {
    order = true;
    for (int i = 0; i < affectPriceContent.keys.toList().length; i++) {
      if (affectPriceChoice[affectPriceContent.keys.elementAt(i)] == null) {
        order = false;
      }
    }

    for (int i = 0; i < unaffectPriceContent.keys.toList().length; i++) {
      if (unaffectPriceChoice[unaffectPriceContent.keys.elementAt(i)].isEmpty) {
        order = false;
      }
    }

    if (order) {
      addColor = kPrimary;
    }
  }

  void changExtra(bool value, int i) {
    extraTotal = 0;
    extra[extra.keys.elementAt(i)] = value;
    for (int j = 0; j < extra.keys.toList().length; j++) {
      if (extra[extra.keys.elementAt(j)]) {
        extraTotal += extra.keys.elementAt(j).price;
      }
    }
    total = (fixTotal + extraTotal) * count;
    notifyListeners();
  }
}
