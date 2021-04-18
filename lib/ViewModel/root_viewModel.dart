import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:unidelivery_mobile/Bussiness/BussinessHandler.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/acessories/home_location.dart';
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

  CampusDTO currentStore;
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

  RootViewModel();

  Future getStores() async {
    setState(ViewStatus.Loading);
    StoreDAO dao = new StoreDAO();
    campuses = await dao.getStores();
    setState(ViewStatus.Completed);
  }

  Future<void> setLocation(LocationDTO location, CampusDTO campus) async {
    if (campus.available) {
      if (campus.id != currentStore.id) {
        Cart cart = await getCart();
        int option = 1;

        if (cart != null) {
          option = await showOptionDialog(
              "Bạn có chắc không? Đổi khu vực rồi là giỏ hàng bị xóa đó!!");
        }

        if (option == 1) {
          showLoadingDialog();
          currentStore = campus;
          setSelectedLocation(currentStore, location);
          await clearCart();
          notifyListeners();
          hideDialog();
          HomeViewModel.getInstance().getSuppliers();
          GiftViewModel.getInstance().getGifts();
        }
      } else {
        setSelectedLocation(currentStore, location);
        notifyListeners();
        await setStore(currentStore);
      }
    } else {
      showStatusDialog("assets/images/global_error.png", "Opps",
          "Cửa hàng đang tạm đóng 😓");
    }
  }

  Future<void> processChangeLocation() async {
    try {
      if (currentStore == null) {
        return;
      }
      changeAddress = true;
      notifyListeners();
      await changeCampusDialog(this);
      hideDialog();
      changeAddress = false;
      notifyListeners();
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

  Future<void> confirmTimeSlot(TimeSlot timeSlot) async {
    if (timeSlot.menuId != currentStore.selectedTimeSlot.menuId) {
      if (!timeSlot.available) {
        showStatusDialog(
            "assets/images/global_error.png",
            "Khung giờ đã qua rồi",
            "Hiện tại khung giờ này đã đóng vào lúc ${timeSlot.to}, bạn hãy xem khung giờ khác nhé 😃.");
        return;
      }
      int option = 1;
      showLoadingDialog();
      Cart cart = await getCart();
      if (cart != null) {
        option = await showOptionDialog(
            "Bạn có chắc không? Đổi khung giờ rồi là giỏ hàng bị xóa đó!!");
      }

      if (option == 1) {
        showLoadingDialog();
        currentStore.selectedTimeSlot = timeSlot;
        await deleteCart();
        await setStore(currentStore);
        hideDialog();
        HomeViewModel.getInstance().getSuppliers();
        GiftViewModel.getInstance().getGifts();
      }
    }
  }

  Future<void> fetchStore() async {
    try {
      setState(ViewStatus.Loading);
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
          if (currentStore.selectedTimeSlot == null) {
            return;
          }
          if (element.menuId == currentStore.selectedTimeSlot.menuId &&
              element.from == currentStore.selectedTimeSlot.from &&
              element.to == currentStore.selectedTimeSlot.to &&
              element.arrive == currentStore.selectedTimeSlot.arrive) {
            currentStore.selectedTimeSlot.available = element.available;
            found = true;
          }
        });
        if (found == false) {
          currentStore = BussinessHandler.setSelectedTime(currentStore);
          Cart cart = await getCart();
          if (cart != null) {
            await showStatusDialog(
                "assets/images/global_error.png",
                "Khung giờ đã thay đổi",
                "Các sản phẩm trong giỏ hàng đã bị xóa, còn nhiều món ngon đang chờ bạn nhé");
            await deleteCart();
          }
        } else {
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
            DateTime arrive = DateFormat("HH:mm:ss")
                .parse(currentStore.selectedTimeSlot.arrive);
            await showStatusDialog(
              "assets/images/global_error.png",
              "Khung giờ đã kết thúc",
              "Đã hết giờ chốt đơn cho khung giờ ${DateFormat("HH:mm").format(arrive)} - ${DateFormat("HH:mm").format(arrive.add(Duration(minutes: 30)))}. \n Hẹn gặp bạn ở khung giờ khác nhé 😢.",
            );
            // remove cart
            await deleteCart();
          }
        }
      }

      await setStore(currentStore);

      List<LocationDTO> locations =
          await _storeDAO.getLocations(currentStore.id);
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
        setState(ViewStatus.Completed);
      }
    } catch (e, stacktrace) {
      print(stacktrace.toString());
      bool result = await showErrorDialog();
      if (result) {
        await fetchStore();
      } else {
        setState(ViewStatus.Error);
      }
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
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          // margin: EdgeInsets.only(left: 8, right: 8, bottom: 32, top: 32),
          backgroundColor: kPrimary,
          messageText: Text("Thêm món thành công 🛒",
              style: kSubtitleTextSyule.copyWith(
                  fontSize: 16, color: Colors.white)),
          // borderRadius: 8,
          icon: Icon(Icons.check),
        );
        // Get.snackbar(
        //        "Hey i'm a Get SnackBar!", // title
        //        "It's unbelievable! I'm using SnackBar without context, without boilerplate, without Scaffold, it is something truly amazing!", // message
        //       icon: Icon(Icons.alarm),
        //       shouldIconPulse: true,
        //       onTap:(){},
        //       barBlur: 20,
        //       isDismissible: true,
        //       duration: Duration(seconds: 3),
        //     );
      }
    }
    notifyListeners();
  }

  Future<void> clearCart() async {
    await deleteCart();
    notifyListeners();
  }

  void setSelectedLocation(CampusDTO campus, LocationDTO location) {
    campus.locations.forEach((element) {
      if (element.id == location.id) {
        element.isSelected = true;
      } else {
        element.isSelected = false;
      }
    });
  }

  bool get isCurrentMenuAvailable {
    return currentStore?.selectedTimeSlot?.available;
  }
}
