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
  List<SupplierDTO> suppliers;
  List<BlogDTO> blogs;

  HomeViewModel() {
    _storeDAO = StoreDAO();
  }

  Future<void> getSuppliers() async {
    try {
      setState(ViewStatus.Loading);
      String token = await PushNotificationService.getInstance().getFcmToken();
      print("FCM: $token");
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
}
