import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Model/DTO/GiftDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class VoucherDetailScreen extends StatefulWidget {
  final VoucherDTO voucherDTO;

  VoucherDetailScreen({this.voucherDTO});

  @override
  _VoucherDetailScreenState createState() => _VoucherDetailScreenState();
}

class _VoucherDetailScreenState extends State<VoucherDetailScreen>
    with TickerProviderStateMixin {
  PromoViewModel promoViewModel;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: BeanOiTheme.palettes.neutral200,
      bottomNavigationBar: bottomBar(),
      appBar: DefaultAppBar(
        title: 'Chi Tiết Khuyến Mãi',
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // margin: EdgeInsets.only(left: 10, right: 10),
              height: 300,
              child: ClipRRect(
                child: CacheImage(
                  imageUrl: widget.voucherDTO.imgUrl != ''
                      ? widget.voucherDTO.imgUrl
                      : defaultImage,
                ),
              ),
            ),
            Expanded(
              child: productTitle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget productTitle() {
    return Container(
      height: Get.height,
      // margin: EdgeInsets.only(left: 10, right: 10),
      // transform: Matrix4.translationValues(0.0, -50.0, 0.0),
      // color: kBackgroundGrey[0],
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                // padding: EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.voucherDTO.promotionName,
                      style: BeanOiTheme.typography.h2
                          .copyWith(color: BeanOiTheme.palettes.primary500),
                    ),
                  ],
                ),
              )),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            widget.voucherDTO.actionName,
            style: BeanOiTheme.typography.body1.copyWith(fontSize: 14),
            // overflow: TextOverflow.ellipsis,
            // maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget bottomBar() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: kBackgroundGrey[0],
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 8,
          ),
          // orderButton(),
          SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }

  // Widget orderButton() {
  //   return ScopedModelDescendant(
  //       builder: (BuildContext context, Widget child,
  //               ProductDetailViewModel model) =>
  //           model.order
  //               ? FlatButton(
  //                   padding: EdgeInsets.all(8),
  //                   onPressed: () async {
  //                     await model.addProductToCart();
  //                   },
  //                   textColor: kBackgroundGrey[0],
  //                   color: kPrimary,
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.all(Radius.circular(8))),
  //                   child: Column(
  //                     children: [
  //                       SizedBox(
  //                         height: 8,
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Flexible(
  //                             child: Text(model.count.toString() + " Món ",
  //                                 style: Get.theme.textTheme.headline3
  //                                     .copyWith(color: Colors.white)),
  //                           ),
  //                           Flexible(
  //                             child: Text("Thêm",
  //                                 style: Get.theme.textTheme.headline3
  //                                     .copyWith(color: Colors.white)),
  //                           ),
  //                           widget.voucherDTO.type != ProductType.GIFT_PRODUCT
  //                               ? Flexible(
  //                                   child: Text(
  //                                     formatPrice(model.total) ?? "",
  //                                     style: Get.theme.textTheme.headline3
  //                                         .copyWith(color: Colors.white),
  //                                   ),
  //                                 )
  //                               : Flexible(
  //                                   child: RichText(
  //                                       text: TextSpan(
  //                                           text: formatBean(model.total) + " ",
  //                                           style: Get.theme.textTheme.headline3
  //                                               .copyWith(color: Colors.white),
  //                                           children: [
  //                                         WidgetSpan(
  //                                             alignment:
  //                                                 PlaceholderAlignment.bottom,
  //                                             child: Image(
  //                                               image: AssetImage(
  //                                                   "assets/images/icons/bean_coin.png"),
  //                                               width: 20,
  //                                               height: 20,
  //                                             ))
  //                                       ])),
  //                                 ),
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         height: 8,
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               : FlatButton(
  //                   padding: EdgeInsets.all(8),
  //                   onPressed: () {},
  //                   textColor: kBackgroundGrey[0],
  //                   color: kBackgroundGrey[5],
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.all(Radius.circular(8))),
  //                   child: Column(
  //                     children: [
  //                       SizedBox(
  //                         height: 8,
  //                       ),
  //                       Text("Vui lòng chọn những trường bắt buộc (*)",
  //                           style: Get.theme.textTheme.headline3
  //                               .copyWith(color: Colors.white)),
  //                       SizedBox(
  //                         height: 8,
  //                       ),
  //                     ],
  //                   ),
  //                 ));
  // }
}
