import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DAO/OrderDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';

enum OrderFilter { ORDERING, DONE }

class OrderHistoryViewModel extends Model {
  List<OrderListDTO> orderThumbnail;
  ViewStatus status;
  OrderDAO _orderDAO;
  dynamic error;
  OrderDTO orderDetail;

  OrderHistoryViewModel() {
    status = ViewStatus.Loading;
    _orderDAO = OrderDAO();
  }

  Future<void> getOrders(OrderFilter filter) async {
    try {
      status = ViewStatus.Loading;
      notifyListeners();
      final data = await _orderDAO.getOrders(filter);

      orderThumbnail = data;
      status = ViewStatus.Completed;
      notifyListeners();
    } catch (e) {
      status = ViewStatus.Error;
      error = e.toString();
      notifyListeners();
    } finally {}
  }

  Future<void> getOrderDetail(int orderId) async {
    // get order detail
    try {
      status = ViewStatus.Loading;
      notifyListeners();
      final data = await _orderDAO.getOrderDetail(orderId);

      orderDetail = data;
      status = ViewStatus.Completed;
      notifyListeners();
    } catch (e) {
      status = ViewStatus.Error;
      error = e.toString();
      notifyListeners();
    } finally {}
  }

  void normalizeOrders(List<OrderDTO> orders) {}
}
