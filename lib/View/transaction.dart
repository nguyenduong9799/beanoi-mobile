import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/TransactionDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class TransactionScreen extends StatefulWidget {
  final List<TransactionDTO> listTransaction;
  TransactionScreen({Key key, this.listTransaction}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  OrderHistoryViewModel model = Get.find<OrderHistoryViewModel>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    model.getOrders();
  }

  Future<void> refreshFetchOrder() async {
    await model.getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OrderHistoryViewModel>(
      model: model,
      child: Scaffold(
        appBar: DefaultAppBar(
          title: "Lịch sử giao dịch",
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            transactionBar(),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                child: _buildTransaction(),
                color: Color(0xffefefef),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionBar() {
    return ScopedModelDescendant<OrderHistoryViewModel>(
      builder: (context, child, model) {
        return Center(
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
                  await model.changeStatus(index);
                },
                borderRadius: BorderRadius.circular(24),
                isSelected: model.selections,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(
                      "Mới",
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
        );
      },
    );
  }

  Widget _buildTransaction() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: refreshFetchOrder,
      child: Container(
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: model.scrollController,
          padding: EdgeInsets.all(8),
          children: [
            ...widget.listTransaction
                .map((transacction) => _buildTransactionItem(transacction))
                .toList(),
            loadMoreIcon(),
          ],
        ),
      ),
    );
    // return ScopedModelDescendant<OrderHistoryViewModel>(
    //     builder: (context, child, model) {
    //   final status = model.status;
    //   final orderSummaryList = model.orderThumbnail;
    //   if (status == ViewStatus.Loading)
    //     return Center(
    //       child: LoadingBean(),
    //     );
    //   else if (status == ViewStatus.Empty ||
    //       orderSummaryList == null ||
    //       orderSummaryList.length == 0)
    //     return Center(
    //       child: Container(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text('Bạn chưa đặt đơn hàng nào hôm nay 😵'),
    //             FlatButton(
    //               onPressed: () {
    //                 Get.back();
    //               },
    //               child: Text(
    //                 '🥡 Đặt ngay 🥡',
    //                 style: kTextPrimary.copyWith(
    //                   color: kPrimary,
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     );

    //   if (status == ViewStatus.Error)
    //     return Center(
    //       child: AspectRatio(
    //         aspectRatio: 1 / 4,
    //         child: Image.asset(
    //           'assets/images/error.png',
    //           width: 24,
    //         ),
    //       ),
    //     );

    //   return RefreshIndicator(
    //     key: _refreshIndicatorKey,
    //     onRefresh: refreshFetchOrder,
    //     child: Container(
    //       child: ListView(
    //         physics: AlwaysScrollableScrollPhysics(),
    //         controller: model.scrollController,
    //         padding: EdgeInsets.all(8),
    //         children: [
    //           ...orderSummaryList
    //               .map((orderSummary) => _buildOrderSummary(orderSummary))
    //               .toList(),
    //           loadMoreIcon(),
    //         ],
    //       ),
    //     ),
    //   );
    // });
  }

  Widget loadMoreIcon() {
    return ScopedModelDescendant<OrderHistoryViewModel>(
      builder: (context, child, model) {
        switch (model.status) {
          case ViewStatus.LoadMore:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          default:
            return SizedBox.shrink();
        }
      },
    );
  }

  // Widget _buildOrderSummary(OrderListDTO orderSummary) {
  //   final isToday = DateTime.parse(orderSummary.checkInDate)
  //           .difference(DateTime.now())
  //           .inDays ==
  //       0;

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.only(left: 24, bottom: 16),
  //         child: isToday
  //             ? Text(
  //                 'Hôm nay 😋',
  //                 style: kTitleTextStyle.copyWith(fontSize: 24),
  //               )
  //             : Text(
  //                 DateFormat('dd/MM/yyyy')
  //                     .format(DateTime.parse(orderSummary.checkInDate)),
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //       ),
  //       ...orderSummary.orders
  //           .toList()
  //           .map((order) => _buildOrderItem(order))
  //           .toList(),
  //     ],
  //   );
  // }

  Widget _buildTransactionItem(TransactionDTO dto) {
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
                // _onTapOrderHistory(order);
              },
              contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${dto.name}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(dto.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing: Text(
                "${dto.isMinus ? "- " : "+ "} ${dto.amount} ${dto.type}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: dto.isMinus ? Colors.red : kPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            // Text("Chi tiết", style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }

  void _onTapOrderHistory(order) async {
    // get orderDetail
    await Get.toNamed(RouteHandler.ORDER_HISTORY_DETAIL, arguments: order);
    model.getOrders();
  }
}
