import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/GiftDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Services/analytic_service.dart';
import 'package:unidelivery_mobile/Utils/index.dart';

import 'index.dart';

class OrderViewModel extends BaseModel {
  List<VoucherDTO> vouchers;
  List<GiftDTO> myVouchers;
  OrderAmountDTO orderAmount;
  Map<String, dynamic> listPayments;
  CampusDTO campusDTO;
  OrderDAO dao;
  PromotionDAO promoDao;
  Cart currentCart;
  CollectionDAO _collectionDAO;
  List<CollectionDTO> upSellCollections;
  bool loadingUpsell;
  String errorMessage = null;

  List<String> listError = <String>[];
  List<bool> selections = [true, false];

  OrderViewModel() {
    dao = new OrderDAO();
    promoDao = new PromotionDAO();
    _collectionDAO = CollectionDAO();
    loadingUpsell = false;
    currentCart = null;
  }

  // Future<void> changeStatus(int index) async {
  //   selections = selections.map((e) => false).toList();
  //   selections[index] = true;
  //   notifyListeners();
  //   if (selections[0] == true) {
  //     await Get.find<PromoViewModel>().getMyVouchers();
  //   }

  //   await Get.find<PromoViewModel>().getVouchers();
  // }

  // Future<void> getMyVouchers() async {
  //   setState(ViewStatus.Loading);
  //   final myVoucherList = await promoDao.getMyPromotions();
  //   myVouchers = myVoucherList;
  //   setState(ViewStatus.Completed);
  // }

  // Future<void> getVouchers() async {
  //   setState(ViewStatus.Loading);
  //   final voucherList = await promoDao.getPromotions();
  //   vouchers = voucherList;
  //   setState(ViewStatus.Completed);
  // }

  Future<void> prepareOrder() async {
    try {
      if (!Get.isDialogOpen) {
        setState(ViewStatus.Loading);
      }

      if (campusDTO == null) {
        RootViewModel root = Get.find<RootViewModel>();
        campusDTO = root.currentStore;
      }

      currentCart = await getCart();
      if (listPayments == null) {
        listPayments = await dao.getPayments();
      }
      if (currentCart.payment == null) {
        if (listPayments.values.contains(1)) {
          currentCart.payment = PaymentTypeEnum.Cash;
        }
      }
      if (currentCart.timeSlotId == null) {
        if (Get.find<RootViewModel>().listAvailableTimeSlots.isNotEmpty) {
          currentCart.timeSlotId =
              Get.find<RootViewModel>().listAvailableTimeSlots[0].id;
        } else {
          errorMessage = "Hiện tại đã hết khung giờ giao hàng";
        }
      }

      listError.clear();
      orderAmount = await dao.prepareOrder(campusDTO.id, currentCart);
      errorMessage = null;
      hideDialog();
      setState(ViewStatus.Completed);
    } on DioError catch (e, stacktra) {
      print(stacktra.toString());
      if (e.response.statusCode == 400) {
        String errorMsg = e.response.data["message"];
        errorMessage = errorMsg;
        if (e.response.data['data'] != null) {
          orderAmount = OrderAmountDTO.fromJson(e.response.data['data']);
        }

        setState(ViewStatus.Completed);
      } else if (e.response.statusCode == 404) {
        if (e.response.data["error"] != null) {
          String voucherError;
          currentCart.removeVoucher();
          setCart(currentCart);
          orderAmount = await dao.prepareOrder(campusDTO.id, currentCart);
          setState(ViewStatus.Completed);
          // await showErrorDialog(
          //     errorTitle: e.response.data["error"]["message"]);

          // Get.rawSnackbar(
          //     messageText: Container(
          //       child: Text(
          //         e.response.data["error"]["message"],
          //         style: TextStyle(color: Colors.black, fontSize: 16),
          //       ),
          //     ),
          //     duration: Duration(days: 365),
          //     snackPosition: SnackPosition.BOTTOM,
          //     margin: EdgeInsets.only(bottom: 103),
          //     borderRadius: 8,
          //     backgroundColor: Colors.white);
          voucherError = e.response.data["error"]["message"];
          listError.add(voucherError);
        }
      } else {
        bool result = await showErrorDialog();
        if (result) {
          await prepareOrder();
        } else {
          setState(ViewStatus.Error);
        }
      }
    }
  }

  Future<void> selectVoucher(VoucherDTO voucher) async {
    // add voucher to cart
    // showLoadingDialog();
    currentCart.addVoucher(voucher);
    await setCart(currentCart);
    // call prepare
    await prepareOrder();
    // hideDialog();
  }

  Future<void> unselectVoucher(VoucherDTO voucher) async {
    // add voucher to cart
    currentCart.removeVoucher();
    await setCart(currentCart);
    // call prepare
    await prepareOrder();
  }

  Future<void> updateQuantity(CartItem item) async {
    // showLoadingDialog();
    if (item.master.type == ProductType.GIFT_PRODUCT) {
      int originalQuantity = 0;
      AccountViewModel account = Get.find<AccountViewModel>();
      if (account.currentUser == null) {
        await account.fetchUser();
      }
      double totalBean = account.currentUser.point;

      currentCart.items.forEach((element) {
        if (element.master.type == ProductType.GIFT_PRODUCT) {
          if (element.master.id != item.master.id) {
            totalBean -= (element.master.price * element.quantity);
          } else {
            originalQuantity = element.quantity;
          }
        }
      });

      if (totalBean < (item.master.price * item.quantity)) {
        await showStatusDialog("assets/images/global_error.png",
            "Không đủ bean", "Số bean hiện tại không đủ");
        item.quantity = originalQuantity;
        hideDialog();
        return;
      }
    }

    await updateItemFromCart(item);
    await prepareOrder();
  }

  Future<void> orderCart() async {
    try {
      int option =
          await showOptionDialog("Bạn vui lòng xác nhận lại giỏ hàng nha 😊.");

      if (option != 1) {
        return;
      }
      showLoadingDialog();
      LocationDTO location =
          campusDTO.locations.firstWhere((element) => element.isSelected);

      DestinationDTO destination =
          location.destinations.firstWhere((element) => element.isSelected);
      OrderStatus result = await dao.createOrders(destination.id, currentCart);
      await Get.find<AccountViewModel>().fetchUser();
      if (result.statusCode == 200) {
        await removeCart();
        hideDialog();
        await showStatusDialog(
            "assets/images/global_sucsess.png", result?.code, result?.message);
        await Get.find<OrderHistoryViewModel>().getNewOrder();
        Get.offAndToNamed(
          RouteHandler.ORDER_HISTORY_DETAIL,
          arguments: result.order,
        );
        // prepareOrder();
        // Get.back(result: true);
      } else {
        hideDialog();
        await showStatusDialog(
            "assets/images/global_error.png", result.code, result.message);
      }
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await orderCart();
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> changeOption(int option) async {
    // showLoadingDialog();
    currentCart.payment = option;
    showLoadingDialog();
    await setCart(currentCart);
    await prepareOrder();
    hideDialog();
  }

  Future<void> deleteItem(CartItem item) async {
    // showLoadingDialog();
    print("Delete item...");
    bool result;

    result = await removeItemFromCart(item);
    print("Result: $result");
    if (result) {
      await AnalyticsService.getInstance()
          .logChangeCart(item.master, item.quantity, false);
      Get.back(result: false);
      await prepareOrder();
    } else {
      currentCart = await getCart();
      await prepareOrder();
    }
  }

  Future<void> changeLocationOfStore() async {
    setState(ViewStatus.Loading);
    await Get.bottomSheet(
      HomeLocationSelect(
        selectedCampus: campusDTO,
      ),
    );
    RootViewModel root = Get.find<RootViewModel>();
    campusDTO = root.currentStore;
    setState(ViewStatus.Completed);
  }

  Future<void> changeTime(TimeSlots option) async {
    showLoadingDialog();
    currentCart.timeSlotId = option.id;

    await setCart(currentCart);
    await prepareOrder();
    hideDialog();
  }

  Future<void> addSupplierNote(int id) async {
    SupplierNoteDTO supplierNote = currentCart.notes?.firstWhere(
      (element) => element.supplierId == id,
      orElse: () => null,
    );
    String note = await inputDialog("Ghi chú cho cửa hàng 🏪", "Xác nhận",
        value: supplierNote?.content);
    bool update = true;
    if (supplierNote != null) {
      if (note != null && note.isNotEmpty) {
        supplierNote.content = note;
      } else {
        currentCart.notes.remove(supplierNote);
      }
    } else {
      if (note != null && note.isNotEmpty) {
        if (currentCart.notes == null) {
          currentCart.notes = [];
        }
        currentCart.notes.add(SupplierNoteDTO(content: note, supplierId: id));
      } else {
        update = false;
      }
    }
    if (update) {
      setCart(currentCart);
    }
    notifyListeners();
  }

  Future<void> getUpSellCollections() async {
    try {
      loadingUpsell = true;
      RootViewModel root = Get.find<RootViewModel>();
      // var currentStore = root.currentStore;
      var currentMenu = root.selectedMenu;
      if (root.status == ViewStatus.Error) {
        setState(ViewStatus.Error);
        return;
      }
      if (currentMenu == null) {
        upSellCollections = null;
        setState(ViewStatus.Completed);
        return;
      }
      upSellCollections = await _collectionDAO
          .getCollections(currentMenu.menuId, params: {
        "show-on-home": false,
        "type": CollectionTypeEnum.Suggestion
      });
      await Future.delayed(Duration(microseconds: 500));
      loadingUpsell = false;
    } catch (e) {
      upSellCollections = null;
      loadingUpsell = false;
    }
  }

  Future<void> removeCart() async {
    await deleteCart();
    currentCart = null;
    notifyListeners();
  }
}
