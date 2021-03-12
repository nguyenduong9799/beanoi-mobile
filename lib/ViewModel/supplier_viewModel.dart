import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';
import '../constraints.dart';

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
    try {
      setState(ViewStatus.Loading);
      CampusDTO store = await getStore();
      collections = await _collectionDAO.getCollections(
          store.id, supplierId, store.selectedTimeSlot);
      products = await _productDAO.getProducts(
          store.id, supplierId, store.selectedTimeSlot);
      if (collections != null && collections.isNotEmpty) {
        collections.forEach((element) {
          element.products = products
              .where((product) =>
          product.collections.any((e) => e == element.id) &&
              product.type != ProductType.GIFT_PRODUCT)
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
    try {
      isLoadGift = true;
      notifyListeners();
      CampusDTO store = await getStore();
      gifts = await _productDAO.getProducts(
          store.id, supplierId, store.selectedTimeSlot,
          type: ProductType.GIFT_PRODUCT);
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      isLoadGift = false;
    } catch (e, stacktrace) {
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
    try {
      setState(ViewStatus.LoadMore);
      CampusDTO store = await getStore();

      products += await _productDAO.getProducts(
          store.id, supplierId, store.selectedTimeSlot,
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
    } catch (e, stacktrace) {
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
