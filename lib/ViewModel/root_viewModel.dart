import 'package:get/get.dart';

import 'package:unidelivery_mobile/Model/DAO/AccountDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/StoreDTO.dart';
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

  bool changeAddress = false;

  StoreDTO dto, tmp;

  List<StoreDTO> list = [
    new StoreDTO(id: 150, name: "Unibean Store", location: "FPT University"),
    new StoreDTO(id: 999, name: "Co be ban diem", location: "69 Bùi Viện"),
    new StoreDTO(id: 400, name: "Halloween", location: "Phố đi bộ Nguyễn Huệ"),
  ];

  RootViewModel() {
    _dao = AccountDAO();
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
  }

  Future<void> processSignout() async {
    int option = await showOptionDialog("Bạn có chắc không");
    if (option == 1) {
      await signOut();
      Get.offAllNamed(RouteHandler.LOGIN);
    }
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

    await changeAddressDialog(this, () async {
      hideDialog();
      if (tmp.id != this.dto.id) {
        int option = await showOptionDialog(
            "Bạn có chắc không? Đổi địa chỉ rồi là giỏ hàng m bị xóa đó :))");
        if (option == 1) {
          print("Changing index...");
          dto = tmp;
          await deleteCart();
          await setStore(dto);
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
