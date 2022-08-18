import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Services/push_notification_service.dart';

import 'index.dart';

class HomeViewModel extends BaseModel {
  StoreDAO _storeDAO;
  CollectionDAO _collectionDAO;
  ProductDAO _productDAO;

  List<SupplierDTO> suppliers;
  List<BlogDTO> blogs;
  List<CollectionDTO> homeCollections;

  Map<int, ProductDTO> prodInCollections;
  ProductDTO nearlyGift;

  HomeViewModel() {
    _collectionDAO = CollectionDAO();
    _storeDAO = StoreDAO();
    _productDAO = ProductDAO();
  }

  Future<void> getSuppliers() async {
    try {
      setState(ViewStatus.Loading);
      RootViewModel root = Get.find<RootViewModel>();
      CampusDTO currentStore = root.currentStore;
      MenuDTO currentMenu = root.selectedMenu;
      if (root.status == ViewStatus.Error) {
        setState(ViewStatus.Error);
        return;
      }
      if (currentStore.selectedTimeSlot == null) {
        suppliers = null;
        setState(ViewStatus.Completed);
        return;
      }

      suppliers =
          await _storeDAO.getSuppliers(currentStore.id, currentMenu.menuId);
      if (blogs == null) {
        blogs = await _storeDAO.getBlogs(currentStore.id);
      }
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e) {
      suppliers = null;
      setState(ViewStatus.Completed);
    }
  }

  Future<void> selectSupplier(SupplierDTO dto) async {
    RootViewModel root = Get.find<RootViewModel>();
    if (!root.isCurrentMenuAvailable()) {
      showStatusDialog("assets/images/global_error.png", "Opps",
          "Hiện tại khung giờ bạn chọn đã chốt đơn. Bạn vui lòng xem khung giờ khác nhé 😓.");
    } else if (dto.available) {
      await Get.toNamed(RouteHandler.HOME_DETAIL, arguments: dto);
    } else {
      showStatusDialog("assets/images/global_error.png", "Opps",
          "Cửa hàng đang tạm đóng 😓");
    }
  }

  Future<void> getListProductInHomeCollection() async {
    RootViewModel root = Get.find<RootViewModel>();
    CampusDTO currentStore = root.currentStore;
    MenuDTO currentMenu = root.selectedMenu;
    int storeId = currentStore.id;
    int supplierId = 1;
    try {
      setState(ViewStatus.Loading);
      var homeCollections = await _collectionDAO.getCollectionsOfSupplier(
          storeId, supplierId, currentMenu.menuId);

      // get list products of collection
      setState(ViewStatus.Completed);
    } catch (e) {
      print(e);
      setState(ViewStatus.Error);
    }

    return null;
  }

  Future<void> getCollections() async {
    try {
      setState(ViewStatus.Loading);
      RootViewModel root = Get.find<RootViewModel>();
      var currentStore = root.currentStore;
      var currentMenu = root.selectedMenu;
      if (root.status == ViewStatus.Error) {
        setState(ViewStatus.Error);
        return;
      }
      if (currentStore.selectedTimeSlot == null) {
        homeCollections = null;
        setState(ViewStatus.Completed);
        return;
      }
      final currentDate = DateTime.now();
      String currentTimeSlot = currentStore.selectedTimeSlot.to;
      var beanTime = new DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        double.parse(currentTimeSlot.split(':')[0]).round(),
        double.parse(currentTimeSlot.split(':')[1]).round(),
      );
      int differentTime = beanTime.difference(currentDate).inMilliseconds;
      if (differentTime <= 0) {
        homeCollections = null;
        setState(ViewStatus.Completed);
        return;
      }
      homeCollections = await _collectionDAO
          .getCollections(currentMenu.menuId, params: {"show-on-home": true});
      await Future.delayed(Duration(microseconds: 500));
      setState(ViewStatus.Completed);
    } catch (e) {
      homeCollections = null;
      setState(ViewStatus.Completed);
    }
  }
}
