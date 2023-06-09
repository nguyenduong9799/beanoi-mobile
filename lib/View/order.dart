import 'package:animated_text_kit/animated_text_kit.dart';
import "package:collection/collection.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:unidelivery_mobile/Accessories/UpSellCollection.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Accessories/slide_fade_animation.dart';
import 'package:unidelivery_mobile/Accessories/time_picker.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/Widgets/beanoi_button.dart';

import 'index.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({Key key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderViewModel orderViewModel = Get.find<OrderViewModel>();
  AutoScrollController controller;
  final scrollDirection = Axis.vertical;
  bool onInit = true;
  int index = 0;

  @override
  void initState() {
    super.initState();
    prepareCart();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    int timeSlotId = orderViewModel.currentCart.timeSlotId;
    index = Get.find<RootViewModel>()
        .listAvailableTimeSlots
        .indexWhere((element) => element.id == timeSlotId);
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
                  if (model.currentCart != null) {
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
                            SizedBox(
                                height: 8,
                                child: Container(
                                  color: kBackgroundGrey[2],
                                )),
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
                              child: timeRecieve(model),
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
                            UpSellCollection(),

                            layoutSubtotal(),
                          ],
                        );

                      default:
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: LoadingScreen(),
                        );
                    }
                  } else
                    return SizedBox.shrink();
                },
              ),
      ),
    );
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

  Widget buildCustomPicker(List<TimeSlots> timeSlot) => Container(
        height: 240,
        decoration: BoxDecoration(
          color: kPrimary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        padding: EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Chọn khung giờ giao hàng',
                style: Get.theme.textTheme.headline2.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: SizedBox(
                  height: 180,
                  child: CupertinoPicker(
                    scrollController:
                        FixedExtentScrollController(initialItem: index),
                    // useMagnifier: true,
                    // magnification: 1.2,
                    itemExtent: 64,
                    diameterRatio: 0.7,
                    onSelectedItemChanged: (index) =>
                        setState(() => this.index = index),
                    selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                      background: Colors.black.withOpacity(0.12),
                    ),
                    children: Utils.modelBuilder<TimeSlots>(
                      timeSlot,
                      (index, value) {
                        String currentTime =
                            value.arriveTime.replaceAll(';', ' - ');

                        final isSelected = this.index == index;
                        final color = isSelected ? kPrimary : Colors.black;

                        return Center(
                          child: Text(
                            "$currentTime",
                            style: TextStyle(
                                color: color,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget layoutOrder(Cart cart) {
    Map<int, List<CartItem>> map =
        groupBy(cart.items, (CartItem item) => item.master.supplierId);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Các món trong giỏ",
                style: Get.theme.textTheme.headline3,
              ),
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
            color: BeanOiTheme.palettes.neutral700,
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
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    list[0].master.supplierName,
                    style: BeanOiTheme.typography.subtitle2
                        .copyWith(color: BeanOiTheme.palettes.primary500),
                  ),
                  Text(
                    list
                            .fold(
                                0,
                                (previousValue, element) =>
                                    previousValue + element.quantity)
                            .toString() +
                        " món",
                    style: BeanOiTheme.typography.subtitle2
                        .copyWith(color: BeanOiTheme.palettes.primary500),
                  )
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(0, 4, 8, 0),
                width: Get.width,
                child: Column(
                  children: [
                    Divider(
                      height: 4,
                      color: BeanOiTheme.palettes.neutral600,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                      child: Row(
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            color: Colors.black,
                            size: 18,
                          ),
                          Flexible(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {
                                    orderViewModel.addSupplierNote(
                                        list[0].master.supplierId);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Text(
                                        (supplierNote == null)
                                            ? "Ghi chú cho nhà hàng"
                                            : supplierNote.content,
                                        overflow: TextOverflow.ellipsis,
                                        style: BeanOiTheme.typography.caption1
                                            .copyWith(
                                                color: BeanOiTheme
                                                    .palettes.neutral700)),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 4,
                      color: BeanOiTheme.palettes.neutral600,
                    ),
                  ],
                ))
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
          style: BeanOiTheme.typography.overline));
      price += item.products[i].price * item.quantity;
    }
    // item.description = "Test đơn hàng";

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
      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Container(
                                          width: 31,
                                          height: 28,
                                          child: CacheImage(
                                              imageUrl: item.master.imageURL ??
                                                  defaultImage),
                                        ),
                                      ),
                                    ),
                                    Text(
                                        item.master.type !=
                                                ProductType.MASTER_PRODUCT
                                            ? item.master.name
                                            : item.products[0].name,
                                        style:
                                            BeanOiTheme.typography.subtitle2),
                                  ],
                                ),
                                Row(children: [
                                  RichText(
                                    text: TextSpan(
                                        text: isGift
                                            ? formatBean(price)
                                            : formatPrice(price),
                                        style: Get.theme.textTheme.headline4,
                                        children: [
                                          WidgetSpan(
                                            alignment:
                                                PlaceholderAlignment.bottom,
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
                                ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...list,
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
    return Container(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () async {
          await orderViewModel.changeLocationOfStore();
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image(
                              image: AssetImage(
                                  "assets/images/icons/location_icon.png"),
                              width: 24,
                              height: 24,
                            ),
                            Text(
                              "Nơi nhận:",
                              style: BeanOiTheme.typography.subtitle2,
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              destination != null
                                  ? Flexible(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            destination.name,
                                            style:
                                                BeanOiTheme.typography.caption1,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Flexible(
                                      child: Text(
                                        "Chọn địa điểm giao hàng",
                                        style: BeanOiTheme.typography.caption1,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 4, 16, 0),
                  child: SvgPicture.asset(
                    'assets/images/icons/Expand_right.svg',
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget timeRecieve(OrderViewModel model) {
    RootViewModel root = Get.find<RootViewModel>();
    List<TimeSlots> listTimeSlotAvailable = root.listAvailableTimeSlots;
    TimeSlots currentTime = listTimeSlotAvailable.firstWhere(
        (element) => element.id == orderViewModel.currentCart.timeSlotId);
    String currentTimeSlot = currentTime.arriveTime.replaceAll(';', ' - ');
    return Container(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: () => Utils.showSheet(
          context,
          child: buildCustomPicker(listTimeSlotAvailable),
          onClicked: () async {
            TimeSlots value = listTimeSlotAvailable[index];
            await Get.find<OrderViewModel>().changeTime(value);
            Get.back();
          },
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: EdgeInsets.fromLTRB(16, 4, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image(
                              image: AssetImage(
                                  "assets/images/icons/clock_icon.png"),
                              width: 24,
                              height: 24,
                            ),
                            Text(
                              "Thời gian nhận:",
                              style: BeanOiTheme.typography.subtitle2,
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "$currentTimeSlot",
                                style: BeanOiTheme.typography.caption1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 4, 16, 0),
                  child: SvgPicture.asset(
                    'assets/images/icons/Expand_right.svg',
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget layoutSubtotal() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        // margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: kBackgroundGrey[0],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Chi phí',
                    style: Get.theme.textTheme.headline3,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(8, 0, 16, 0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: kPrimary),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tạm tính",
                          style: Get.theme.textTheme.headline4,
                        ),
                        Text(
                            formatPrice(orderViewModel.orderAmount.totalAmount),
                            style: Get.theme.textTheme.headline4),
                      ],
                    ),
                  ),
                  MySeparator(
                    color: kPrimary,
                  ),
                  ..._buildOtherAmount(orderViewModel.orderAmount.others),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tổng cộng",
                          style: BeanOiTheme.typography.subtitle2,
                        ),
                        Text(
                            orderViewModel.status == ViewStatus.Loading
                                ? "..."
                                : orderViewModel.currentCart.payment ==
                                        PaymentTypeEnum.Cash
                                    ? formatPrice(
                                        orderViewModel.orderAmount.finalAmount)
                                    : "${formatBean(orderViewModel.orderAmount.finalAmount)} Bean",
                            style: BeanOiTheme.typography.subtitle1
                                .copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            if (orderViewModel.orderAmount.beanAmount.round() != 0)
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
                              image: AssetImage(
                                  "assets/images/icons/bean_coin.png"),
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
      ),
    );
  }

  Widget selectPaymentMethods() {
    return ScopedModel<OrderViewModel>(
      model: orderViewModel,
      child: ScopedModelDescendant<OrderViewModel>(
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
                    style: Get.theme.textTheme.headline3,
                  ),
                  onChanged: (value) async {
                    await model.changeOption(value);
                    Get.back();
                  },
                ),
              ),
            );
          }
          return Container(
            height: Get.height * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: kBackgroundGrey[0],
                  ),
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: RichText(
                    text: TextSpan(
                        text: "Phương thức thanh toán ",
                        style: Get.theme.textTheme.headline1,
                        children: [
                          TextSpan(
                              text: "(*)",
                              style: Get.theme.textTheme.headline1
                                  .copyWith(color: Colors.red))
                        ]),
                  ),
                ),
                ...listPayments,
                SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget bottomBar() {
    return ScopedModelDescendant<OrderViewModel>(
      builder: (context, child, model) {
        if (model.currentCart == null) return SizedBox.shrink();
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
                  orderViewModel.listError.isEmpty
                      ? SizedBox(width: 0)
                      : SlideFadeTransition(
                          delayStart: Duration(milliseconds: 200),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        child: Center(
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                    alignment:
                                                        PlaceholderAlignment
                                                            .bottom,
                                                    child: Icon(
                                                      Icons.warning,
                                                      color: Colors.red,
                                                      size: 16,
                                                    )),
                                                TextSpan(
                                                    text: orderViewModel
                                                        .listError[0])
                                              ],
                                              style: Get
                                                  .theme.textTheme.headline5
                                                  .copyWith(color: Colors.red),
                                            ),
                                            // orderViewModel.listError[0],
                                            // style: TextStyle(
                                            //     color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                              child: TextButton(
                                  onPressed: () async {},
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          model.currentCart.payment ==
                                                  PaymentTypeEnum.Cash
                                              ? FontAwesome5.money_bill_alt
                                              : Icons.monetization_on_outlined,
                                        ),
                                        SizedBox(width: 14),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            model.listPayments.keys.elementAt(
                                                model.currentCart.payment - 1),
                                            style:
                                                Get.theme.textTheme.headline3,
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          'assets/images/icons/dropdown.svg',
                                        ),
                                        SizedBox(width: 18),
                                      ],
                                    ),
                                  ))),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(RouteHandler.VOUCHER);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // SizedBox(width: 8),
                                  model.currentCart.vouchers.isEmpty
                                      ? SvgPicture.asset(
                                          'assets/images/icons/voucher.svg',
                                        )
                                      : SizedBox(
                                          width: 0,
                                        ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      model.currentCart.vouchers.isEmpty
                                          ? "Thêm Voucher"
                                          : model.currentCart.vouchers[0]
                                              .voucherCode
                                              .toUpperCase(),
                                      style: model.currentCart.vouchers.isEmpty
                                          ? Get.theme.textTheme.headline3
                                          : TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    'assets/images/icons/dropdown.svg',
                                  ),
                                  SizedBox(width: 18),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 24),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Tổng cộng",
                                      style: BeanOiTheme.typography.caption1
                                          .copyWith(
                                              color: BeanOiTheme
                                                  .palettes.neutral600)),
                                  SizedBox(height: 6),
                                  Text(
                                    '...',
                                    style: BeanOiTheme.typography.subtitle1
                                        .copyWith(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 8, 24),
                            child: BeanOiButton.solid(
                              onPressed: () {},
                              height: 41,
                              textColor: Colors.white,
                              child: Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedTextKit(
                                      animatedTexts: [
                                        FadeAnimatedText(
                                          'Đợi tý nha',
                                          textStyle: Get
                                              .theme.textTheme.headline3
                                              .copyWith(color: Colors.white),
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
                          ),
                        ),
                      ],
                    ),
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
            var isMenuAvailable =
                Get.find<RootViewModel>().isCurrentMenuAvailable();
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
                          orderViewModel.listError.isEmpty
                              ? SizedBox(width: 0)
                              : SlideFadeTransition(
                                  delayStart: Duration(milliseconds: 200),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 10, 8, 10),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                child: Center(
                                                  child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      children: [
                                                        WidgetSpan(
                                                            alignment:
                                                                PlaceholderAlignment
                                                                    .bottom,
                                                            child: Icon(
                                                              Icons.warning,
                                                              color: Colors.red,
                                                              size: 16,
                                                            )),
                                                        TextSpan(
                                                            text: orderViewModel
                                                                .listError[0])
                                                      ],
                                                      style: Get.theme.textTheme
                                                          .headline5
                                                          .copyWith(
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                    // orderViewModel.listError[0],
                                                    // style: TextStyle(
                                                    //     color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                      child: TextButton(
                                          onPressed: () async {
                                            Get.bottomSheet(
                                              selectPaymentMethods(),
                                              backgroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            );
                                            // pr.hide();
                                            // showStateDialog();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  model.currentCart.payment ==
                                                          PaymentTypeEnum.Cash
                                                      ? FontAwesome5
                                                          .money_bill_alt
                                                      : Icons
                                                          .monetization_on_outlined,
                                                ),
                                                SizedBox(width: 14),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    model.listPayments.keys
                                                        .elementAt(model
                                                                .currentCart
                                                                .payment -
                                                            1),
                                                    style: Get.theme.textTheme
                                                        .headline3,
                                                    textAlign: TextAlign.left,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SvgPicture.asset(
                                                  'assets/images/icons/dropdown.svg',
                                                ),
                                                SizedBox(width: 18),
                                              ],
                                            ),
                                          ))),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    child: TextButton(
                                      onPressed: () {
                                        Get.toNamed(RouteHandler.VOUCHER);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // SizedBox(width: 8),
                                          model.currentCart.vouchers.isEmpty
                                              ? SvgPicture.asset(
                                                  'assets/images/icons/voucher.svg',
                                                )
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              model.currentCart.vouchers.isEmpty
                                                  ? "Thêm Voucher"
                                                  : model.currentCart
                                                      .vouchers[0].voucherCode
                                                      .toUpperCase(),
                                              style: model.currentCart.vouchers
                                                      .isEmpty
                                                  ? Get
                                                      .theme.textTheme.headline3
                                                  : TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SvgPicture.asset(
                                            'assets/images/icons/dropdown.svg',
                                          ),
                                          SizedBox(width: 18),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 0, 24),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Tổng cộng",
                                            style: BeanOiTheme
                                                .typography.caption1
                                                .copyWith(
                                                    color: BeanOiTheme
                                                        .palettes.neutral600),
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                              orderViewModel.status ==
                                                      ViewStatus.Loading
                                                  ? "..."
                                                  : orderViewModel.currentCart
                                                              .payment ==
                                                          PaymentTypeEnum.Cash
                                                      ? formatPrice(
                                                          orderViewModel
                                                              .orderAmount
                                                              .finalAmount)
                                                      : "${formatBean(orderViewModel.orderAmount.finalAmount)} Bean",
                                              style: BeanOiTheme
                                                  .typography.subtitle1
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 8, 24),
                                    child: BeanOiButton.solid(
                                      onPressed: () async {
                                        if (model.currentCart.payment != null &&
                                            location != null &&
                                            model.status !=
                                                ViewStatus.Loading &&
                                            isMenuAvailable) {
                                          await model.orderCart();
                                        }
                                      },
                                      height: 41,
                                      textColor: Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              isMenuAvailable
                                                  ? "Đặt đơn"
                                                  : "Khung giờ đã kết thúc",
                                              style: Get
                                                  .theme.textTheme.headline3
                                                  .copyWith(
                                                      color: isMenuAvailable
                                                          ? Colors.white
                                                          : kGreyTitle)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          orderViewModel.listError.isEmpty
                              ? SizedBox(width: 0)
                              : SlideFadeTransition(
                                  delayStart: Duration(milliseconds: 200),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 10, 8, 10),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Container(
                                                child: Center(
                                                  child: RichText(
                                                    textAlign: TextAlign.center,
                                                    text: TextSpan(
                                                      children: [
                                                        WidgetSpan(
                                                            alignment:
                                                                PlaceholderAlignment
                                                                    .bottom,
                                                            child: Icon(
                                                              Icons.warning,
                                                              color: Colors.red,
                                                              size: 16,
                                                            )),
                                                        TextSpan(
                                                            text: orderViewModel
                                                                .listError[0])
                                                      ],
                                                      style: Get.theme.textTheme
                                                          .headline5
                                                          .copyWith(
                                                              color:
                                                                  Colors.red),
                                                    ),
                                                    // orderViewModel.listError[0],
                                                    // style: TextStyle(
                                                    //     color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                      child: TextButton(
                                          onPressed: () async {
                                            Get.bottomSheet(
                                              selectPaymentMethods(),
                                              backgroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            );
                                            // pr.hide();
                                            // showStateDialog();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 0, 0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  model.currentCart.payment ==
                                                          PaymentTypeEnum.Cash
                                                      ? FontAwesome5
                                                          .money_bill_alt
                                                      : Icons
                                                          .monetization_on_outlined,
                                                ),
                                                SizedBox(width: 14),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    "...",
                                                    style: Get.theme.textTheme
                                                        .headline3,
                                                    textAlign: TextAlign.left,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SvgPicture.asset(
                                                  'assets/images/icons/dropdown.svg',
                                                ),
                                                SizedBox(width: 18),
                                              ],
                                            ),
                                          ))),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    child: TextButton(
                                      onPressed: () {
                                        Get.toNamed(RouteHandler.VOUCHER);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // SizedBox(width: 8),
                                          model.currentCart.vouchers.isEmpty
                                              ? SvgPicture.asset(
                                                  'assets/images/icons/voucher.svg',
                                                )
                                              : SizedBox(
                                                  width: 0,
                                                ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              model.currentCart.vouchers.isEmpty
                                                  ? "Thêm Voucher"
                                                  : model.currentCart
                                                      .vouchers[0].voucherCode
                                                      .toUpperCase(),
                                              style: model.currentCart.vouchers
                                                      .isEmpty
                                                  ? Get
                                                      .theme.textTheme.headline3
                                                  : TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SvgPicture.asset(
                                            'assets/images/icons/dropdown.svg',
                                          ),
                                          SizedBox(width: 18),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 0, 24),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Tổng cộng",
                                            style: BeanOiTheme
                                                .typography.caption1
                                                .copyWith(
                                                    color: BeanOiTheme
                                                        .palettes.neutral600),
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            "...",
                                            style: BeanOiTheme
                                                .typography.subtitle1
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 24),
                                    child: BeanOiButton.solid(
                                      onPressed: () async {},
                                      height: 50,
                                      textColor: Colors.white,
                                      child: Text(
                                          // "Vui lòng chọn phương thức thanh toán 💰",
                                          errorMsg,
                                          style: Get.theme.textTheme.headline3
                                              .copyWith(
                                                  color: isMenuAvailable
                                                      ? Colors.white
                                                      : kGreyTitle)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ));
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 18,
              width: 18,
              child: IconButton(
                padding: new EdgeInsets.all(0.0),
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
            ),
            Container(
              width: 30,
              child: Text(
                item.quantity.toString(),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 18,
              width: 18,
              child: IconButton(
                padding: new EdgeInsets.all(0.0),
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
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOtherAmount(List<OtherAmount> otherAmounts) {
    if (otherAmounts == null) return [SizedBox.shrink()];
    otherAmounts.sort((a, b) => b.amount.compareTo(a.amount));
    return otherAmounts
        .map((amountObj) => SlideFadeTransition(
              // direction: Direction.horizontal,
              offset: -1,
              delayStart: Duration(milliseconds: 20),
              child: OtherAmountWidget(
                otherAmount: amountObj,
              ),
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
