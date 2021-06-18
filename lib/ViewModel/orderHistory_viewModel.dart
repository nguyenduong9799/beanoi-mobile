import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DAO/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';

import 'index.dart';

class OrderHistoryViewModel extends BaseModel {
  List<OrderListDTO> orderThumbnail;
  OrderDAO _orderDAO;
  dynamic error;
  OrderDTO orderDetail;
  Map<String, dynamic> listPayments;
  ScrollController scrollController;
  List<bool> selections = [true, false];

  OrderDTO newTodayOrder;

  OrderHistoryViewModel() {
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
    try {
      int option = await showOptionDialog("Hãy thử những món khác bạn nhé 😥.");
      if (option == 1) {
        showLoadingDialog();
        CampusDTO storeDTO = await getStore();
        final success = await _orderDAO.cancelOrder(
          orderId,
          storeDTO.id,
        );

        if (success) {
          clearNewOrder(orderId);
          await showStatusDialog("assets/images/global_sucsess.png",
              "Thành công", "Hãy xem thử các món khác bạn nhé 😓");
          Get.back();
          await getOrders();
        } else {
          await showStatusDialog(
            "assets/images/global_error.png",
            "Thất bại",
            "Chưa hủy đươc đơn bạn vui lòng thử lại nhé 😓",
          );
        }
      }
    } catch (e) {
      await showStatusDialog(
        "assets/images/global_error.png",
        "Thất bại",
        "Chưa hủy đươc đơn bạn vui lòng thử lại nhé 😓",
      );
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
      if (result) {
        await getOrders();
      } else
        setState(ViewStatus.Error);
    } finally {}
  }

  void clearNewOrder(int orderId) {
    if (newTodayOrder?.id == orderId) {
      newTodayOrder = null;
      notifyListeners();
    }
  }

  Future<void> getNewOrder() async {
    try {
      setState(ViewStatus.Loading);
      final data = await _orderDAO.getOrders(OrderFilter.NEW);
      final currentDateData = data?.firstWhere(
          (orderSummary) =>
              DateTime.parse(orderSummary.checkInDate)
                  .difference(DateTime.now())
                  .inDays ==
              0,
          orElse: () => null);
      if (currentDateData != null) {
        newTodayOrder = currentDateData.orders.first;
      }
      setState(ViewStatus.Completed);
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await getNewOrder();
      } else
        setState(ViewStatus.Error);
    } finally {}
  }

  Future<void> closeNewOrder() async {
    newTodayOrder = null;
    notifyListeners();
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
    } catch (e) {
      bool result = await showErrorDialog();
      if (result) {
        await getOrderDetail(orderId);
      } else
        setState(ViewStatus.Error);
    }
  }
}
