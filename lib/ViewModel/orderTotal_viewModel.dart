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

  // double countPrice(Cart cart) {
  //   double total = 0;
  //   for (CartItem item in cart.items) {
  //     double subTotal = 0;
  //     if (item.master.type != ProductType.MASTER_PRODUCT) {
  //       subTotal =
  //           BussinessHandler.countPrice(item.master.prices, item.quantity);
  //     }
  //
  //     for (ProductDTO dto in item.products) {
  //       subTotal += BussinessHandler.countPrice(dto.prices, item.quantity);
  //     }
  //     total += subTotal;
  //   }
  //   total += DELIVERY_FEE;
  //   return total;
  // }

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
    await prepareOrder();
  }

  Future<void> orderCart() async {
    try {
      showLoadingDialog();
      StoreDTO storeDTO = await getStore();
      // LOG ORDER

      OrderStatus result =
          await dao.createOrders(orderNote, storeDTO.id, payment);
      if (result == OrderStatus.Success) {
        await deleteCart();
        hideDialog();
        Get.back(result: true);
      } else if (result == OrderStatus.Fail) {
        hideDialog();
        await showStatusDialog("assets/images/global_error.png", "Thất bại :(",
            "Vui lòng thử lại sau");
      } else if (result == OrderStatus.NoMoney) {
        hideDialog();
        await RootViewModel.getInstance().fetchUser(true);
        await showStatusDialog("assets/images/global_error.png", "Thất bại :(",
            "Có đủ tiền đâu mà mua (>_<)");
      } else if (result == OrderStatus.Timeout) {
        hideDialog();
        await showStatusDialog("assets/images/global_error.png", "Thất bại :(",
            "Hết giờ rồi bạn ơi, mai đặt sớm nhen <3");
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
      await prepareOrder();
      hideDialog();
    }
  }
}
