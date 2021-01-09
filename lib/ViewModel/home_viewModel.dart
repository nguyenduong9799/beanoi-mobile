import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DAO/CollectionDAO.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/CollectionDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/StoreDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/route_constraint.dart';
import 'package:unidelivery_mobile/services/analytic_service.dart';
import 'package:unidelivery_mobile/services/push_notification_service.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';
import '../constraints.dart';

class HomeViewModel extends BaseModel {
  static HomeViewModel _instance;

  ProductDAO _productDAO = ProductDAO();
  CollectionDAO _collectionDAO = CollectionDAO();
  ScrollController _scrollController = ScrollController();
  dynamic error;
  List<ProductDTO> products;
  bool _isShrink = false;
  List<CollectionDTO> collections;

  bool get isShrink => _isShrink;

  set isShrink(bool value) {
    _isShrink = value;
  }

  ScrollController get scrollController => _scrollController;

  set scrollController(ScrollController value) {
    _scrollController = value;
  }

  HomeViewModel();

  Future<void> openProductDetail(ProductDTO product) async {
    await AnalyticsService.getInstance().logViewItem(product);
    String fcm = await PushNotificationService.getInstance().getFcmToken();
    print("fcm: " + fcm);
    bool result =
        await Get.toNamed(RouteHandler.PRODUCT_DETAIL, arguments: product);
    hideSnackbar();
    if (result != null) {
      if (result) {
        Get.rawSnackbar(
            message: "Thêm món thành công",
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.only(left: 8, right: 8, bottom: 32),
            backgroundColor: kPrimary,
            borderRadius: 8);
      }
    }
    notifyListeners();
  }

  Future<void> openCart() async {
    hideSnackbar();
    bool result = await Get.toNamed(RouteHandler.ORDER);
    notifyListeners();
    if (result != null) {
      if (result) {
        await RootViewModel.getInstance().fetchUser(true);
      }
    }
  }

  // _animateToIndex(i) => _scrollController.jumpTo(305.5 * i);

  Future<Cart> get cart async {
    return await getCart();
  }

  static HomeViewModel getInstance() {
    if (_instance == null) {
      _instance = HomeViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  // 1. Get ProductList with current Filter
  Future<void> getProducts(int supplierId) async {
    try {
      setState(ViewStatus.Loading);
      StoreDTO store = await getStore();

      print("Get products...");
      collections = await _collectionDAO.getCollections(store.id, supplierId);
      products = await _productDAO.getProducts(store.id, supplierId);
      if (collections != null && collections.isNotEmpty) {
        collections.forEach((element) {
          element.products = products
              .where(
                  (product) => product.collections.any((e) => e == element.id))
              .toList();
        });
      }
      await Future.delayed(Duration(microseconds: 1000));
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
      print("Excception: " + e.toString() + stacktrace.toString());
      bool result = await showErrorDialog();
      if (result) {
        await getProducts(supplierId);
      } else
        setState(ViewStatus.Error);
    } finally {
      // notifyListeners();
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
