import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/acessories/dash_border.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/utils/enum.dart';
import 'package:unidelivery_mobile/utils/index.dart';

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({Key key}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<bool> _selections = [true, false];

  OrderHistoryViewModel model = OrderHistoryViewModel();

  @override
  void initState() {
    super.initState();
    orderHandler();
  }

  Future<void> orderHandler() async {
    OrderFilter filter =
        _selections[0] ? OrderFilter.ORDERING : OrderFilter.DONE;
    try {
      await model.getOrders(filter);
    } catch (e) {} finally {}
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OrderHistoryViewModel>(
      model: model,
      child: Scaffold(
        appBar: DefaultAppBar(
          title: "Lịch sử",
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                // color: Colors.amber,
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Center(
                  child: ToggleButtons(
                    renderBorder: false,
                    selectedColor: kPrimary,
                    onPressed: (int index) async {
                      setState(() {
                        _selections = _selections.map((e) => false).toList();
                        _selections[index] = true;
                      });
                      await orderHandler();
                    },
                    borderRadius: BorderRadius.circular(24),
                    isSelected: _selections,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          "Đang giao",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          "Hoàn thành",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                child: _buildOrders(),
                color: Color(0xffefefef),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrders() {
    return ScopedModelDescendant<OrderHistoryViewModel>(
        builder: (context, child, model) {
      final status = model.status;
      final orderSummaryList = model.orderThumbnail;
      if (status == Status.Loading)
        return Center(
          child: TextLiquidFill(
            text: 'Đang tải',
            waveColor: kPrimary,
            boxBackgroundColor: kBackgroundGrey[3],
            textStyle: TextStyle(
              fontSize: 45.0,
              fontWeight: FontWeight.bold,
            ),
            boxHeight: 300.0,
          ),
        );
      else if (status == Status.Empty || orderSummaryList == null)
        return Container(
          child: SvgPicture.asset(
            'assets/images/order_history.svg',
            semanticsLabel: 'Acme Logo',
            fit: BoxFit.cover,
          ),
        );
      if (status == Status.Error)
        return Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: Text(model.error.toString()),
          ),
        );

      return Container(
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            ...orderSummaryList
                .map((orderSummary) => _buildOrderSummary(orderSummary))
                .toList(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Bạn đã xem hết rồi đây :)",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOrderSummary(OrderListDTO orderSummary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 16),
          child: Text(
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(orderSummary.checkInDate)),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        ...orderSummary.orders.reversed
            .toList()
            .map((order) => _buildOrderItem(order, context))
            .toList(),
      ],
    );
  }

  Widget _buildOrderItem(OrderDTO order, BuildContext context) {
    return Container(
      // height: 80,
      margin: EdgeInsets.fromLTRB(8, 0, 8, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          // side: BorderSide(color: Colors.red),
        ),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                _settingModalBottomSheet(context, order.id);
              },
              contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${order.itemQuantity} món",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "FPT University",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${formatPrice(order.total + 5000)}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: kPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Text("Chi tiết", style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context, orderId) {
    // get orderDetail

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        builder: (BuildContext bc) {
          // final status = model.status;

          // if (status == Status.Loading)
          //   return AspectRatio(
          //     aspectRatio: 1,
          //     child: Center(child: CircularProgressIndicator()),
          //   );

          // final orderDetail = model.orderDetail;
          return OrderDetailBottomSheet(
            orderId: orderId,
          );
        });
  }
}

class OrderDetailBottomSheet extends StatefulWidget {
  final int orderId;
  const OrderDetailBottomSheet({
    Key key,
    this.orderId,
  }) : super(key: key);

  @override
  _OrderDetailBottomSheetState createState() => _OrderDetailBottomSheetState();
}

class _OrderDetailBottomSheetState extends State<OrderDetailBottomSheet> {
  final orderDetailModel = OrderHistoryViewModel();

  @override
  void initState() {
    super.initState();
    orderDetailModel.getOrderDetail(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        // color: Colors.grey,
      ),
      height: 450,
      child: ScopedModel<OrderHistoryViewModel>(
        model: orderDetailModel,
        child: ScopedModelDescendant<OrderHistoryViewModel>(
          builder: (context, child, model) {
            final status = model.status;
            if (status == Status.Loading)
              return AspectRatio(
                aspectRatio: 1,
                child: Center(child: CircularProgressIndicator()),
              );

            final orderDetail = model.orderDetail;
            return Column(
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      width: 85,
                      child: orderDetail.status == OrderFilter.ORDERING
                          ? TyperAnimatedTextKit(
                              speed: Duration(milliseconds: 100),
                              onTap: () {
                                print("Tap Event");
                              },
                              text: ['Đang giao...'],
                              textStyle: TextStyle(
                                  fontFamily: "Bobbers", color: Colors.amber),
                              textAlign: TextAlign.start,
                              alignment: AlignmentDirectional
                                  .topStart // or Alignment.topLeft
                              )
                          : Text(
                              'Đã nhận hàng',
                              style: TextStyle(
                                color: kPrimary,
                              ),
                            ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Divider(),
                      ),
                    ),
                    Text(
                      'Menu',
                      style: TextStyle(color: Colors.black45),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Divider(),
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm dd/MM')
                          .format(DateTime.parse(orderDetail.orderTime)),
                      style: TextStyle(color: Colors.black45),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildOrderSummaryList(orderDetail),
                  ),
                ),
                layoutSubtotal(orderDetail),
              ],
            );
          },
        ),
      ),
    );
  }

  ListView buildOrderSummaryList(OrderDTO orderDetail) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final orderMaster = orderDetail.orderItems[index];
        final orderChilds = orderMaster.productChilds;

        double orderItemPrice = orderMaster.amount;
        orderChilds?.forEach((element) {
          orderItemPrice += element.amount;
        });
        // orderItemPrice *= orderMaster.quantity;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${orderMaster.quantity}x",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderMaster.masterProductName.contains("Extra")
                              ? orderMaster.masterProductName
                                  .replaceAll("Extra", "+")
                              : orderMaster.masterProductName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ...orderChilds
                            .map(
                              (child) => Text(
                                child.masterProductName.contains("Extra")
                                    ? child.masterProductName
                                        .replaceAll("Extra", "+")
                                    : child.masterProductName,
                                style: TextStyle(fontSize: 12),
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ),
                Text("${formatPrice(orderItemPrice)}"),
              ],
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: orderDetail.orderItems.length,
    );
  }

  Widget layoutSubtotal(OrderDTO orderDetail) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      // margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: kBackgroundGrey[0],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tổng tiền",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: kBackgroundGrey[4]),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tạm tính",
                        style: TextStyle(),
                      ),
                      Text("${formatPrice(orderDetail.total)}"),
                    ],
                  ),
                ),
                MySeparator(),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Phí vận chuyển", style: TextStyle()),
                      Text("${formatPrice(5000)}", style: TextStyle()),
                    ],
                  ),
                ),
                Divider(color: Colors.black),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tổng cộng",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${formatPrice(orderDetail.total + 5000)}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
