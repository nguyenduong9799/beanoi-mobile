import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import "package:collection/collection.dart";
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

import 'index.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderViewModel orderViewModel;
  AutoScrollController controller;
  final scrollDirection = Axis.vertical;
  bool onInit = true;
  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    orderViewModel = OrderViewModel();
    prepareCart();
  }

  void prepareCart() async {
    await orderViewModel.prepareOrder();
    setState(() {
      onInit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: orderViewModel,
      child: Scaffold(
        backgroundColor: kBackgroundGrey[0],
        appBar: DefaultAppBar(title: "Đơn hàng của bạn"),
        bottomNavigationBar: bottomBar(),
        body: onInit
            ? Center(child: LoadingBean())
            : ScopedModelDescendant<OrderViewModel>(
                builder:
                    (BuildContext context, Widget child, OrderViewModel model) {
                  ViewStatus status = model.status;
                  switch (status) {
                    case ViewStatus.Error:
                      return ListView(
                        children: [
                          Center(
                            child: Text(
                              "Có gì đó sai sai..\n Vui lòng thử lại.",
                            ),
                          ),
                          SizedBox(height: 8),
                          Image.asset(
                            'assets/images/global_error.png',
                            fit: BoxFit.contain,
                          ),
                        ],
                      );
                    case ViewStatus.Loading:
                    case ViewStatus.Completed:
                      return ListView(
                        children: [
                          Hero(
                            tag: CART_TAG,
                            child: Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: layoutAddress(model.campusDTO)),
                          ),

                          AutoScrollTag(
                            index: 1,
                            key: ValueKey(1),
                            controller: controller,
                            highlightColor: Colors.black.withOpacity(0.1),
                            child: timeRecieve(model.campusDTO),
                          ),
                          // Container(child: buildBeanReward()),
                          SizedBox(
                              height: 8,
                              child: Container(
                                color: kBackgroundGrey[2],
                              )),
                          Container(child: layoutOrder(model.currentCart)),
                          SizedBox(
                              height: 8,
                              child: Container(
                                color: kBackgroundGrey[2],
                              )),
                          layoutSubtotal(),
                          SizedBox(
                              height: 8,
                              child: Container(
                                color: kBackgroundGrey[2],
                              )),
                          selectPaymentMethods()
                          //SizedBox(height: 16),
                        ],
                      );

                    default:
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LoadingScreen(),
                      );
                  }
                },
              ),
      ),
    );
  }

  Widget voucherList() {
    return ScopedModelDescendant<OrderViewModel>(
        builder: (context, child, model) {
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
            bool isApplied =
                vouchersInCart.any((e) => e.voucherCode == voucher.voucherCode);
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
                  color: isApplied ? kPrimary.withOpacity(0.4) : Colors.white,
                  border: Border(
                    left: BorderSide(color: kPrimary, width: 6),
                    top: BorderSide(
                        color: Colors.transparent, width: isApplied ? 2 : 0),
                    bottom: BorderSide(
                        color: Colors.transparent, width: isApplied ? 2 : 0),
                    right: BorderSide(
                        color: Colors.transparent, width: isApplied ? 2 : 0),
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
    });
  }

  Widget buildBeanReward() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        // height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: kPrimary,
          ),
          color: Colors.white,
        ),
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
        margin: EdgeInsets.only(left: 4, right: 4),
        child: Row(
          children: [
            Icon(FontAwesome5Solid.fire_alt, color: Colors.red),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                // height: 50,
                child: RichText(
                  maxLines: 2,
                  text: TextSpan(
                      text: "WoW\nBạn sẽ nhận được ",
                      style: Get.theme.textTheme.headline6,
                      children: [
                        TextSpan(
                          text:
                              "${orderViewModel.orderAmount.beanAmount.toString()} ",
                          style: Get.theme.textTheme.headline3
                              .copyWith(color: Colors.orange),
                        ),
                        WidgetSpan(
                            alignment: PlaceholderAlignment.bottom,
                            child: Image(
                              image: AssetImage(
                                  "assets/images/icons/bean_coin.png"),
                              width: 20,
                              height: 20,
                            )),
                        TextSpan(text: " cho đơn hàng này đấy!"),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget layoutOrder(Cart cart) {
    Map<int, List<CartItem>> map =
        groupBy(cart.items, (CartItem item) => item.master.supplierId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: kBackgroundGrey[0],
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Các món trong giỏ",
                    style: Get.theme.textTheme.headline3,
                  ),
                  OutlineButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    highlightedBorderColor: kPrimary,
                    onPressed: () {
                      Get.back();
                    },
                    borderSide: BorderSide(color: kPrimary),
                    child: Text(
                      "Thêm món",
                      style: Get.theme.textTheme.headline6
                          .copyWith(color: kPrimary),
                    ),
                  )
                ],
              ),
              Divider(
                color: Colors.black,
              )
            ],
          ),
        ),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return layoutStore(map.values.elementAt(index));
          },
          itemCount: map.keys.length,
          separatorBuilder: (context, index) => Divider(
            color: kBackgroundGrey[3],
          ),
        )
      ],
    );
  }

  Widget layoutStore(List<CartItem> list) {
    SupplierNoteDTO supplierNote = orderViewModel.currentCart.notes?.firstWhere(
      (element) => element.supplierId == list[0].master.supplierId,
      orElse: () => null,
    );
    List<Widget> card = [];

    for (CartItem item in list) {
      card.add(productCard(item));
    }

    for (int i = 0; i < card.length; i++) {
      if (i % 2 != 0) {
        card.insert(
            i,
            Container(
                color: kBackgroundGrey[0],
                child: MySeparator(
                  color: kBackgroundGrey[4],
                )));
      }
    }

    return Container(
      color: kBackgroundGrey[0],
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    list[0].master.supplierName,
                    style: Get.theme.textTheme.headline3,
                  ),
                  Text(
                    list
                            .fold(
                                0,
                                (previousValue, element) =>
                                    previousValue + element.quantity)
                            .toString() +
                        " món",
                    style: Get.theme.textTheme.headline4
                        .copyWith(color: Colors.orange),
                  )
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () {
                    orderViewModel.addSupplierNote(list[0].master.supplierId);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                        (supplierNote == null) ? "Thêm ghi chú" : "Sửa ghi chú",
                        style: Get.theme.textTheme.headline6),
                  )),
            ),
          ]),
          ...card
        ],
      ),
    );
  }

  Widget productCard(CartItem item) {
    List<Widget> list = [];
    double price = 0;
    int startProduct = 0;
    if (item.master.type == ProductType.MASTER_PRODUCT) {
      price = item.products[0].price * item.quantity;
      startProduct = 1;
    } else {
      price = item.master.price * item.quantity;
      startProduct = 0;
    }
    for (int i = startProduct; i < item.products.length; i++) {
      list.add(SizedBox(
        height: 4,
      ));
      list.add(Text(
          item.products[i].type == ProductType.EXTRA_PRODUCT
              ? "+ " + item.products[i].name
              : item.products[i].name,
          style: Get.theme.textTheme.headline4.copyWith(color: Colors.grey)));
      price += item.products[i].price * item.quantity;
    }

    if (item.description != null && item.description.isNotEmpty) {
      list.add(SizedBox(
        height: 4,
      ));
      list.add(Text(
        item.description,
      ));
    }

    bool isGift = false;
    if (item.master.type == ProductType.GIFT_PRODUCT) {
      isGift = true;
    }

    return Container(
      color: kBackgroundGrey[0],
      padding: EdgeInsets.all(8),
      child: InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.width * 0.25,
                fit: BoxFit.fill,
                imageUrl: item.master.imageURL ?? defaultImage,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  enabled: true,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    // height: 100,
                    color: Colors.grey,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: Center(
                      child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      "BEAN OI",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                            item.master.type != ProductType.MASTER_PRODUCT
                                ? item.master.name
                                : item.products[0].name,
                            style: Get.theme.textTheme.headline3),
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...list,
                            SizedBox(
                              height: 8,
                            ),
                            RichText(
                              text: TextSpan(
                                  text:
                                      isGift ? "${price} " : formatPrice(price),
                                  style: Get.theme.textTheme.headline4,
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.bottom,
                                      child: isGift
                                          ? Image(
                                              image: AssetImage(
                                                  "assets/images/icons/bean_coin.png"),
                                              width: 20,
                                              height: 20,
                                            )
                                          : Container(),
                                    )
                                  ]),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      selectQuantity(item),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget layoutAddress(CampusDTO store) {
    LocationDTO location = store.locations.firstWhere(
      (element) => element.isSelected,
      orElse: () => null,
    );
    DestinationDTO destination;
    if (location != null) {
      destination = location.destinations.firstWhere(
        (element) => element.isSelected,
        orElse: () => null,
      );
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: RichText(
                  text: TextSpan(
                      text: "Nhận đơn tại:",
                      style: Get.theme.textTheme.headline5
                          .copyWith(color: kPrimary),
                      children: []),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: InkWell(
                onTap: () async {
                  await orderViewModel.changeLocationOfStore();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 4, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      destination != null
                          ? Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    location.address,
                                    style: Get.theme.textTheme.headline4,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    destination.name,
                                    style: Get.theme.textTheme.headline4,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            )
                          : Flexible(
                              child: Text(
                                "Chọn địa điểm giao hàng",
                                style: Get.theme.textTheme.headline4,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                      Icon(
                        Icons.navigate_next,
                        color: Colors.orange,
                        size: 24,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget timeRecieve(CampusDTO dto) {
    DateTime arrive = DateFormat("HH:mm:ss").parse(dto.selectedTimeSlot.arrive);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text("Thời gian: ",
                style: Get.theme.textTheme.headline5.copyWith(color: kPrimary)),
          ),
          Expanded(
            flex: 7,
            child: Text(
                "${DateFormat("HH:mm").format(arrive)} ~ ${DateFormat("HH:mm").format(arrive.add(Duration(minutes: 30)))}",
                style: Get.theme.textTheme.headline4),
          ),
        ],
      ),
    );
  }

  Widget layoutSubtotal() {
    return Container(
      width: MediaQuery.of(context).size.width,

      // margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: kBackgroundGrey[0],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: kPrimary, width: 4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Chi phí',
                  style:
                      Get.theme.textTheme.headline5.copyWith(color: kPrimary),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: kPrimary),
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
                        style: Get.theme.textTheme.headline4,
                      ),
                      Text(
                          NumberFormat.simpleCurrency(locale: 'vi')
                              .format(orderViewModel.orderAmount.totalAmount),
                          style: Get.theme.textTheme.headline4),
                    ],
                  ),
                ),
                MySeparator(
                  color: kPrimary,
                ),
                ..._buildOtherAmount(orderViewModel.orderAmount.others),
                Divider(color: Colors.black),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tổng cộng", style: Get.theme.textTheme.headline3),
                      Text(
                          NumberFormat.simpleCurrency(locale: 'vi')
                              .format(orderViewModel.orderAmount.finalAmount),
                          style: Get.theme.textTheme.headline3),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: Get.width,
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      "Bạn được tặng ${orderViewModel.orderAmount.beanAmount.round().toString()} ",
                  style: Get.theme.textTheme.headline5
                      .copyWith(color: Colors.orange),
                  children: [
                    WidgetSpan(
                        alignment: PlaceholderAlignment.bottom,
                        child: Image(
                          image:
                              AssetImage("assets/images/icons/bean_coin.png"),
                          width: 16,
                          height: 16,
                        )),
                    TextSpan(text: " cho đơn hàng 🎉."),
                  ],
                )),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget selectPaymentMethods() {
    return ScopedModelDescendant<OrderViewModel>(
      builder: (context, child, model) {
        List<Widget> listPayments = [];
        Map<String, dynamic> paymentsType = model.listPayments;
        for (int i = 0; i < paymentsType.length; i++) {
          listPayments.add(
            Container(
              height: 45,
              child: RadioListTile(
                activeColor: kPrimary,
                groupValue: model.currentCart.payment,
                value: paymentsType.values.elementAt(i),
                title: Text(
                  paymentsType.keys.elementAt(i),
                  style: Get.theme.textTheme.headline4,
                ),
                onChanged: (value) async {
                  await model.changeOption(value);
                },
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              decoration: BoxDecoration(
                color: model.currentCart.payment != null
                    ? kBackgroundGrey[0]
                    : Colors.yellow[100],
                border: Border(left: BorderSide(color: kPrimary, width: 4)),
              ),
              padding:
                  const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
              child: RichText(
                text: TextSpan(
                    text: "Phương thức thanh toán ",
                    style:
                        Get.theme.textTheme.headline5.copyWith(color: kPrimary),
                    children: [
                      TextSpan(
                          text: "(*)",
                          style: Get.theme.textTheme.headline5
                              .copyWith(color: Colors.red))
                    ]),
              ),
            ),
            ...listPayments,
            SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget bottomBar() {
    return ScopedModelDescendant<OrderViewModel>(
      builder: (context, child, model) {
        ViewStatus status = model.status;
        switch (status) {
          case ViewStatus.Loading:
            return Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
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
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tổng tiền",
                          style: Get.theme.textTheme.headline4,
                        ),
                        Text(
                          '...',
                          style: Get.theme.textTheme.headline1
                              .copyWith(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  FlatButton(
                    onPressed: () {},
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    textColor: Colors.white,
                    color: kBackgroundGrey[4],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Container(
                      width: 250,
                      height: 48,
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedTextKit(
                            animatedTexts: [
                              FadeAnimatedText(
                                'Đợi tý nha',
                                textStyle: Get.theme.textTheme.headline4
                                    .copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                                // speed: Duration(milliseconds: 300),
                              ),
                              FadeAnimatedText(
                                '🚀',
                                textStyle: Get.theme.textTheme.headline1,
                                textAlign: TextAlign.center,
                                // speed: Duration(milliseconds: 300),
                              ),
                              FadeAnimatedText(
                                '🛵',
                                textStyle: Get.theme.textTheme.headline1,
                                textAlign: TextAlign.center,
                                // speed: Duration(milliseconds: 300),
                              ),
                              FadeAnimatedText(
                                '💻',
                                textStyle: Get.theme.textTheme.headline1,
                                textAlign: TextAlign.center,
                                // speed: Duration(milliseconds: 300),
                              ),
                            ],
                            isRepeatingAnimation: true,
                            repeatForever: true,
                            onTap: () {
                              print("Tap Event");
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            );
          case ViewStatus.Completed:
            LocationDTO location = model.campusDTO.locations.firstWhere(
              (element) => element.isSelected,
              orElse: () => null,
            );
            String errorMsg = null;
            var isMenuAvailable = Get.find<RootViewModel>()
                .currentStore
                .selectedTimeSlot
                .available;
            if (model.errorMessage != null) {
              errorMsg = model.errorMessage;
            } else if (location == null) {
              errorMsg = "Vui lòng chọn địa điểm giao";
            } else if (model.currentCart?.payment == null) {
              errorMsg = "Vui lòng chọn phương thức thanh toán 💰";
            }
            return Container(
              padding: const EdgeInsets.only(left: 8, right: 8),
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
              child: errorMsg == null
                  ? ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(height: 8),
                        FlatButton(
                          onPressed: () async {
                            if (model.currentCart.payment != null &&
                                location != null &&
                                model.status != ViewStatus.Loading &&
                                isMenuAvailable) {
                              await model.orderCart();
                            }
                            // pr.hide();
                            // showStateDialog();
                          },
                          padding: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          textColor: Colors.white,
                          color:
                              isMenuAvailable ? kPrimary : kBackgroundGrey[3],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                  isMenuAvailable
                                      ? "Chốt đơn 👌"
                                      : "Khung giờ đã kết thúc",
                                  style: Get.theme.textTheme.headline3.copyWith(
                                      color: isMenuAvailable
                                          ? Colors.white
                                          : kGreyTitle)),
                              SizedBox(
                                height: 16,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          FlatButton(
                            onPressed: () async {
                              print('Scroll');
                              await controller.scrollToIndex(
                                1,
                                preferPosition: AutoScrollPosition.begin,
                              );
                            },
                            padding: EdgeInsets.only(right: 8.0, left: 8.0),
                            textColor: Colors.white,
                            color: kBackgroundGrey[4],
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: errorMsg,
                                      style: Get.theme.textTheme.headline3
                                          .copyWith(color: Colors.white),
                                      children: []),
                                ),
                                SizedBox(
                                  height: 16,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          default:
            return SizedBox.shrink();
        }
      },
    );
  }

  Widget selectQuantity(
    CartItem item,
  ) {
    Color minusColor = kBackgroundGrey[4];
    if (item.quantity >= 1) {
      minusColor = kPrimary;
    }
    Color plusColor = kPrimary;
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(
              AntDesign.minuscircleo,
              size: 16,
              color: minusColor,
            ),
            onPressed: () async {
              if (item.quantity >= 1) {
                if (item.quantity == 1) {
                  await orderViewModel.deleteItem(item);
                } else {
                  item.quantity--;
                  await orderViewModel.updateQuantity(item);
                }
              }
            },
          ),
          Text(item.quantity.toString()),
          IconButton(
            icon: Icon(
              AntDesign.pluscircleo,
              size: 16,
              color: plusColor,
            ),
            onPressed: () async {
              item.quantity++;
              await orderViewModel.updateQuantity(item);
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOtherAmount(List<OtherAmount> otherAmounts) {
    if (otherAmounts == null) return [SizedBox.shrink()];
    otherAmounts.sort((a, b) => b.amount.compareTo(a.amount));
    return otherAmounts
        .map((amountObj) => OtherAmountWidget(
              otherAmount: amountObj,
            ))
        .toList();
  }
}

class BorderWithCorlor extends StatelessWidget {
  final BorderRadius borderRadius;
  final Widget child;
  const BorderWithCorlor({Key key, this.borderRadius, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ShapeBorderClipper(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
      child: Container(
        child: child,
      ),
    );
  }
}
