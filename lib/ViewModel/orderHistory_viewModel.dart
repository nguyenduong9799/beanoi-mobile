import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DAO/OrderDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/utils/enum.dart';

enum OrderFilter { ORDERING, DONE }

class OrderHistoryViewModel extends Model {
  List<OrderListDTO> orderThumbnail;
  Status status;
  OrderDAO _orderDAO;
  dynamic error;
  OrderDTO orderDetail;

  OrderHistoryViewModel() {
    status = Status.Loading;
    _orderDAO = OrderDAO();
  }

  Future<void> getOrders(OrderFilter filter) async {
    try {
      status = Status.Loading;
      notifyListeners();
      final data = await _orderDAO.getOrders(filter);

      orderThumbnail = data;
      status = Status.Completed;
      notifyListeners();
    } catch (e) {
      status = Status.Error;
      error = e.toString();
      notifyListeners();
    } finally {}
  }

  Future<void> getOrderDetail(int orderId) async {
    // get order detail
    try {
      status = Status.Loading;
      notifyListeners();
      final data = await _orderDAO.getOrderDetail(orderId);

      orderDetail = data;
      status = Status.Completed;
      notifyListeners();
    } catch (e) {
      status = Status.Error;
      error = e.toString();
      notifyListeners();
    } finally {}
  }

  void normalizeOrders(List<OrderDTO> orders) {}
}
