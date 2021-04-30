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
import 'package:unidelivery_mobile/acessories/otherAmount.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/index.dart';
import "package:collection/collection.dart";

class OrderHistoryDetail extends StatefulWidget {
  final OrderDTO order;

  OrderHistoryDetail({Key key, this.order}) : super(key: key);

  @override
  _OrderHistoryDetailState createState() => _OrderHistoryDetailState();
}

class _OrderHistoryDetailState extends State<OrderHistoryDetail> {
  final orderDetailModel = OrderHistoryViewModel.getInstance();

  @override
  void initState() {
    super.initState();
    orderDetailModel.getOrderDetail(widget.order.id);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OrderHistoryViewModel>(
      model: orderDetailModel,
      child: Scaffold(
        bottomNavigationBar: _buildCancelBtn(),
        appBar: DefaultAppBar(
          title: "${widget.order.invoiceId.toString()}" ?? 'Đơn hàng',
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
        body: SingleChildScrollView(
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
                                        onTap: () {},
                                        text: ['Mới ☕'],
                                        textStyle: TextStyle(
                                          fontFamily: "Bobbers",
                                          color: kPrimary,
                                        ),
                                        textAlign: TextAlign.start,
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
                    Container(
                      decoration: BoxDecoration(
                        color: kBackgroundGrey[0],
                      ),
                      child: buildOrderSummaryList(orderDetail),
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
    );
  }

  Widget _buildCancelBtn() {
    OrderFilter status = this.widget.order.status;

    if (status == OrderFilter.NEW) {
      return ScopedModelDescendant<OrderHistoryViewModel>(
          builder: (context, child, model) {
        return Material(
          elevation: 2,
          color: Color(0xFFF0F2F5),
          child: FlatButton(
            onPressed: () {
              model.cancelOrder(this.widget.order.id);
            },
            child: Text(
              "Hủy đơn 😢",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        );
      });
    } else if (status == OrderFilter.DONE) {
      return Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: Text(
          'Bạn đã có bữa cơm ngon miệng phải không 😋?',
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

  Widget buildOrderSummaryList(OrderDTO orderDetail) {
    Map<int, List<OrderItemDTO>> map =
        groupBy(orderDetail.orderItems, (OrderItemDTO item) => item.supplierId);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          List<OrderItemDTO> items = map.values.elementAt(index);
          SupplierNoteDTO note = orderDetail.notes?.firstWhere(
              (element) => element.supplierId == items[0].supplierId,
              orElse: () => null);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                items[0].supplierName,
                style: TextStyle(fontWeight: FontWeight.bold, color: kPrimary),
              ),
              (note != null)
                  ? Container(
                      width: Get.width,
                      color: Colors.yellow[100],
                      margin: EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.all(4),
                      child: Text.rich(TextSpan(
                          text: "Ghi chú:\n",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                          children: [
                            TextSpan(
                                text: "- " + note.content,
                                style: TextStyle(color: Colors.grey))
                          ])),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: kBackgroundGrey[4]),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return buildOrderItem(items[index]);
                    },
                    separatorBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        child: MySeparator()),
                    itemCount: items.length),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: map.keys.length,
      ),
    );
  }

  Widget buildOrderItem(OrderItemDTO item) {
    final orderChilds = item.productChilds;

    double orderItemPrice = item.amount;
    orderChilds?.forEach((element) {
      orderItemPrice += element.amount;
    });
    // orderItemPrice *= orderMaster.quantity;
    Widget displayPrice = Text("${formatPrice(orderItemPrice)}");
    if (item.type == ProductType.GIFT_PRODUCT) {
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
                    "${item.quantity}x ",
                    style: TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        item.type != ProductType.MASTER_PRODUCT
                            ? Text(
                                item.masterProductName,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              )
                            : SizedBox.shrink(),
                        ...orderChilds
                            .map(
                              (child) => Text(
                                child.type == ProductType.EXTRA_PRODUCT
                                    ? "+ " + child.masterProductName
                                    : child.masterProductName,
                                style: TextStyle(fontSize: 14),
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
            margin: EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: kBackgroundGrey[4]),
                borderRadius: BorderRadius.all(Radius.circular(8))),
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

    return otherAmounts
        .map((amountObj) => OtherAmountWidget(
              otherAmount: amountObj,
            ))
        .toList();
  }
}
