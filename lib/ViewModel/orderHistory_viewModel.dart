import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DAO/OrderDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/utils/enum.dart';

enum OrderFilter { ORDERING, DONE }

class OrderHistoryViewModel extends Model {
  List<OrderDTO> orders;
  Status status;
  OrderDAO _orderDAO;

  OrderHistoryViewModel() {
    status = Status.Loading;
    _orderDAO = OrderDAO();
  }

  Future<void> getOrders(OrderFilter filter) async {
    status = Status.Loading;
    notifyListeners();
    final data = await _orderDAO.getOrders(filter);

    orders = data;
    status = Status.Completed;
    notifyListeners();
  }

  Future<void> getOrderDetail(int orderId) async {
    // get order detail
  }

  void normalizeOrders(List<OrderDTO> orders) {}
}
