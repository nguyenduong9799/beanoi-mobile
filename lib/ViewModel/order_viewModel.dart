import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderAmountDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Services/analytic_service.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/order_status.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/route_constraint.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';
import '../constraints.dart';

class OrderViewModel extends BaseModel {
  OrderAmountDTO orderAmount;
  Map<String, dynamic> listPayments;
  LocationDTO location, tmpLocation;
  CampusDTO campusDTO;
  OrderDAO dao;
  Cart currentCart;

  OrderViewModel() {
    dao = new OrderDAO();
  }

  Future<void> prepareOrder() async {
    try {
      if (!Get.isDialogOpen) {
        setState(ViewStatus.Loading);
      }

      if (campusDTO == null) {
        campusDTO = await getStore();
      }

      if (location == null) {
        campusDTO.locations.forEach((element) {
          if (element.isSelected) {
            location = element;
          }
        });
      }

      if (currentCart == null) {
        currentCart = await getCart();
      }

      orderAmount = await dao.prepareOrder(campusDTO.id, currentCart);
      if (listPayments == null) {
        listPayments = await dao.getPayments();
      }

      await Future.delayed(Duration(milliseconds: 500));
      hideDialog();
      setState(ViewStatus.Completed);
    } catch (e, stacktra) {
      print(stacktra.toString());
      bool result = await showErrorDialog();
      if (result) {
        await prepareOrder();
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> updateQuantity(CartItem item) async {
    // showLoadingDialog();
    if (item.master.type == ProductType.GIFT_PRODUCT) {
      int originalQuantity = 0;
      if (AccountViewModel.getInstance().currentUser == null) {
        await AccountViewModel.getInstance().fetchUser();
      }
      double totalBean = AccountViewModel.getInstance().currentUser.point;

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
        await showStatusDialog("assets/images/global_error.png", "ERR_BALANCE",
            "Số bean hiện tại không đủ");
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
      int option = await showOptionDialog("Xác nhận giỏ hàng nha bạn 😊");

      if (option != 1) {
        return;
      }

      showLoadingDialog();

      OrderStatus result = await dao.createOrders(location.id, currentCart);
      await AccountViewModel.getInstance().fetchUser();
      if (result.statusCode == 200) {
        await deleteCart();
        hideDialog();
        await showStatusDialog(
            "assets/images/global_sucsess.png", result.code, result.message);
        Get.offAndToNamed(
          RouteHandler.ORDER_HISTORY_DETAIL,
          arguments: result.order,
        );
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
    await setCart(currentCart);
    await prepareOrder();
  }

  Future<void> deleteItem(CartItem item) async {
    // showLoadingDialog();
    bool result = await removeItemFromCart(item);
    if (result) {
      await AnalyticsService.getInstance()
          .logChangeCart(item.master, item.quantity, false);
      hideDialog();
      Get.back(result: false);
    } else {
      currentCart = await getCart();
      await prepareOrder();
    }
  }

  Future<void> processChangeLocation() async {
    tmpLocation = location;
    notifyListeners();
    await changeLocationDialog(this);
  }

  // void selectReceiveTime(String value){
  //   isChangeTime = true;
  //   receiveTime = value;
  //   notifyListeners();
  // }

  // void confirmReceiveTime(){
  //   isChangeTime = false;
  //   notifyListeners();
  // }

  void selectLocation(int id) {
    campusDTO.locations.forEach((element) {
      if (element.id == id) {
        tmpLocation = element;
      }
    });
    notifyListeners();
  }

  Future<void> confirmLocation() async {
    campusDTO.locations.forEach((element) {
      if (element.id == tmpLocation.id) {
        element.isSelected = true;
      } else {
        element.isSelected = false;
      }
    });
    await setStore(campusDTO);
    location = tmpLocation;
    notifyListeners();
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
          currentCart.notes = List();
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
}
