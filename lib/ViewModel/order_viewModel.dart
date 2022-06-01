import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Services/analytic_service.dart';
import 'package:unidelivery_mobile/Utils/index.dart';

import 'index.dart';

class OrderViewModel extends BaseModel {
  List<VoucherDTO> vouchers;

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

  OrderViewModel() {
    dao = new OrderDAO();
    promoDao = new PromotionDAO();
    _collectionDAO = CollectionDAO();
    loadingUpsell = false;
  }

  Future<void> getVouchers() async {
    final voucherList = [
      VoucherDTO(
          promotionId: "cfc3bac5-cf91-4fe9-a4a6-fa145beeb038",
          promotionTierId: "6c7ad765-f537-4249-a6c4-27c9c5b7d98c",
          promotionName: "Giam 50%",
          promotionCode: "GIAMGIA50",
          actionName: "Giam 50%",
          voucherName: "Giam Gia 50%",
          imgUrl: "",
          voucherCode: "GIAMGIA500-163I2"),
      VoucherDTO(
          promotionId: "cfc3bac5-cf91-4fe9-a4a6-fa145beeb038",
          promotionTierId: "6c7ad765-f537-4249-a6c4-27c9c5b7d98c",
          promotionName: "Giam 50%",
          promotionCode: "GIAMGIA50",
          actionName: "Giam 50%",
          voucherName: "Giam Gia 50%",
          imgUrl: "",
          voucherCode: "GIAMGIA500-163I2"),
      VoucherDTO(
          promotionId: "cfc3bac5-cf91-4fe9-a4a6-fa145beeb038",
          promotionTierId: "6c7ad765-f537-4249-a6c4-27c9c5b7d98c",
          promotionName: "Giam 50%",
          promotionCode: "GIAMGIA50",
          actionName: "Giam 50%",
          voucherName: "Giam Gia 50%",
          imgUrl: "",
          voucherCode: "GIAMGIA500-163I2"),
      VoucherDTO(
          promotionId: "cfc3bac5-cf91-4fe9-a4a6-fa145beeb038",
          promotionTierId: "6c7ad765-f537-4249-a6c4-27c9c5b7d98c",
          promotionName: "Giam 50%",
          promotionCode: "GIAMGIA50",
          actionName: "Giam 50%",
          voucherName: "Giam Gia 50%",
          imgUrl: "",
          voucherCode: "GIAMGIA500-163I2"),
      VoucherDTO(
          promotionId: "cfc3bac5-cf91-4fe9-a4a6-fa145beeb038",
          promotionTierId: "6c7ad765-f537-4249-a6c4-27c9c5b7d98c",
          promotionName: "Giam 50%",
          promotionCode: "GIAMGIA50",
          actionName: "Giam 50%",
          voucherName: "Giam Gia 50%",
          imgUrl: "",
          voucherCode: "GIAMGIA500-163I2"),
      VoucherDTO(
          promotionId: "cfc3bac5-cf91-4fe9-a4a6-fa145beeb038",
          promotionTierId: "6c7ad765-f537-4249-a6c4-27c9c5b7d98c",
          promotionName: "Giam 50%",
          promotionCode: "GIAMGIA50",
          actionName: "Giam 50%",
          voucherName: "Giam Gia 50%",
          imgUrl: "",
          voucherCode: "GIAMGIA500-163I2"),
      VoucherDTO(
          promotionId: "cfc3bac5-cf91-4fe9-a4a6-fa145beeb038",
          promotionTierId: "6c7ad765-f537-4249-a6c4-27c9c5b7d98c",
          promotionName: "Giam 50%",
          promotionCode: "GIAMGIA50",
          actionName: "Giam 50%",
          voucherName: "Giam Gia 50%",
          imgUrl: "",
          voucherCode: "GIAMGIA500-163I2"),
    ];

    // final voucherList = await promoDao.getPromotions();
    vouchers = voucherList;
    notifyListeners();
  }

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

      orderAmount = await dao.prepareOrder(campusDTO.id, currentCart);
      errorMessage = null;
      await Future.delayed(Duration(milliseconds: 500));
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
    currentCart.addVoucher(voucher);
    // call prepare
    await prepareOrder();
  }

  Future<void> unselectVoucher(VoucherDTO voucher) async {
    // add voucher to cart
    currentCart.removeVoucher(voucher);
    // call prepare
    prepareOrder();
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
        await deleteCart();
        hideDialog();
        await showStatusDialog(
            "assets/images/global_sucsess.png", result?.code, result?.message);
        await Get.find<OrderHistoryViewModel>().getNewOrder();
        Get.offAndToNamed(
          RouteHandler.ORDER_HISTORY_DETAIL,
          arguments: result.order,
        );
        prepareOrder();
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
      var currentStore = root.currentStore;
      if (root.status == ViewStatus.Error) {
        setState(ViewStatus.Error);
        return;
      }
      if (currentStore.selectedTimeSlot == null) {
        upSellCollections = null;
        setState(ViewStatus.Completed);
        return;
      }
      upSellCollections = await _collectionDAO
          .getCollections(currentStore.selectedTimeSlot, params: {
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
}
