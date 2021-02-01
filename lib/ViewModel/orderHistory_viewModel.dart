import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Model/DAO/OrderDAO.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/base_model.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

enum OrderFilter { NEW, ORDERING, DONE }

class OrderHistoryViewModel extends BaseModel {
  List<OrderListDTO> orderThumbnail;
  OrderDAO _orderDAO;
  dynamic error;
  OrderDTO orderDetail;
  Map<String, dynamic> listPayments;
  ScrollController scrollController;
  List<bool> selections = [true, false];

  OrderHistoryViewModel() {
    setState(ViewStatus.Loading);
    _orderDAO = OrderDAO();
    scrollController = ScrollController();
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        int total_page = (_orderDAO.metaDataDTO.total / DEFAULT_SIZE).ceil();
        if (total_page > _orderDAO.metaDataDTO.page) {
          await getMoreOrders();
        }
      }
    });
  }

  Future<void> cancelOrder(int orderId) async {
    int option = await showOptionDialog("Thanh xuân như một tách trà");
    if (option == 1) {
      StoreDTO storeDTO = await getStore();
      final success = await _orderDAO.cancelOrder(
        orderId,
        storeDTO.id,
      );

      if (success) {
        await showStatusDialog("assets/images/global_sucsess.png", "Thành công",
            "Hãy xem thử các món khác bạn nhé 😓");
        Get.back();
      } else {
        await showStatusDialog(
          "assets/images/global_error.png",
          "Thất bại",
          "Chưa hủy đươc đơn bạn vui lòng thử lại nhé 😓",
        );
      }
    }
  }

  Future<void> changeStatus(int index) async {
    selections = selections.map((e) => false).toList();
    selections[index] = true;
    notifyListeners();
    await getOrders();
  }

  Future<void> getOrders() async {
    try {
      setState(ViewStatus.Loading);
      OrderFilter filter = selections[0] ? OrderFilter.NEW : OrderFilter.DONE;
      final data = await _orderDAO.getOrders(filter);
      orderThumbnail = data;

      setState(ViewStatus.Completed);
    } catch (e) {
      bool result = await showErrorDialog();
      print(e.toString());
      if (result) {
        await getOrders();
      } else
        setState(ViewStatus.Error);
    } finally {}
  }

  Future<void> getMoreOrders() async {
    try {
      setState(ViewStatus.LoadMore);
      OrderFilter filter =
          selections[0] ? OrderFilter.ORDERING : OrderFilter.DONE;

      final data = await _orderDAO.getOrders(filter,
          page: _orderDAO.metaDataDTO.page + 1);

      orderThumbnail += data;
      await Future.delayed(Duration(milliseconds: 1000));
      setState(ViewStatus.Completed);
    } catch (e) {
      bool result = await showErrorDialog();
      print(e.toString());
      if (result) {
        await getMoreOrders();
      } else
        setState(ViewStatus.Error);
    }
  }

  Future<void> getOrderDetail(int orderId) async {
    // get order detail
    try {
      setState(ViewStatus.Loading);
      final data = await _orderDAO.getOrderDetail(orderId);
      if (listPayments == null) {
        listPayments = await _orderDAO.getPayments();
      }
      orderDetail = data;
      setState(ViewStatus.Completed);
    } catch (e, str) {
      print(str.toString());
      bool result = await showErrorDialog();
      if (result) {
        await getOrderDetail(orderId);
      } else
        setState(ViewStatus.Error);
    }
  }
}
