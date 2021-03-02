import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
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

  static HomeViewModel getInstance() {
    if (_instance == null) {
      _instance = HomeViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

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

  HomeViewModel() {
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

  Future<void> openProductDetail(ProductDTO product) async {
    await AnalyticsService.getInstance().logViewItem(product);
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
        await RootViewModel.getInstance().fetchUser();
      }
    }
  }

  // _animateToIndex(i) => _scrollController.jumpTo(305.5 * i);

  Future<Cart> get cart async {
    return await getCart();
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
      print("Length: " + products.length.toString());
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
      print("Excception: " + e.toString() + stacktrace.toString());
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
      print("Excception: " + e.toString() + stacktrace.toString());
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

      print("Get products...");
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
      print("Excception: " + e.toString() + stacktrace.toString());
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
