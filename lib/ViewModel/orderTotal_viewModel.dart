import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderAmountDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/StoreDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Services/analytic_service.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/order_status.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

class OrderViewModel extends BaseModel {
  AnalyticsService _analyticsService;
  int payment;
  String orderNote;
  OrderAmountDTO orderAmount;
  static OrderViewModel _instance;

  static OrderViewModel getInstance() {
    if (_instance == null) {
      _instance = OrderViewModel();
    }
    return _instance;
  }

  static void destroyInstance() {
    _instance = null;
  }

  OrderDAO dao;

  OrderViewModel() {
    _analyticsService = AnalyticsService.getInstance();
    dao = new OrderDAO();
  }

  Future<Cart> get cart async {
    return await getCart();
  }


  Future<void> prepareOrder() async {
    try {
      if(!Get.isDialogOpen && status != ViewStatus.Loading){
        showLoadingDialog();
      }

      StoreDTO storeDTO = await getStore();
      // LOG ORDER

      orderAmount =
          await dao.prepareOrder(orderNote, storeDTO.id, payment);
    } catch (e, stacktra) {
      print(stacktra.toString());
      bool result = await showErrorDialog();
      if (result) {
        await prepareOrder();
      } else
        setState(ViewStatus.Error);
    } finally {
      hideDialog();
      notifyListeners();
    }
  }

  Future<void> updateQuantity(CartItem item) async {
    showLoadingDialog();
    await updateItemFromCart(item);
    if(payment != null){
      await prepareOrder();
    }else{
      hideDialog();
      notifyListeners();
    }

  }

  Future<void> orderCart() async {
    try {
      showLoadingDialog();
      StoreDTO storeDTO = await getStore();
      // LOG ORDER

      OrderStatus result =
          await dao.createOrders(orderNote, storeDTO.id, payment);
      if (result.statusCode == 200) {
        await deleteCart();
        hideDialog();
        await showStatusDialog("assets/images/global_sucsess.png", result.code,
            result.message);
        Get.back(result: true);
      } else{
        hideDialog();
        await showStatusDialog("assets/images/global_error.png", result.code,
            result.message);
        await RootViewModel.getInstance().fetchUser();
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
    payment = option;
    await prepareOrder();
  }

  Future<void> checkPayment() async {
    if(payment != null){
      setState(ViewStatus.Loading);
      await prepareOrder();
      setState(ViewStatus.Completed);
    }
  }

  Future<void> deleteItem(CartItem item) async {
    showLoadingDialog();
    bool result = await removeItemFromCart(item);
    if (result) {
      await AnalyticsService.getInstance()
          .logChangeCart(item.master, item.quantity, false);
      hideDialog();
      Get.back(result: false);
    } else {
      if(payment != null){
        await prepareOrder();
      }else{
        hideDialog();
        notifyListeners();
      }

    }
  }
}
