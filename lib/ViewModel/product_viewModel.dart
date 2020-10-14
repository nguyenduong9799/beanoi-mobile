import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/StoreDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

import 'base_model.dart';

class ProductDetailViewModel extends BaseModel {
  int unaffectIndex = 0;
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
  double total, fixTotal = 0, extraTotal = 0;
  bool order = false;
  //List choice option
  Map<ProductDTO, bool> extra;
  //Bật cờ để đổi radio thành checkbox
  bool isExtra;
  //List size
  bool isLoading = false;
  ProductDTO master;

  ProductDetailViewModel(ProductDTO dto) {
    master = dto;
    isExtra = false;
    this.extra = new Map<ProductDTO, bool>();

    this.unaffectPriceContent = new Map<String, List<String>>();
    this.affectPriceContent = new Map();

    this.unaffectPriceChoice = new Map<String, String>();
    this.affectPriceChoice = new Map<String, ProductDTO>();
    //

    this.fixTotal = master.price * count;
    if(master.type == MASTER_PRODUCT){
      for (ProductChild child in master.listChild) {
        if (child.attribute.toUpperCase() == "ĐÁ" ||
            child.attribute.toUpperCase() == "ĐƯỜNG") {
          print("Đang thêm đá...");
          unaffectPriceContent[child.attribute] = [
            "0%",
            "25%",
            "50%",
            "75%",
            "100%"
          ];
          unaffectPriceChoice[child.attribute] = "";
        } else {
          affectPriceContent[child.attribute] = child.list;
          affectPriceChoice[child.attribute] = null;
        }
      }
    }

    if (unaffectPriceContent.keys.toList().length == 0 &&
        dto.catergoryId != null) {
      isExtra = true;
    }

    total = (fixTotal + extraTotal) * count;
    verifyOrder();
  }

  Future<void> getExtra(List<int> cat_id, String sup_id) async {
    setState(ViewStatus.Loading);
    try {
      StoreDTO store = await getStore();
      ProductDAO dao = new ProductDAO();
      List<ProductDTO> products = new List();

      for (int id in cat_id) {
        products.addAll(await dao.getExtraProducts(id, sup_id, store.id));
      }

      for (ProductDTO dto in products) {
        extra[dto] = false;
      }
      setState(ViewStatus.Completed);
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await getExtra(cat_id, sup_id);
      } else
        setState(ViewStatus.Error);
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
    if (affectPriceChoice[affectPriceContent.keys.elementAt(affectIndex)] !=
        null) {
      fixTotal -=
          affectPriceChoice[affectPriceContent.keys.elementAt(affectIndex)]
              .price;
    }
    affectPriceChoice[affectPriceContent.keys.elementAt(affectIndex)] = e;
    fixTotal += e.price;
    total = (fixTotal + extraTotal) * count;

    verifyOrder();
  }

  void changeUnAffectPriceAtrribute(String e) {
    unaffectPriceChoice[unaffectPriceContent.keys.elementAt(unaffectIndex)] = e;
    verifyOrder();
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
    // setState(ViewStatus.Completed);
    notifyListeners();
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

  Future<void> addProductToCart() async {
    showLoadingDialog();
    List<ProductDTO> listChoices = new List<ProductDTO>();
    if (master.type == MASTER_PRODUCT) {
      for (int i = 0; i < affectPriceChoice.keys.toList().length; i++) {
        print("Save product: " +
            affectPriceChoice[affectPriceChoice.keys.elementAt(i)].toString());
        listChoices.add(affectPriceChoice[affectPriceChoice.keys.elementAt(i)]);
      }
    }

    if (master.extraId != null) {
      for (int i = 0; i < extra.keys.length; i++) {
        if (extra[extra.keys.elementAt(i)]) {
          listChoices.add(extra.keys.elementAt(i));
        }
      }
    }

    String description = "";
    for (int i = 0; i < unaffectPriceChoice.keys.toList().length; i++) {
      description += unaffectPriceChoice.keys.elementAt(i) +
          ": " +
          unaffectPriceChoice[unaffectPriceChoice.keys.elementAt(i)] +
          "\n";
    }
    CartItem item = new CartItem(master, listChoices, description, count);

    print("Save product: " + master.toString());
    await addItemToCart(item);
    hideDialog();
    await Get.back(result: true);
  }
}
