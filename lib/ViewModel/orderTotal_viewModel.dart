import 'package:get/get.dart';
import 'package:unidelivery_mobile/Bussiness/BussinessHandler.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/StoreDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Services/analytic_service.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/order_status.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';
import '../constraints.dart';

class OrderViewModel extends BaseModel {
  AnalyticsService _analyticsService;
  int payment;
  Map<int, String> options = {
    PaymentType.CASH : "Tiền mặt",
    PaymentType.BEAN : "Tiền trong ví"
  };

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

  OrderViewModel() {
    _analyticsService = AnalyticsService.getInstance();
  }

  Future<Cart> get cart async {
    return await getCart();
  }

  double countPrice(Cart cart) {
    double total = 0;
    for (CartItem item in cart.items) {
      double subTotal = 0;
      if (item.master.type != ProductType.MASTER_PRODUCT) {
        subTotal =
            BussinessHandler.countPrice(item.master.prices, item.quantity);
      }

      for (ProductDTO dto in item.products) {
        subTotal += BussinessHandler.countPrice(dto.prices, item.quantity);
      }
      total += subTotal;
    }
    total += DELIVERY_FEE;
    return total;
  }

  Future<void> orderCart(String orderNote, double total) async {
    try {
      showLoadingDialog();
      StoreDTO storeDTO = await getStore();
      OrderDAO dao = new OrderDAO();
      // LOG ORDER

      await _analyticsService.logBeginCheckout(total);

      OrderStatus result =
          await dao.createOrders(orderNote, storeDTO.id, payment);
      if (result == OrderStatus.Success) {
        await _analyticsService.logOrderCreated(total);
        await deleteCart();
        hideDialog();
        Get.back(result: true);
      } else if (result == OrderStatus.Fail) {
        hideDialog();
        await showStatusDialog("assets/images/global_error.png", "Thất bại :(",
            "Vui lòng thử lại sau");
      } else if (result == OrderStatus.NoMoney) {
        hideDialog();
        await RootViewModel.getInstance().fetchUser();
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
        await orderCart(orderNote, total);
      } else
        setState(ViewStatus.Error);
    }
  }

  void changeOption(int option) {
    payment = option;
    notifyListeners();
  }
}
