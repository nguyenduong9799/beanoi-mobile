import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/route_constraint.dart';

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

  StoreDAO _storeDAO;
  List<SupplierDTO> suppliers;
  List<ProductDTO> gifts;
  List<BlogDTO> blogs;

  HomeViewModel() {
    _storeDAO = StoreDAO();
  }

  Future<void> getSuppliers() async {
    try {
      CampusDTO currentStore = RootViewModel.getInstance().currentStore;
      if (currentStore.selectedTimeSlot == null) {
        return;
      }

      setState(ViewStatus.Loading);

      suppliers = await _storeDAO.getSuppliers(
          currentStore.id, currentStore.selectedTimeSlot);
      if (blogs == null) {
        blogs = await _storeDAO.getBlogs(currentStore.id);
      }

      // int total_page = (_storeDAO.metaDataDTO.total / DEFAULT_SIZE).ceil();
      // if (total_page > _storeDAO.metaDataDTO.page){
      //   isLoadmore = true;
      // }else isLoadmore = false;
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e, stacktrace) {
      setState(ViewStatus.Loading);
      await RootViewModel.getInstance().fetchStore();
      if (RootViewModel.getInstance().status == ViewStatus.Completed) {
        await getSuppliers();
      } else {
        setState(ViewStatus.Error);
      }
    }
  }

  Future<void> selectSupplier(SupplierDTO dto) async {
    if (dto.available) {
      await Get.toNamed(RouteHandler.HOME_DETAIL, arguments: dto);
    } else {
      showStatusDialog("assets/images/global_error.png", "Opps",
          "Cửa hàng đang tạm đóng 😓");
    }
  }
}
