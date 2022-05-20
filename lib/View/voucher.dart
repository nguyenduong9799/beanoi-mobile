import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/order_viewModel.dart';

class VouchersListPage extends StatefulWidget {
  final Map<String, dynamic> params;
  VouchersListPage({Key key, this.params = const {}}) : super(key: key);

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
        color: Colors.grey,
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
    bool isApplied = false;
    if (model.currentCart?.vouchers == null) {
      isApplied = false;
    } else {
      final vouchersInCart = model.currentCart?.vouchers;
      isApplied =
          vouchersInCart.any((e) => e.voucherCode == voucher.voucherCode);
    }

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                  color: isApplied ? kPrimary.withOpacity(0.4) : Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          color: kPrimary),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            voucher.voucherName,
                            style: Get.theme.textTheme.headline3
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(height: 4),
                          Text("Text",
                              style: Get.theme.textTheme.headline2.copyWith(
                                color: Colors.black,
                              )),
                        ],
                      ),
                    )
                  ],
                )),
          ),
          Divider(thickness: 2),
          Expanded(
            flex: 2,
            child: Container(
              height: 70,
              width: Get.width * 0.2,
              // color: Colors.grey[300],
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: isApplied ? kPrimary.withOpacity(0.4) : Colors.white,
              ),
              child: Material(
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
                        style: Get.theme.textTheme.headline3.copyWith(
                          color: isApplied ? Colors.black : kPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
