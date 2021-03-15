import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Bussiness/BussinessHandler.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';
import '../constraints.dart';
import 'package:collection/collection.dart';

import '../route_constraint.dart';
import 'index.dart';

class RootViewModel extends BaseModel {
  static RootViewModel _instance;
  String version;
  bool changeAddress = false;

  CampusDTO currentStore, tmpStore;
  TimeSlot tmpTimeSlot;
  List<CampusDTO> campuses;

  static RootViewModel getInstance() {
    if (_instance == null) {
      _instance = RootViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  RootViewModel() {}

  Future<void> processChangeLocation() async {
    try {
      if (currentStore == null) {
        return;
      }
      changeAddress = true;
      tmpStore = currentStore;
      notifyListeners();
      showLoadingDialog();

      StoreDAO dao = new StoreDAO();
      campuses = await dao.getStores();
      Cart cart = await getCart();

      hideDialog();
      await changeCampusDialog(this, () async {
        hideDialog();
        if (tmpStore.id != this.currentStore.id) {
          int option = 1;

          if (cart != null) {
            option = await showOptionDialog(
                "Bạn có chắc không? Đổi địa chỉ rồi là giỏ hàng bị xóa đó!!");
          }

          if (option == 1) {
            showLoadingDialog();
            currentStore = BussinessHandler.setSelectedTime(tmpStore);
            await deleteCart();
            await setStore(currentStore);
            HomeViewModel.getInstance().notifyListeners();
            hideDialog();
            HomeViewModel.getInstance().getSuppliers();
            GiftViewModel.getInstance().getGifts();
          }
        }
        changeAddress = false;
        notifyListeners();
      });
    } catch (e) {
      hideDialog();
      bool result = await showErrorDialog();
      if (result) {
        await processChangeLocation();
      } else {
        changeAddress = false;
        setState(ViewStatus.Error);
      }
    }
  }

  void changeLocation(int id) {
    for (CampusDTO dto in campuses) {
      if (dto.id == id) {
        if (dto.available) {
          tmpStore = dto;
        } else {
          showStatusDialog("assets/images/global_error.png", "Opps",
              "Cửa hàng đang tạm đóng 😓");
        }
      }
    }
    notifyListeners();
  }

  void selectTimeSlot(int value) {
    currentStore.timeSlots.forEach((element) {
      if (element.menuId == value) {
        if (element.available) {
          tmpTimeSlot = element;
        } else {
          showStatusDialog(
              "assets/images/global_error.png",
              "Khung giờ đã qua rồi",
              "Đừng nối tiếc quá khứ, hãy hướng về tương lai");
        }
        notifyListeners();
      }
    });
  }

  Future<void> confirmTimeSlot() async {
    hideDialog();
    if (tmpTimeSlot.menuId != currentStore.selectedTimeSlot.menuId) {
      int option = 1;
      Cart cart = await getCart();
      if (cart != null) {
        option = await showOptionDialog(
            "Bạn có chắc không? Đổi khung giờ rồi là giỏ hàng bị xóa đó!!");
      }

      if (option == 1) {
        showLoadingDialog();
        currentStore.selectedTimeSlot = tmpTimeSlot;
        await deleteCart();
        await setStore(currentStore);
        HomeViewModel.getInstance().notifyListeners();
        hideDialog();
        HomeViewModel.getInstance().getSuppliers();
        GiftViewModel.getInstance().getGifts();
      }
    }
  }

  Future<void> fetchStore() async {
    setState(ViewStatus.Loading);
    HomeViewModel.getInstance().setState(ViewStatus.Loading);
    GiftViewModel.getInstance().setState(ViewStatus.Loading);
    StoreDAO _storeDAO = new StoreDAO();
    Function eq = const ListEquality().equals;
    List<CampusDTO> listStore;
    currentStore = await getStore();

    if (currentStore == null) {
      listStore = await _storeDAO.getStores(id: UNIBEAN_STORE);
      currentStore = BussinessHandler.setSelectedTime(listStore[0]);
    } else {
      listStore = await _storeDAO.getStores(id: currentStore.id);
      currentStore.timeSlots = listStore[0].timeSlots;
      bool found = false;
      currentStore.timeSlots.forEach((element) {
        if (element.menuId == currentStore.selectedTimeSlot.menuId &&
            element.from == currentStore.selectedTimeSlot.from &&
            element.to == currentStore.selectedTimeSlot.to &&
            element.arrive == currentStore.selectedTimeSlot.arrive) {
          currentStore.selectedTimeSlot.available = element.available;
          found = true;
        }
      });
      if (found == false) {
        await deleteCart();
        currentStore = BussinessHandler.setSelectedTime(currentStore);
        await showStatusDialog(
            "assets/images/global_error.png",
            "Khung giờ đã thay đổi",
            "Các sản phẩm trong giỏ hàng đã bị xóa, còn nhiều món ngon đang chờ bạn nhé");
      }
    }

    await setStore(currentStore);

    List<LocationDTO> locations = await _storeDAO.getLocations(currentStore.id);
    if (!eq(locations, currentStore.locations)) {
      currentStore.locations.forEach((location) {
        if (location.isSelected) {
          locations.forEach((element) {
            if (element.id == location.id) {
              element.isSelected = true;
            }
          });
        }
      });

      currentStore.locations = locations;
      await setStore(currentStore);
      tmpTimeSlot = currentStore.selectedTimeSlot;
      setState(ViewStatus.Completed);
    }
  }

  Future<void> openCart() async {
    hideSnackbar();
    await Get.toNamed(RouteHandler.ORDER);
    notifyListeners();
  }

  // _animateToIndex(i) => _scrollController.jumpTo(305.5 * i);

  Future<Cart> get cart async {
    return await getCart();
  }

  Future<void> openProductDetail(ProductDTO product) async {
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
}
