import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';

import 'index.dart';

class SupplierViewModel extends BaseModel {
  int supplierId;
  ProductDAO _productDAO;
  CollectionDAO _collectionDAO;
  ScrollController scrollController;

  List<ProductDTO> products;
  List<ProductDTO> gifts;
  bool _isShrink = false;
  List<CollectionDTO> collections;
  bool isLoadGift;

  bool get isShrink => _isShrink;

  set isShrink(bool value) {
    _isShrink = value;
  }

  SupplierViewModel(int supplierId) {
    this.supplierId = supplierId;
    scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        int total_page = (_productDAO.metaDataDTO.total / DEFAULT_SIZE).ceil();
        if (total_page > _productDAO.metaDataDTO.page) {
          await getMoreProducts();
        }
      }
    });
    _productDAO = ProductDAO();
    _collectionDAO = CollectionDAO();
    isLoadGift = false;
  }
  // 1. Get ProductList with current Filter
  Future<void> getProducts() async {
    RootViewModel root = Get.find<RootViewModel>();
    MenuDTO currentMenu = root.selectedMenu;
    try {
      setState(ViewStatus.Loading);
      CampusDTO store = await getStore();
      collections = await _collectionDAO.getCollectionsOfSupplier(
          store.id, supplierId, currentMenu.menuId);
      products = await _productDAO.getProducts(
          store.id, supplierId, currentMenu.menuId);
      if (collections != null && collections.isNotEmpty) {
        collections.forEach((element) {
          element.products = products
              .where((product) => product.collections != null
                  ? product.collections.any((e) => e == element.id)
                  : false)
              .toList();
        });
      }

      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      if (products.isEmpty ||
          products == null ||
          collections.isEmpty ||
          collections == null) {
        setState(ViewStatus.Empty);
      } else {
        setState(ViewStatus.Completed);
      }
    } catch (e, stacktrace) {
      print(e.toString() + stacktrace.toString());
      bool result = await showErrorDialog();
      if (result) {
        await getProducts();
      } else
        setState(ViewStatus.Error);
    } finally {
      // notifyListeners();
    }
  }

  Future<void> getGifts() async {
    RootViewModel root = Get.find<RootViewModel>();
    MenuDTO currentMenu = root.selectedMenu;
    try {
      isLoadGift = true;
      notifyListeners();
      CampusDTO store = await getStore();
      gifts = await _productDAO.getProducts(
          store.id, supplierId, currentMenu.menuId,
          type: ProductType.GIFT_PRODUCT);
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      isLoadGift = false;
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await getGifts();
      } else
        setState(ViewStatus.Error);
    } finally {
      notifyListeners();
    }
  }

  Future<void> getMoreProducts() async {
    RootViewModel root = Get.find<RootViewModel>();
    MenuDTO currentMenu = root.selectedMenu;
    try {
      setState(ViewStatus.LoadMore);
      CampusDTO store = await getStore();
      products += await _productDAO.getProducts(
          store.id, supplierId, currentMenu.menuId,
          page: _productDAO.metaDataDTO.page + 1);

      if (collections != null && collections.isNotEmpty) {
        collections.forEach((element) {
          element.products = products
              .where((product) =>
                  product.collections.any((e) => e == element.id) &&
                  product.type != ProductType.GIFT_PRODUCT)
              .toList();
        });
      }
      await Future.delayed(Duration(milliseconds: 1000));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await getMoreProducts();
      } else
        setState(ViewStatus.Error);
    }
  }

  // 2. Change filter

  Future<void> updateFilter(int filterId) async {
    for (int i = 0; i < collections.length; i++) {
      if (collections[i].id == filterId) {
        collections[i].isSelected = !collections[i].isSelected;
      }
    }
    notifyListeners();
  }

  void updateShrinkStatus(bool status) {
    _isShrink = status;
    notifyListeners();
  }
}
