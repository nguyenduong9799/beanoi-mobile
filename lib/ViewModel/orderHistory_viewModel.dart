import 'package:unidelivery_mobile/Model/DAO/OrderDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';

enum OrderFilter { ORDERING, DONE }

class OrderHistoryViewModel extends BaseModel {
  List<OrderListDTO> orderThumbnail;
  OrderDAO _orderDAO;
  dynamic error;
  OrderDTO orderDetail;

  OrderHistoryViewModel() {
    setState(ViewStatus.Loading);
    _orderDAO = OrderDAO();
  }

  Future<void> getOrders(OrderFilter filter) async {
    try {
      setState(ViewStatus.Loading);
      final data = await _orderDAO.getOrders(filter);

      orderThumbnail = data;
      setState(ViewStatus.Completed);
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await getOrders(filter);
      } else
        setState(ViewStatus.Error);
    } finally {}
  }

  Future<void> getOrderDetail(int orderId) async {
    // get order detail
    try {
      setState(ViewStatus.Loading);
      final data = await _orderDAO.getOrderDetail(orderId);
      orderDetail = data;
      setState(ViewStatus.Completed);
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await getOrderDetail(orderId);
      } else
        setState(ViewStatus.Error);
    } finally {}
  }

  void normalizeOrders(List<OrderDTO> orders) {}
}
