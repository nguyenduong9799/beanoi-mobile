import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Bussiness/BussinessHandler.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/MenuDAO.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/MenuDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';

import 'index.dart';

class RootViewModel extends BaseModel {
  String version;
  bool changeAddress = false;
  CampusDTO currentStore;
  MenuDTO selectedMenu;
  List<MenuDTO> listMenu;
  List<CampusDTO> listStore;
  List<CampusDTO> campuses;
  ProductDAO _productDAO;
  List<TimeSlots> listAvailableTimeSlots;

  RootViewModel() {
    _productDAO = ProductDAO();
    listAvailableTimeSlots = [];
    selectedMenu = null;
  }

  Future startUp() async {
    await fetchStore();
    await Get.find<HomeViewModel>().getSuppliers();
    await Get.find<BlogsViewModel>().getBlogs();
    await Get.find<BlogsViewModel>().getDialogBlog();
    await Get.find<HomeViewModel>().getCollections();
    await Get.find<OrderHistoryViewModel>().getNewOrder();
    await Get.find<GiftViewModel>().getNearlyGiftExchange();
    await Get.find<GiftViewModel>().getGifts();
    await Get.find<OrderViewModel>().getUpSellCollections();
  }

  Future refreshMenu() async {
    await Get.find<RootViewModel>().fetchStore();
    await Get.find<HomeViewModel>().getSuppliers();
    await Get.find<HomeViewModel>().getCollections();
    await Get.find<OrderViewModel>().getUpSellCollections();
  }

  Future getStores() async {
    setState(ViewStatus.Loading);
    StoreDAO dao = new StoreDAO();
    campuses = await dao.getStores();
    for (int i = 0; i < campuses.length; i++) {
      List<LocationDTO> locations = await dao.getLocations(campuses[i].id);
      campuses[i].locations = locations;
    }
    CampusDTO campus = campuses.firstWhere(
      (element) => element.id == currentStore.id,
      orElse: () => null,
    );
    if (campus != null) {
      campus.locations = currentStore.locations;
    }
    setState(ViewStatus.Completed);
  }

  Future<void> setLocation(DestinationDTO destination, LocationDTO location,
      CampusDTO campus) async {
    if (campus.available) {
      if (campus.id != currentStore.id) {
        // Cart cart = await getCart();
        Cart cart = await Get.find<OrderViewModel>().currentCart;
        int option = 1;

        if (cart != null) {
          option = await showOptionDialog(
              "Bạn có chắc không? Đổi khu vực rồi là giỏ hàng bị xóa đó!!");
        }

        if (option == 1 || cart == null) {
          showLoadingDialog();
          Get.find<OrderViewModel>().removeCart();
          currentStore = campus;
          setSelectedLocation(currentStore, location, destination);
          await setStore(currentStore);
          await getListMenu(currentStore);
          notifyListeners();
          hideDialog();
          startUp();
        }
      } else {
        setSelectedLocation(currentStore, location, destination);
        await setStore(currentStore);
        await getListMenu(currentStore);
        notifyListeners();
      }
    } else {
      await showStatusDialog("assets/images/global_error.png", "Opps",
          "Cửa hàng đang tạm đóng 😓");
    }
    Get.back();
  }

  Future<void> getListMenu(CampusDTO currentStore) async {
    MenuDAO _menuDAO = new MenuDAO();
    listMenu = await _menuDAO.getMenus(areaID: currentStore.id);
    bool found = false;
    selectedMenu = await getMenu();
    if (selectedMenu == null) {
      selectedMenu = listMenu[0];
      for (MenuDTO element in listMenu) {
        if (isMenuAvailable(element)) {
          selectedMenu = element;
          await setMenu(selectedMenu);
          found = true;
          break;
        }
      }
      listAvailableTimeSlots = selectedMenu.timeSlots
          .where((element) =>
              isTimeSlotAvailable(element.checkoutTime) &&
              element.isActive &&
              element.isAvailable)
          .toList();
    } else {
      for (MenuDTO element in listMenu) {
        if (selectedMenu.menuId == element.menuId) {
          selectedMenu = element;
          await setMenu(selectedMenu);
          listAvailableTimeSlots = selectedMenu.timeSlots
              .where((element) => isTimeSlotAvailable(element.checkoutTime))
              .toList();
          found = true;
          break;
        }
      }
    }
    if (found == false) {
      Cart cart = await getCart();
      if (cart != null) {
        await showStatusDialog(
            "assets/images/global_error.png",
            "Khung giờ đã thay đổi",
            "Các sản phẩm trong giỏ hàng đã bị xóa, còn nhiều món ngon đang chờ bạn nhé");
        Get.find<OrderViewModel>().removeCart();
      }
    } else {
      if (!isCurrentMenuAvailable()) {
        await showStatusDialog(
          "assets/images/global_error.png",
          "Đã hết giờ chốt đơn cho ${selectedMenu.menuName}",
          "Bạn vui lòng chọn menu khác nhé.",
        );
        await fetchStore();
        // remove cart
        Get.find<OrderViewModel>().removeCart();
      }
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

  Future<void> confirmMenu(MenuDTO menu) async {
    if (menu.menuId != selectedMenu.menuId) {
      if (!isMenuAvailable(menu)) {
        showStatusDialog(
            "assets/images/global_error.png",
            "Khung giờ đã qua rồi",
            "Hiện tại khung giờ này đã đóng vào lúc ${menu.timeFromTo[1]}, bạn hãy xem khung giờ khác nhé 😃.");
        return;
      }
      int option = 1;
      // showLoadingDialog();
      // Cart cart = await getCart();
      Cart cart = Get.find<OrderViewModel>().currentCart;
      if (cart != null) {
        option = await showOptionDialog(
            "Bạn có chắc không? Đổi khung giờ rồi là giỏ hàng bị xóa đó!!");
      }
      if (option == 1) {
        // showLoadingDialog();
        selectedMenu = menu;
        await setMenu(selectedMenu);
        await Get.find<OrderViewModel>().removeCart();
        await setStore(currentStore);
        await refreshMenu();
        // hideDialog();
      }
      // hideDialog();
    }
  }

  Future<void> fetchStore() async {
    try {
      setState(ViewStatus.Loading);
      StoreDAO _storeDAO = new StoreDAO();
      MenuDAO _menuDAO = new MenuDAO();
      Function eq = const ListEquality().equals;

      currentStore = await getStore();
      if (currentStore == null) {
        listStore = await _storeDAO.getStores(id: UNIBEAN_STORE);
        // listMenu = await _menuDAO.getMenus(areaID: UNIBEAN_STORE);
        currentStore = listStore[0];
        await getListMenu(currentStore);
      } else {
        if (listMenu == null) {
          await getListMenu(currentStore);
        } else {
          bool found = false;
          selectedMenu = await getMenu();
          print(selectedMenu.menuName);
          if (selectedMenu == null) {
            selectedMenu = listMenu[0];
            for (MenuDTO element in listMenu) {
              if (isMenuAvailable(element)) {
                selectedMenu = element;
                await setMenu(selectedMenu);
                found = true;
                break;
              }
            }
            listAvailableTimeSlots = selectedMenu.timeSlots
                .where((element) =>
                    isTimeSlotAvailable(element.checkoutTime) &&
                    element.isActive &&
                    element.isAvailable)
                .toList();
          } else {
            if (isMenuAvailable(selectedMenu)) {
              found = true;
            }
            listAvailableTimeSlots = selectedMenu.timeSlots
                .where((element) => isTimeSlotAvailable(element.checkoutTime))
                .toList();
          }
          if (found == false) {
            Cart cart = await getCart();
            if (cart != null) {
              await showStatusDialog(
                  "assets/images/global_error.png",
                  "Khung giờ đã thay đổi",
                  "Các sản phẩm trong giỏ hàng đã bị xóa, còn nhiều món ngon đang chờ bạn nhé");
              Get.find<OrderViewModel>().removeCart();
            }
          } else {
            if (!isCurrentMenuAvailable()) {
              await showStatusDialog(
                "assets/images/global_error.png",
                "Đã hết giờ chốt đơn cho ${selectedMenu.menuName}",
                "Bạn vui lòng chọn menu khác nhé.",
              );
              await fetchStore();
              // remove cart
              Get.find<OrderViewModel>().removeCart();
            }
          }
        }
      }

      await setStore(currentStore);

      List<LocationDTO> locations =
          await _storeDAO.getLocations(currentStore.id);
      if (!eq(locations, currentStore.locations)) {
        currentStore.locations.forEach((location) {
          if (location.isSelected) {
            DestinationDTO destination = location.destinations
                .where(
                  (element) => element.isSelected,
                )
                .first;
            locations.forEach((element) {
              if (element.id == location.id) {
                element.isSelected = true;
                element.destinations.forEach((des) {
                  if (des.id == destination.id) des.isSelected = true;
                });
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

  Future<void> openCart(bool isMart) async {
    hideSnackbar();
    await Get.toNamed(RouteHandler.ORDER);
    notifyListeners();
  }

  // _animateToIndex(i) => _scrollController.jumpTo(305.5 * i);

  Future<Cart> get cart async {
    return await getCart();
  }

  Future<Cart> get mart async {
    return await getMart();
  }

  Future<void> openProductDetail(ProductDTO product,
      {showOnHome = true, fetchDetail = false}) async {
    Get.put<bool>(
      showOnHome,
      tag: "showOnHome",
    );
    try {
      if (fetchDetail) {
        showLoadingDialog();
        CampusDTO store = await getStore();
        product = await _productDAO.getProductDetail(
            product.id, store.id, selectedMenu.menuId);
      }
      bool result =
          await Get.toNamed(RouteHandler.PRODUCT_DETAIL, arguments: product);
      // hideSnackbar();
      hideDialog();
      await Get.delete<bool>(
        tag: "showOnHome",
      );
      if (result != null) {
        if (result) {
          Get.rawSnackbar(
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.white,
            messageText: Text("Thêm món thành công ",
                style: Get.theme.textTheme.headline2),
            icon: Icon(
              Icons.check,
              color: kPrimary,
            ),
            mainButton: FlatButton(
              color: kPrimary,
              onPressed: () {
                Get.toNamed(RouteHandler.ORDER);
              },
              child: Text(
                "Xem 🛒",
                style: Get.theme.textTheme.headline2.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      }
      notifyListeners();
    } catch (e) {
      await showErrorDialog(errorTitle: "Không tìm thấy sản phẩm");
      hideDialog();
    }
  }

  Future<void> addUpSellProductToCart(ProductDTO product,
      {showOnHome = true, fetchDetail = false}) async {
    Get.put<bool>(
      showOnHome,
      tag: "showOnHome",
    );
    if (product.type != ProductType.SINGLE_PRODUCT &&
        product.type != ProductType.GIFT_PRODUCT) {
      await openProductDetail(product, fetchDetail: true);
      await Get.toNamed(RouteHandler.ORDER);
    } else {
      try {
        if (fetchDetail) {
          showLoadingDialog();
          CampusDTO store = await getStore();
          product = await _productDAO.getProductDetail(
              product.id, store.id, selectedMenu.menuId);
        }
        ProductDetailViewModel detail = new ProductDetailViewModel(product);
        await detail.addProductToCart(backToHome: false);
        hideSnackbar();
        hideDialog();

        await Get.delete<bool>(
          tag: "showOnHome",
        );

        notifyListeners();
      } catch (e) {
        await showErrorDialog(errorTitle: "Không tìm thấy sản phẩm");
        hideDialog();
      }
    }
  }

  Future<void> clearCart() async {
    Get.find<OrderViewModel>().removeCart();
    notifyListeners();
  }

  void setSelectedLocation(
      CampusDTO campus, LocationDTO location, DestinationDTO destination) {
    campus.locations.forEach((element) {
      if (element.id == location.id) {
        element.isSelected = true;
        element.destinations.forEach((des) {
          if (des.id == destination.id) {
            des.isSelected = true;
          } else {
            des.isSelected = false;
          }
        });
      } else {
        element.isSelected = false;
      }
    });
    currentStore = campus;
    notifyListeners();
  }

  bool isCurrentMenuAvailable() {
    final currentDate = DateTime.now();
    String currentTimeSlot = selectedMenu.timeFromTo[1];
    var beanTime = new DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      double.parse(currentTimeSlot.split(':')[0]).round(),
      double.parse(currentTimeSlot.split(':')[1]).round(),
    );
    int differentTime = beanTime.difference(currentDate).inMilliseconds;
    if (differentTime <= 0) {
      return false;
    } else
      return true;
  }

  bool isMenuAvailable(MenuDTO currentMenu) {
    final currentDate = DateTime.now();
    String currentTimeSlot = currentMenu.timeFromTo[1];
    var beanTime = new DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      double.parse(currentTimeSlot.split(':')[0]).round(),
      double.parse(currentTimeSlot.split(':')[1]).round(),
    );
    int differentTime = beanTime.difference(currentDate).inMilliseconds;
    if (differentTime <= 0) {
      return false;
    } else
      return true;
  }

  bool isTimeSlotAvailable(String currentCheckoutTime) {
    final currentDate = DateTime.now();
    var checkoutTime = new DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      double.parse(currentCheckoutTime.split(':')[0]).round(),
      double.parse(currentCheckoutTime.split(':')[1]).round(),
    );
    int differentTime = checkoutTime.difference(currentDate).inMilliseconds;
    if (differentTime < 0) {
      return false;
    } else
      return true;
  }
}
