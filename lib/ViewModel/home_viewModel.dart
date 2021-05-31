import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/CategoryDAO.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';

import 'index.dart';

class HomeViewModel extends BaseModel {
  StoreDAO _storeDAO;
  CollectionDAO _collectionDAO;
  ProductDAO _productDAO;

  List<SupplierDTO> suppliers;
  List<BlogDTO> blogs;

  Map<int, ProductDTO> prodInCollections;
  ProductDTO nearlyGift;

  HomeViewModel() {
    _storeDAO = StoreDAO();
  }

  Future<void> getSuppliers() async {
    try {
      setState(ViewStatus.Loading);
      RootViewModel root = Get.find<RootViewModel>();
      await root.fetchStore();
      CampusDTO currentStore = root.currentStore;
      if (root.status == ViewStatus.Error) {
        setState(ViewStatus.Error);
        return;
      }
      if (currentStore.selectedTimeSlot == null) {
        suppliers = null;
        setState(ViewStatus.Completed);
        return;
      }

      suppliers = await _storeDAO.getSuppliers(
          currentStore.id, currentStore.selectedTimeSlot);
      if (blogs == null) {
        blogs = await _storeDAO.getBlogs(currentStore.id);
      }
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e, stacktrace) {
      suppliers = null;
      setState(ViewStatus.Completed);
    }
  }

  Future<void> selectSupplier(SupplierDTO dto) async {
    RootViewModel root = Get.find<RootViewModel>();
    if (!root.isCurrentMenuAvailable) {
      showStatusDialog("assets/images/global_error.png", "Opps",
          "Hiện tại khung giờ bạn chọn đã chốt đơn. Bạn vui lòng xem khung giờ khác nhé 😓.");
    } else if (dto.available) {
      await Get.toNamed(RouteHandler.HOME_DETAIL, arguments: dto);
    } else {
      showStatusDialog("assets/images/global_error.png", "Opps",
          "Cửa hàng đang tạm đóng 😓");
    }
  }

  // TODO: 1. Get List Product With Home Collection
  Future<void> getListProductInHomeCollection() async {
    Map<int, ProductDTO> prodInCollections = {};
    RootViewModel root = Get.find<RootViewModel>();
    CampusDTO currentStore = root.currentStore;
    int storeId = currentStore.id;
    int supplierId = 1;
    try {
      setState(ViewStatus.Loading);
      var homeCollections = await _collectionDAO.getCollectionsOfSupplier(
          storeId, supplierId, currentStore.selectedTimeSlot);

      // get list products of collection
      setState(ViewStatus.Completed);
    } catch (e) {
      print(e);
      setState(ViewStatus.Error);
    }

    return null;
  }

  // TODO: 2. Get Gift can exchange (or nearly)
  Future<void> getNearlyGiftExchange() async {
    RootViewModel root = Get.find<RootViewModel>();
    CampusDTO currentStore = root.currentStore;

    try {
      setState(ViewStatus.Loading);
      var nearLyGifts = await _productDAO.getGifts(
        currentStore.id,
        currentStore.selectedTimeSlot,
        params: {"sortBy": "price"},
      );

      if (nearLyGifts.length > 0) {
        nearlyGift = nearLyGifts.first;
      }
      setState(ViewStatus.Completed);
    } catch (e) {
      nearlyGift = null;
      setState(ViewStatus.Error);
    }
  }
}
