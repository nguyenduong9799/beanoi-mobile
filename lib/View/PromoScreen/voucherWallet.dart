import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Accessories/voucher/voucher_card.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/GiftDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/order_viewModel.dart';
import 'package:unidelivery_mobile/ViewModel/promotion_viewModel.dart';

class VoucherWalletPage extends StatefulWidget {
  VoucherWalletPage();

  @override
  _VoucherWalletPageState createState() => _VoucherWalletPageState();
}

class _VoucherWalletPageState extends State<VoucherWalletPage> {
  final PromoViewModel model = Get.find<PromoViewModel>();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Future<void> _refresh() async {
    Get.find<PromoViewModel>().getVouchers();
    Get.find<PromoViewModel>().getMyVouchers();
  }

  bool isErrorInput = false;
  @override
  void initState() {
    Get.find<PromoViewModel>().getVouchers();
    Get.find<PromoViewModel>().getMyVouchers();
    super.initState();
    // UPDATE USER INFO INTO FORM
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<PromoViewModel>(
      model: model,
      child: Scaffold(
        appBar: DefaultAppBar(
          title: "Quà và khuyến mãi",
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            voucherStatusBar(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  color: BeanOiTheme.palettes.neutral100,
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _refresh,
                    child: Column(
                      children: [
                        // _buildSearchVoucher(),
                        const SizedBox(height: 8),
                        // _buildFilter(),
                        _buildListVoucher(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget voucherStatusBar() {
    return ScopedModelDescendant<PromoViewModel>(
      builder: (context, child, model) {
        print(model.selections[0]);
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
                      "Quà của bạn",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Text(
                      "Mã khuyến mãi",
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

  Widget _buildListVoucher() {
    return ScopedModel(
      model: Get.find<PromoViewModel>(),
      child: ScopedModelDescendant<PromoViewModel>(
        builder: (context, child, model) {
          if (model.status == ViewStatus.Loading) {
            return _buildLoading();
          }

          if (model.status == ViewStatus.Error || model.vouchers == null) {
            return Flexible(
              child: Center(
                child: Text(model.msg ?? "Hiện tại không có voucher khả dụng",
                    style: kTitleTextStyle.copyWith(
                      color: kPrimary,
                    )),
              ),
            );
          }
          if (model.vouchers.isEmpty) {
            return Flexible(
              child: Center(
                child: Text("Hiện tại không có voucher khả dụng",
                    style: kTitleTextStyle.copyWith(
                      color: kPrimary,
                    )),
              ),
            );
          }
          if (model.selections[0] == false) {
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
                final myVoucher = model.myVouchers.elementAt(index);
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: myVoucherCard(myVoucher, model),
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

  Widget voucherCard(VoucherDTO voucher, PromoViewModel model) {
    const Color primaryColor = Color(0xfff2f6f8);
    const Color secondaryColor = Color(0xFF4fba6f);
    const Color firstColor = Color(0xFF2E7D32);
    const Color secondColor = Color(0xffE0E0E0);

    bool visibleText = false;
    bool isApplied = false;

    final vouchersInCart = Get.find<OrderViewModel>().currentCart?.vouchers;
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
          Get.toNamed(RouteHandler.VOUCHER_DETAIL, arguments: voucher);
        },
        child: VoucherCard(
          height: 110,
          backgroundColor: Colors.white,
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
          secondChild: Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(),
                Text(
                  voucher.promotionName,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: isApplied ? firstColor : secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  voucher.actionName,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Xem chi tiết",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kPrimary,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myVoucherCard(GiftDTO gift, PromoViewModel model) {
    const Color primaryColor = Color(0xfff2f6f8);
    const Color secondaryColor = Color(0xFF4fba6f);
    const Color firstColor = Color(0xFF2E7D32);
    const Color secondColor = Color(0xffE0E0E0);
    var giftDetail = {
      "promotion_id": gift.voucherInfo.id,
      "promotion_tier_id": null,
      "promotion_name": gift.name,
      "description": gift.description,
      "promotion_code": gift.voucherCode,
      "action_name": null,
      "voucher_name": gift.name,
      "img_url": gift.voucherInfo.picUrl,
      "voucher_code": gift.voucherCode,
      "start_date": gift.createdAt
    };
    bool visibleText = false;
    bool isApplied = false;

    final vouchersInCart = Get.find<OrderViewModel>().currentCart?.vouchers;
    if (vouchersInCart == null) {
      isApplied = false;
    } else {
      if (vouchersInCart.length != 0) {
        isApplied = vouchersInCart[0].voucherCode == gift.voucherCode;
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
          Get.toNamed(RouteHandler.VOUCHER_DETAIL, arguments: giftDetail);
        },
        child: VoucherCard(
          height: 110,
          backgroundColor: Colors.white,
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
                      imageUrl: gift.voucherInfo.picUrl != ''
                          ? gift.voucherInfo.picUrl
                          : 'https://static.vecteezy.com/system/resources/previews/000/351/630/original/voucher-vector-icon.jpg'),
                ),
              ],
            ),
          ),
          secondChild: Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Spacer(),
                Text(
                  gift.name,
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
                Text(
                  gift.description,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Xem chi tiết",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kPrimary,
                      ),
                    ),
                  ],
                )
              ],
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

  // Widget voucherList() {
  //   return ScopedModel(
  //       model: Get.find<OrderViewModel>(),
  //       child: ScopedModelDescendant<OrderViewModel>(
  //           builder: (context, child, model) {
  //         if (model.status == ViewStatus.Loading) {
  //           return _buildLoading();
  //         }

  //         if (model.status == ViewStatus.Error) {
  //           return Flexible(
  //             child: Center(
  //               child: Text(model.msg ?? "Có gì đó sai sai",
  //                   style: kTitleTextStyle.copyWith(
  //                     color: Colors.red,
  //                   )),
  //             ),
  //           );
  //         }
  //         final currentVouchers = model.vouchers;
  //         if (currentVouchers == null || currentVouchers.isEmpty) {
  //           return SizedBox();
  //         }
  //         return Container(
  //           width: Get.width,
  //           color: kBackgroundGrey[2],
  //           padding: EdgeInsets.only(left: 8),
  //           height: 72,
  //           child: ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: currentVouchers.length,
  //             scrollDirection: Axis.horizontal,
  //             itemBuilder: (context, index) {
  //               final voucher = currentVouchers[index];
  //               final currentVouchersInCart = model.currentCart.vouchers;
  //               bool isApplied = currentVouchersInCart
  //                   .any((e) => e.voucherCode == voucher.voucherCode);
  //               return ClipPath(
  //                 clipper: ShapeBorderClipper(
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.all(Radius.circular(10)),
  //                   ),
  //                 ),
  //                 child: AnimatedContainer(
  //                   duration: Duration(milliseconds: 300),
  //                   padding: EdgeInsets.all(8),
  //                   decoration: BoxDecoration(
  //                     color:
  //                         isApplied ? kPrimary.withOpacity(0.4) : Colors.white,
  //                     border: Border(
  //                       left: BorderSide(color: kPrimary, width: 6),
  //                       top: BorderSide(
  //                           color: Colors.transparent,
  //                           width: isApplied ? 2 : 0),
  //                       bottom: BorderSide(
  //                           color: Colors.transparent,
  //                           width: isApplied ? 2 : 0),
  //                       right: BorderSide(
  //                           color: Colors.transparent,
  //                           width: isApplied ? 2 : 0),
  //                     ),
  //                   ),
  //                   width: Get.width * 0.7,
  //                   margin: EdgeInsets.only(right: 8),
  //                   // height: 72,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Expanded(
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               voucher.voucherName,
  //                               style: Get.theme.textTheme.headline1
  //                                   .copyWith(color: kTextColor),
  //                             ),
  //                             Text(
  //                               voucher.promotionName,
  //                               style: Get.theme.textTheme.headline6,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       VerticalDivider(),
  //                       Material(
  //                         color: Colors.transparent,
  //                         child: InkWell(
  //                           onTap: () {
  //                             if (isApplied) {
  //                               model.unselectVoucher(voucher);
  //                             } else {
  //                               model.selectVoucher(voucher);
  //                             }
  //                           },
  //                           child: Container(
  //                             height: 72,
  //                             child: Center(
  //                               child: Text(
  //                                 isApplied ? 'Hủy' : 'Chọn',
  //                                 style: Get.theme.textTheme.headline6
  //                                     .copyWith(color: kPrimary),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         );
  //       }));
  // }
}
