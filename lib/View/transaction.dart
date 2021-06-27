import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen();

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TransactionViewModel model = Get.find<TransactionViewModel>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    model.getTransactions();
  }

  Future<void> refreshFetchOrder() async {
    await model.getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<TransactionViewModel>(
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
              child: _buildTransaction(),
            ),
          ],
        ),
      ),
    );
  }

  Widget transactionBar() {
    return ScopedModelDescendant<TransactionViewModel>(
      builder: (context, child, model) {
        return Container(
          margin: EdgeInsets.only(top: 32, bottom: 16),
          height: 30,
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: [
              Text(
                "LỌC THEO",
                style:
                    Get.theme.textTheme.headline4.copyWith(color: Colors.grey),
              ),
              SizedBox(width: 16),
              ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  String status;
                  switch (DateFilter.values[index]) {
                    case DateFilter.DAY:
                      status = "Ngày";
                      break;
                    case DateFilter.WEEK:
                      status = "Tuần";
                      break;
                    case DateFilter.MONTH:
                      status = "Tháng";
                      break;
                    default:
                      status = "Tất cả";
                  }
                  if (DateFilter.values[index] == model.selectedFilter) {
                    return Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                            child: Text(
                          status,
                          style: Get.theme.textTheme.headline4
                              .copyWith(color: Colors.white),
                        )));
                  }
                  return InkWell(
                      onTap: () {
                        model.changeStatus(DateFilter.values[index]);
                      },
                      child: Center(
                          child: Text(
                        status,
                        style: Get.theme.textTheme.headline4,
                      )));
                },
                itemCount: DateFilter.values.length,
                separatorBuilder: (context, index) => SizedBox(
                  width: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransaction() {
    // return RefreshIndicator(
    //   key: _refreshIndicatorKey,
    //   onRefresh: refreshFetchOrder,
    //   child: Container(
    //     child: ListView(
    //       physics: AlwaysScrollableScrollPhysics(),
    //       controller: model.scrollController,
    //       padding: EdgeInsets.all(8),
    //       children: [
    //         ...widget.listTransaction
    //             .map((transacction) => _buildTransactionItem(transacction))
    //             .toList(),
    //         loadMoreIcon(),
    //       ],
    //     ),
    //   ),
    // );
    return ScopedModelDescendant<TransactionViewModel>(
        builder: (context, child, model) {
      final status = model.status;
      if (status == ViewStatus.Loading)
        return Center(
          child: LoadingBean(),
        );
      if (status == ViewStatus.Error)
        return Center(
          child: AspectRatio(
            aspectRatio: 1 / 4,
            child: Image.asset(
              'assets/images/error.png',
              width: 24,
            ),
          ),
        );
      if (status == ViewStatus.Empty)
        return Center(
          child: Container(
            child: Text('Chưa có giao dịch nào 😵'),
          ),
        );

      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: refreshFetchOrder,
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: model.scrollController,
            children: [
              ...model.transactionList
                  .map((transaction) => _buildTransactionItem(transaction))
                  .toList(),
              loadMoreIcon(),
            ],
          ),
        ),
      );
    });
  }

  Widget loadMoreIcon() {
    return ScopedModelDescendant<TransactionViewModel>(
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
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
          color: Colors.transparent,
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            onTap: () {
              _onTapTransaction(dto);
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${dto.name ?? "Giao dịch"}",
                    style: Get.theme.textTheme.headline3
                        .copyWith(color: Colors.black)),
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
                "${dto.isIncrease ? "+" : "-"} ${formatPriceWithoutUnit(dto.amount)} ${dto.currency}",
                style: Get.theme.textTheme.headline2.copyWith(
                  color: dto.isIncrease ? kPrimary : Colors.red,
                )),
          )),
    );
  }

  void _onTapTransaction(TransactionDTO dto) async {
    await Get.toNamed(RouteHandler.TRANSACTION_DETAIL, arguments: dto);
  }
}
