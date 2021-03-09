import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Bussiness/BussinessHandler.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/route_constraint.dart';
import 'package:unidelivery_mobile/services/analytic_service.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';
import '../constraints.dart';
import 'package:collection/collection.dart';

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
  ProductDAO _productDAO;
  bool changeAddress = false;

  CampusDTO currentStore, tmpStore;
  TimeSlot tmpTimeSlot;
  List<CampusDTO> campuses;
  List<SupplierDTO> suppliers;
  List<ProductDTO> gifts;
  List<BlogDTO> blogs;
  String version;
  ScrollController giftScrollController;


  HomeViewModel() {
    _storeDAO = StoreDAO();
    _productDAO = ProductDAO();

    giftScrollController = ScrollController();
    giftScrollController.addListener(() async {
      if (giftScrollController.position.pixels ==
          giftScrollController.position.maxScrollExtent) {
        int total_page = (_productDAO.metaDataDTO.total / DEFAULT_SIZE).ceil();
        if (total_page > _productDAO.metaDataDTO.page) {
          await getMoreGifts();
        }
      }
    });
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


  Future<void> getSuppliers() async {
    try {
      if (status != ViewStatus.Loading) {
        setState(ViewStatus.Loading);
      }

      if (currentStore == null) {
        currentStore = await getStore();
      }

      tmpTimeSlot = currentStore.selectedTimeSlot;
      suppliers = await _storeDAO.getSuppliers(
          currentStore.id, currentStore.selectedTimeSlot);
      if(blogs == null){
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
      print("Excception: " + e.toString() + stacktrace.toString());
      bool result = await showErrorDialog();
      if (result) {
        await getSuppliers();
      } else
        setState(ViewStatus.Error);
    }
  }

  // Future<void> getMoreSuppliers() async {
  //   try {
  //     setState(ViewStatus.LoadMore);
  //
  //     suppliers += await _storeDAO.getSuppliers(
  //         currentStore.id, currentStore.selectedTimeSlot,
  //         page: _storeDAO.metaDataDTO.page + 1);
  //     await Future.delayed(Duration(microseconds: 500));
  //     // check truong hop product tra ve rong (do khong co menu nao trong TG do)
  //     if (suppliers.isEmpty || suppliers == null) {
  //       setState(ViewStatus.Empty);
  //     } else if (currentUser != null) {
  //       setState(ViewStatus.Completed);
  //     }
  //   } catch (e, stacktrace) {
  //     print("Excception: " + e.toString() + stacktrace.toString());
  //     bool result = await showErrorDialog();
  //     if (result) {
  //       await getMoreSuppliers();
  //     } else
  //       setState(ViewStatus.Error);
  //   }
  // }

  Future<void> getGifts() async {
    try {
      if (status != ViewStatus.Loading) {
        setState(ViewStatus.Loading);
      }

      if (currentStore == null) {
        currentStore = await getStore();
      }

      gifts = await _productDAO.getGifts(
          currentStore.id, currentStore.selectedTimeSlot);
      await Future.delayed(Duration(microseconds: 500));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e, stacktrace) {
      print("Excception: " + e.toString() + stacktrace.toString());
      bool result = await showErrorDialog();
      if (result) {
        await getGifts();
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> getMoreGifts() async {
    try {
      setState(ViewStatus.LoadMore);

      print("Get products...");
      gifts += await _productDAO.getGifts(
          currentStore.id, currentStore.selectedTimeSlot,
          page: _productDAO.metaDataDTO.page + 1);

      await Future.delayed(Duration(milliseconds: 1000));
      // check truong hop product tra ve rong (do khong co menu nao trong TG do)
      setState(ViewStatus.Completed);
    } catch (e, stacktrace) {
      print("Excception: " + e.toString() + stacktrace.toString());
      bool result = await showErrorDialog();
      if (result) {
        await getMoreGifts();
      } else
        setState(ViewStatus.Error);
    }
  }

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
            print("Changing index...");
            showLoadingDialog();
            currentStore = BussinessHandler.setSelectedTime(tmpStore);
            await deleteCart();
            await setStore(currentStore);
            HomeViewModel.getInstance().notifyListeners();
            hideDialog();
            await getSuppliers();
            await getGifts();
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

  Future<void> selectSupplier(SupplierDTO dto) async {
    if (dto.available) {
      await Get.toNamed(RouteHandler.HOME_DETAIL, arguments: dto);
    } else {
      showStatusDialog("assets/images/global_error.png", "Opps",
          "Cửa hàng đang tạm đóng 😓");
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
        await getSuppliers();
        await getGifts();
      }
    }
  }

  Future<void> fetchStore() async {
    if (status != ViewStatus.Loading) {
      setState(ViewStatus.Loading);
    }
    StoreDAO _storeDAO = new StoreDAO();
    Function eq = const ListEquality().equals;
    List<CampusDTO> listStore;
    CampusDTO campus = await getStore();

    if (campus == null) {
      listStore = await _storeDAO.getStores(id: UNIBEAN_STORE);
      campus = BussinessHandler.setSelectedTime(listStore[0]);
    } else {
      listStore = await _storeDAO.getStores(id: campus.id);
      campus.timeSlots = listStore[0].timeSlots;
      bool found = false;
      campus.timeSlots.forEach((element) {
        if (element.menuId == campus.selectedTimeSlot.menuId && element.from == campus.selectedTimeSlot.from && element.to == campus.selectedTimeSlot.to) {
          campus.selectedTimeSlot.available = element.available;
          found = true;
        }
      });
      if (found == false) {
        await deleteCart();
        campus = BussinessHandler.setSelectedTime(campus);
        await showStatusDialog(
            "assets/images/global_error.png",
            "Khung giờ đã thay đổi",
            "Các sản phẩm trong giỏ hàng đã bị xóa, còn nhiều món ngon đang chờ bạn nhé");
      }
    }

    await setStore(campus);

    List<LocationDTO> locations = await _storeDAO.getLocations(campus.id);
    if (!eq(locations, campus.locations)) {
      campus.locations.forEach((location) {
        if (location.isSelected) {
          locations.forEach((element) {
            if (element.id == location.id) {
              element.isSelected = true;
            }
          });
        }
      });

      campus.locations = locations;
      await setStore(campus);
    }
  }

}
