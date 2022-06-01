import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Accessories/voucher/voucher_card.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/order_viewModel.dart';

class VouchersListPage extends StatefulWidget {
  VouchersListPage();

  @override
  _VouchersListPageState createState() => _VouchersListPageState();
}

class _VouchersListPageState extends State<VouchersListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "Danh sách mã giảm giá",
      ),
      body: Container(
        padding: EdgeInsets.only(top: 8),
        color: Colors.white,
        child: Column(
          children: [
            // _buildFilter(),
            _buildListVoucher(),
          ],
        ),
      ),
    );
  }

  Widget _buildListVoucher() {
    return ScopedModel(
      model: Get.find<OrderViewModel>(),
      child: ScopedModelDescendant<OrderViewModel>(
        builder: (context, child, model) {
          if (model.status == ViewStatus.Loading) {
            return _buildLoading();
          }

          if (model.status == ViewStatus.Error) {
            return Flexible(
              child: Center(
                child: Text(model.msg ?? "Có gì đó sai sai",
                    style: kTitleTextStyle.copyWith(
                      color: Colors.red,
                    )),
              ),
            );
          }

          return Flexible(
            child: ListView.separated(
              itemCount: model.vouchers.length + 1,
              separatorBuilder: (context, index) => SizedBox(height: 2),
              itemBuilder: (context, index) {
                if (index == model.vouchers.length) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Bạn đã xem hết rồi đấy 🐱‍👓",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                final voucher = model.vouchers.elementAt(index);
                return voucherCard(voucher, model);
              },
            ),
          );
        },
      ),
    );
  }

  Widget voucherCard(VoucherDTO voucher, OrderViewModel model) {
    const Color primaryColor = Color(0xffcbf3f0);
    const Color secondaryColor = Color(0xff368f8b);
    bool isApplied = false;
    if (model.currentCart?.vouchers == null) {
      isApplied = false;
    } else {
      final vouchersInCart = model.currentCart?.vouchers;
      isApplied =
          vouchersInCart.any((e) => e.voucherCode == voucher.voucherCode);
    }
    return Container(
      padding: EdgeInsets.all(8),
      child: Material(
        child: InkWell(
          onTap: () {
            if (isApplied) {
              model.unselectVoucher(voucher);
            } else {
              model.selectVoucher(voucher);
            }
          },
          child: VoucherCard(
            height: 110,
            backgroundColor: primaryColor,
            clockwise: true,
            curvePosition: 120,
            curveRadius: 30,
            curveAxis: Axis.vertical,
            borderRadius: 10,
            firstChild: Container(
              decoration: const BoxDecoration(
                color: secondaryColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            voucher.actionName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Text(
                          //   'OFF',
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 12,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Divider(color: Colors.white54, height: 0),
                  Expanded(
                    child: Center(
                      child: Text(
                        voucher.promotionName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            secondChild: Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    voucher.voucherName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    voucher.voucherCode,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Valid Till - 30 Jan 2022',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Flexible(
      child: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          height: 140,
          width: Get.width,
          color: Colors.white,
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                  aspectRatio: 1, child: ShimmerBlock(width: 140, height: 140)),
              SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBlock(width: 120, height: 20),
                    SizedBox(height: 4),
                    ShimmerBlock(width: 175, height: 20),
                    SizedBox(height: 8),
                    Flexible(child: Container()),
                    Row(
                      children: [
                        ShimmerBlock(width: 50, height: 20, borderRadius: 16),
                        SizedBox(width: 8),
                        ShimmerBlock(width: 50, height: 20, borderRadius: 16),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        separatorBuilder: (context, index) => SizedBox(height: 16),
      ),
    );
  }

  Widget voucherList() {
    return ScopedModel(
        model: Get.find<OrderViewModel>(),
        child: ScopedModelDescendant<OrderViewModel>(
            builder: (context, child, model) {
          if (model.status == ViewStatus.Loading) {
            return _buildLoading();
          }

          if (model.status == ViewStatus.Error) {
            return Flexible(
              child: Center(
                child: Text(model.msg ?? "Có gì đó sai sai",
                    style: kTitleTextStyle.copyWith(
                      color: Colors.red,
                    )),
              ),
            );
          }
          final vouchers = model.vouchers;
          if (vouchers == null || vouchers.isEmpty) {
            return SizedBox();
          }
          return Container(
            width: Get.width,
            color: kBackgroundGrey[2],
            padding: EdgeInsets.only(left: 8),
            height: 72,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: vouchers.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final voucher = vouchers[index];
                final vouchersInCart = model.currentCart.vouchers;
                bool isApplied = vouchersInCart
                    .any((e) => e.voucherCode == voucher.voucherCode);
                return ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          isApplied ? kPrimary.withOpacity(0.4) : Colors.white,
                      border: Border(
                        left: BorderSide(color: kPrimary, width: 6),
                        top: BorderSide(
                            color: Colors.transparent,
                            width: isApplied ? 2 : 0),
                        bottom: BorderSide(
                            color: Colors.transparent,
                            width: isApplied ? 2 : 0),
                        right: BorderSide(
                            color: Colors.transparent,
                            width: isApplied ? 2 : 0),
                      ),
                    ),
                    width: Get.width * 0.7,
                    margin: EdgeInsets.only(right: 8),
                    // height: 72,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                voucher.voucherName,
                                style: Get.theme.textTheme.headline1
                                    .copyWith(color: kTextColor),
                              ),
                              Text(
                                voucher.promotionName,
                                style: Get.theme.textTheme.headline6,
                              ),
                            ],
                          ),
                        ),
                        VerticalDivider(),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (isApplied) {
                                model.unselectVoucher(voucher);
                              } else {
                                model.selectVoucher(voucher);
                              }
                            },
                            child: Container(
                              height: 72,
                              child: Center(
                                child: Text(
                                  isApplied ? 'Hủy' : 'Chọn',
                                  style: Get.theme.textTheme.headline6
                                      .copyWith(color: kPrimary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }));
  }
}
