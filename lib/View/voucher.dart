import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Future<void> _refresh() async {
    Get.find<OrderViewModel>().getVouchers();
  }

  @override
  void initState() {
    Get.find<OrderViewModel>().getVouchers();
    super.initState();

    // UPDATE USER INFO INTO FORM
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "Danh sách mã giảm giá",
      ),
      body: Container(
        color: Colors.white,
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: Column(
            children: [
              // _buildSearchVoucher(),
              const SizedBox(height: 16),
              // _buildFilter(),
              _buildListVoucher(),
            ],
          ),
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

          if (model.status == ViewStatus.Error ||
              model.currentVouchers == null) {
            return Flexible(
              child: Center(
                child: Text(model.msg ?? "Hiện tại không có voucher khả dụng",
                    style: kTitleTextStyle.copyWith(
                      color: kPrimary,
                    )),
              ),
            );
          }
          if (model.currentVouchers.isEmpty) {
            return Flexible(
              child: Center(
                child: Text("Hiện tại không có voucher khả dụng",
                    style: kTitleTextStyle.copyWith(
                      color: kPrimary,
                    )),
              ),
            );
          }

          return Flexible(
            child: ListView.separated(
              itemCount: model.currentVouchers.length + 1,
              separatorBuilder: (context, index) => SizedBox(height: 2),
              itemBuilder: (context, index) {
                if (index == model.currentVouchers.length) {
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
                final voucher = model.currentVouchers.elementAt(index);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: voucherCard(voucher, model),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget voucherCard(VoucherDTO voucher, OrderViewModel model) {
    const Color primaryColor = Color(0xfff2f6f8);
    const Color secondaryColor = Color(0xFF4fba6f);
    const Color firstColor = Color(0xFF2E7D32);
    const Color secondColor = Color(0xffE0E0E0);

    bool visibleText = false;
    bool isApplied = false;

    final vouchersInCart = model.currentCart?.vouchers;
    if (vouchersInCart == null) {
      isApplied = false;
    } else {
      if (vouchersInCart.length != 0) {
        isApplied = vouchersInCart[0].voucherCode == voucher.voucherCode;
      }
    }

    return Container(
      decoration: isApplied
          ? BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(3),
              color: kPrimary,
            )
          : null,
      padding: EdgeInsets.all(2),
      child: InkWell(
        onTap: () {
          if (isApplied) {
            model.unselectVoucher(voucher);
          } else {
            model.selectVoucher(voucher);
          }
          Get.back();
        },
        child: VoucherCard(
          height: 110,
          backgroundColor: primaryColor,
          clockwise: true,
          curvePosition: 130,
          curveRadius: 30,
          curveAxis: Axis.vertical,
          borderRadius: 10,
          firstChild: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              // color: Colors.grey,
            ),
            // width: 110,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AspectRatio(
                  aspectRatio: 1.5,
                  child: CacheImage(
                      imageUrl: voucher.imgUrl != ''
                          ? voucher.imgUrl
                          : 'https://static.vecteezy.com/system/resources/previews/000/351/630/original/voucher-vector-icon.jpg'),
                ),
              ],
            ),
          ),
          // Container(
          //   // color: isApplied ? thirdColor : secondaryColor,
          //   decoration: BoxDecoration(
          //     color: isApplied ? firstColor : secondaryColor,
          //   ),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Expanded(
          //         child: Center(
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: [
          //               Text(
          //                 voucher.actionName,
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                   // color: isApplied ? Colors.black54 : Colors.white,
          //                   color: Colors.white,
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //       Divider(color: Colors.white54, height: 0),
          //       Expanded(
          //         child: InkWell(
          //           onTap: () {
          //             if (isApplied) {
          //               model.unselectVoucher(voucher);
          //             } else {
          //               model.selectVoucher(voucher);
          //             }
          //             Get.back();
          //           },
          //           child: Center(
          //             child: Padding(
          //               padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
          //               child: Text(
          //                 // voucher.promotionName.toUpperCase(),
          //                 isApplied ? 'HỦY CHỌN' : 'CHỌN',
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                   // color: isApplied ? Colors.black54 : Colors.white,
          //                   color: Colors.white,
          //                   fontSize: 12,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          secondChild: Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(3),
                    color: kPrimary,
                  ),
                  child: Text(
                    //
                    "Chỉ dành cho bạn",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  voucher.voucherName,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    // color: isApplied ? Colors.black54 : secondaryColor,
                    color: isApplied ? firstColor : secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                // Visibility(
                //   visible: visibleText,
                //   child: Text(
                //     voucher.voucherCode,
                //     textAlign: TextAlign.left,
                //     style: TextStyle(
                //       fontSize: 12,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.black54,
                //     ),
                //   ),
                // ),
                Text(
                  //
                  "-${voucher.description}",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Spacer(),
                voucher.endDate == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer,
                            size: 16,
                            color: Colors.grey,
                          ),
                          Text(
                            "Vĩnh viễn",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 16,
                            color: Colors.grey,
                          ),
                          Text(
                            ' ' +
                                DateFormat('dd-MM-yyyy')
                                    .format(DateTime.parse(voucher.endDate)),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black45,
                              // fontWeight: isApplied ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchVoucher() {
    TextEditingController controller = TextEditingController(text: '');
    return ScopedModel(
        model: Get.find<OrderViewModel>(),
        child: ScopedModelDescendant<OrderViewModel>(
            builder: (context, child, model) {
          return Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(
              children: [
                Container(
                  // height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: kPrimary)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: TextField(
                      onChanged: (input) {
                        model.getFilterVoucher(input);
                        model.showFilteredVoucher();
                      },
                      controller: controller,
                      decoration: InputDecoration(
                          hintText: 'Nhập mã giảm giá',
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.search,
                              size: 16,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              controller.clear();
                            },
                          )),
                      style: Get.theme.textTheme.headline4
                          .copyWith(color: Colors.grey),
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      autofocus: true,
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
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
          final currentVouchers = model.currentVouchers;
          if (currentVouchers == null || currentVouchers.isEmpty) {
            return SizedBox();
          }
          return Container(
            width: Get.width,
            color: kBackgroundGrey[2],
            padding: EdgeInsets.only(left: 8),
            height: 72,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currentVouchers.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final voucher = currentVouchers[index];
                final currentVouchersInCart = model.currentCart.vouchers;
                bool isApplied = currentVouchersInCart
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
