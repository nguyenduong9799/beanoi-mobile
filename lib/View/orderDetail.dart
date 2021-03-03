import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/acessories/dash_border.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/index.dart';

class OrderHistoryDetail extends StatefulWidget {
  final OrderDTO order;

  OrderHistoryDetail({Key key, this.order}) : super(key: key);

  @override
  _OrderHistoryDetailState createState() => _OrderHistoryDetailState();
}

class _OrderHistoryDetailState extends State<OrderHistoryDetail> {
  final orderDetailModel = OrderHistoryViewModel();

  @override
  void initState() {
    super.initState();
    orderDetailModel.getOrderDetail(widget.order.id);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OrderHistoryViewModel>(
      model: OrderHistoryViewModel(),
      child: Scaffold(
        bottomNavigationBar: _buildCancelBtn(),
        appBar: DefaultAppBar(
          title: widget.order.invoiceId.toString(),
          backButton: Container(
            child: IconButton(
              icon: Icon(
                AntDesign.down,
                size: 24,
                color: kPrimary,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
        body: Container(
          width: Get.width,
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            // color: Colors.grey,
          ),
          // height: 500,
          child: ScopedModel<OrderHistoryViewModel>(
            model: orderDetailModel,
            child: ScopedModelDescendant<OrderHistoryViewModel>(
              builder: (context, child, model) {
                final status = model.status;
                if (status == ViewStatus.Loading)
                  return AspectRatio(
                    aspectRatio: 1,
                    child: Center(child: CircularProgressIndicator()),
                  );

                final orderDetail = model.orderDetail;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: Get.width,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kBackgroundGrey[0],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 100,
                                  child: orderDetail.status == OrderFilter.NEW
                                      ? TyperAnimatedTextKit(
                                          speed: Duration(milliseconds: 100),
                                          onTap: () {
                                            print("Tap Event");
                                          },
                                          text: ['Mới ☕'],
                                          textStyle: TextStyle(
                                            fontFamily: "Bobbers",
                                            color: kPrimary,
                                          ),
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
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Divider(),
                                  ),
                                ),
                                Text(
                                  DateFormat('HH:mm dd/MM').format(
                                      DateTime.parse(orderDetail.orderTime)),
                                  style: TextStyle(color: Colors.black45),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("🎯 Nhận đơn tại: "),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    orderDetail.address,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(height: 8),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: kBackgroundGrey[0],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: buildOrderSummaryList(orderDetail),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      layoutSubtotal(orderDetail),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelBtn() {
    OrderFilter status = this.widget.order.status;

    if (status == OrderFilter.NEW) {
      return ScopedModelDescendant<OrderHistoryViewModel>(
          builder: (context, child, model) {
        return FlatButton(
          onPressed: () {
            model.cancelOrder(this.widget.order.id);
          },
          child: Text(
            "Hủy đơn",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        );
      });
    } else if (status == OrderFilter.DONE) {
      return Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Text(
          'Bạn đã có buổi cơm ngon miệng phải hông 😋',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Text(
          'Các đầu bếp đang chuẩn bị cho bạn đó 🥡',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      );
    }
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
        Widget displayPrice = Text("${formatPrice(orderItemPrice)}");
        if (orderMaster.type == ProductType.GIFT_PRODUCT) {
          displayPrice = RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.black),
                  text: orderItemPrice.toString() + " ",
                  children: [
                WidgetSpan(
                    alignment: PlaceholderAlignment.bottom,
                    child: Image(
                      image: AssetImage("assets/images/icons/bean_coin.png"),
                      width: 20,
                      height: 20,
                    ))
              ]));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Get.width * 0.6,
                  child: Wrap(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${orderMaster.quantity}x ",
                        style: TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Container(
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
                    ],
                  ),
                ),
                Flexible(child: displayPrice)
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
    int index = orderDetailModel.listPayments.values
        .toList()
        .indexOf(orderDetail.paymentType);
    String payment = "Không xác định";
    if (index >= 0 && index < orderDetailModel.listPayments.keys.length) {
      payment = orderDetailModel.listPayments.keys.elementAt(index);
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: kBackgroundGrey[0],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tổng tiền",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${orderDetail.itemQuantity} món",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          RichText(
            text: TextSpan(
                text: "P.Thức: ",
                style: TextStyle(fontSize: 12, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: "${payment}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: kPrimary,
                    ),
                  ),
                ]),
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
                // OTHER AMOUNTS GO HERE
                ..._buildOtherAmount(orderDetail.otherAmounts),
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
                        "${formatPrice(orderDetail.finalAmount)}",
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

  List<Widget> _buildOtherAmount(List<OtherAmount> otherAmounts) {
    if (otherAmounts == null) return [SizedBox.shrink()];
    NumberFormat formatter = NumberFormat();
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    return otherAmounts
        .map((amountObj) => Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${amountObj.name}", style: TextStyle()),
                  Text(
                      "${formatter.format(amountObj.amount)} ${amountObj.unit}",
                      style: TextStyle()),
                ],
              ),
            ))
        .toList();
  }
}
