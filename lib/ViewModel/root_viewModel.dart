import 'package:get/get.dart';

import 'package:unidelivery_mobile/Model/DAO/AccountDAO.dart';
import 'package:unidelivery_mobile/Model/DAO/StoreDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/StoreDTO.dart';
import 'package:unidelivery_mobile/Services/analytic_service.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/ViewModel/home_viewModel.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

import '../route_constraint.dart';

class RootViewModel extends BaseModel {
  AccountDAO _dao;
  AccountDTO currentUser;
  String error;
  static RootViewModel _instance;
  AnalyticsService _analyticsService;

  static RootViewModel getInstance() {
    if (_instance == null) {
      _instance = RootViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  bool changeAddress = false;

  StoreDTO dto, tmp;

  List<StoreDTO> list;

  RootViewModel() {
    _dao = AccountDAO();
    _analyticsService = AnalyticsService.getInstance();
    setState(ViewStatus.Loading);
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      setState(ViewStatus.Loading);
      final user = await _dao.getUser();
      currentUser = user;
      setState(ViewStatus.Completed);
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await fetchUser();
      } else
        setState(ViewStatus.Error);
    } finally {}
  }

  Future<void> signOut() async {
    await _dao.logOut();
    await removeALL();
  }

  Future<void> processSignout() async {
    int option = await showOptionDialog("Mình sẽ nhớ bạn lắm ó huhu :'(((");
    if (option == 1) {
      await signOut();
      Get.offAllNamed(RouteHandler.LOGIN);
    }
    destroyInstance();
  }

  Future<void> getLocation() async {
    dto = await getStore();
    notifyListeners();
  }

  Future<void> processChangeAddress(HomeViewModel homeViewModel) async {
    if (dto == null) {
      return;
    }
    changeAddress = true;
    tmp = dto;
    notifyListeners();
    showLoadingDialog();

    StoreDAO dao = new StoreDAO();
    list = await dao.getStores();
    Cart cart = await getCart();

    hideDialog();
    await changeAddressDialog(this, () async {
      hideDialog();
      if (tmp.id != this.dto.id) {
        int option = 0;

        if(cart != null){
          option = await showOptionDialog(
              "Bạn có chắc không? Đổi địa chỉ rồi là giỏ hàng m bị xóa đó :))");
        }

        if (option == 1 || cart == null) {
          print("Changing index...");
          dto = tmp;
          await deleteCart();
          await setStore(dto);
          homeViewModel.isFirstFetch = true;
          await homeViewModel.getProducts();
        }
      }
      changeAddress = false;
      notifyListeners();
    });
  }

  void changeLocation(int id) {
    for (StoreDTO dto in list) {
      if (dto.id == id) {
        tmp = dto;
      }
    }
    notifyListeners();
  }
}
