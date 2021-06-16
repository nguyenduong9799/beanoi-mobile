import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import "package:collection/collection.dart";
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class TransactionDetailScreen extends StatefulWidget {
  final TransactionDTO transaction;

  TransactionDetailScreen({Key key, this.transaction}) : super(key: key);

  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final orderDetailModel = Get.find<OrderHistoryViewModel>();

  @override
  void initState() {
    super.initState();
    // orderDetailModel.getOrderDetail(widget.order.id);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OrderHistoryViewModel>(
      model: orderDetailModel,
      child: Scaffold(
        appBar: DefaultAppBar(
          title: "Chi tiết giao dịch",
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white),
                child: buildTitle(),
              ),
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white),
                child: buildDetail(),
              )
            ],
          ),

          // child: ScopedModelDescendant<OrderHistoryViewModel>(
          //   builder: (context, child, model) {
          //     final status = model.status;
          //     if (status == ViewStatus.Loading)
          //       return AspectRatio(
          //         aspectRatio: 1,
          //         child: Center(child: CircularProgressIndicator()),
          //       );

          //     final orderDetail = model.orderDetail;
          //     return Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(4),
          //       ),
          //       child: Column(
          //         children: <Widget>[
          //           Container(
          //             width: Get.width,
          //             padding: EdgeInsets.all(8),
          //             decoration: BoxDecoration(
          //               color: kBackgroundGrey[0],
          //               borderRadius: BorderRadius.circular(4),
          //             ),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Row(
          //                   children: [
          //                     Container(
          //                       width: 100,
          //                       child: orderDetail.status == OrderFilter.NEW
          //                           ? TyperAnimatedTextKit(
          //                               speed: Duration(milliseconds: 100),
          //                               onTap: () {},
          //                               text: ['Mới ☕'],
          //                               textStyle: TextStyle(
          //                                 fontFamily: "Bobbers",
          //                                 color: kPrimary,
          //                               ),
          //                               textAlign: TextAlign.start,
          //                             )
          //                           : Text(
          //                               'Đã nhận hàng',
          //                               style: TextStyle(
          //                                 color: kPrimary,
          //                               ),
          //                             ),
          //                     ),
          //                     Expanded(
          //                       child: Padding(
          //                         padding: EdgeInsets.only(left: 8, right: 8),
          //                         child: Divider(),
          //                       ),
          //                     ),
          //                     Expanded(
          //                       child: Padding(
          //                         padding: EdgeInsets.only(left: 8, right: 8),
          //                         child: Divider(),
          //                       ),
          //                     ),
          //                     Text(
          //                       DateFormat('HH:mm dd/MM').format(
          //                           DateTime.parse(orderDetail.orderTime)),
          //                       style: TextStyle(color: Colors.black45),
          //                       overflow: TextOverflow.ellipsis,
          //                       maxLines: 1,
          //                     ),
          //                   ],
          //                 ),
          //                 SizedBox(height: 8),
          //                 Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text("🎯 Nhận đơn tại: "),
          //                     Padding(
          //                       padding: const EdgeInsets.only(left: 8),
          //                       child: Text(
          //                         orderDetail.address,
          //                         style: TextStyle(
          //                           color: Colors.grey,
          //                         ),
          //                       ),
          //                     )
          //                   ],
          //                 )
          //               ],
          //             ),
          //           ),
          //           SizedBox(height: 8),
          //           Container(
          //             decoration: BoxDecoration(
          //               color: kBackgroundGrey[0],
          //             ),
          //             child: buildOrderSummaryList(orderDetail),
          //           ),
          //           SizedBox(height: 8),
          //           layoutSubtotal(orderDetail),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            widget.transaction.name,
            style: Get.theme.textTheme.headline1.copyWith(color: Colors.black),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "${widget.transaction.isMinus ? "- " : "+ "} ${widget.transaction.amount}",
            style: Get.theme.textTheme.subtitle2.copyWith(color: Colors.black),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.transaction.status,
            style: Get.theme.textTheme.headline1,
          ),
        ],
      ),
    );
  }

  Widget buildDetail() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          buildItemDetail("Mã giao dịch", widget.transaction.code),
          SizedBox(
            height: 8,
          ),
          buildItemDetail("Thời gian giao dịch",
              DateFormat("dd/MM/yyyy HH:mm").format(widget.transaction.date)),
          SizedBox(
            height: 8,
          ),
          buildItemDetail("Loại giao dịch", widget.transaction.type,
              descriptionStyle:
                  Get.theme.textTheme.headline4.copyWith(color: kBean)),
        ],
      ),
    );
  }

  Widget buildItemDetail(String title, String description,
      {TextStyle titleStyle, TextStyle descriptionStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle ??
              Get.theme.textTheme.headline4.copyWith(color: Colors.grey),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          description,
          style: descriptionStyle ?? Get.theme.textTheme.headline4,
        )
      ],
    );
  }
}
