import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/View/start_up.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/acessories/dash_border.dart';
import 'package:unidelivery_mobile/acessories/loading.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/index.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderViewModel orderViewModel;

  @override
  void initState() {
    super.initState();
    orderViewModel = OrderViewModel();
    orderViewModel.prepareOrder();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: orderViewModel,
      child: Scaffold(
        backgroundColor: kBackgroundGrey[0],
        appBar: DefaultAppBar(title: "Đơn hàng của bạn"),
        bottomNavigationBar: bottomBar(),
        body: ScopedModelDescendant<OrderViewModel>(
          builder: (BuildContext context, Widget child, OrderViewModel model) {
            ViewStatus status = model.status;
            switch (status) {
              case ViewStatus.Loading:
                return Center(child: LoadingBean());
              case ViewStatus.Completed:
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Hero(
                      tag: CART_TAG,
                      child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: layoutAddress(model.campusDTO)),
                    ),

                    timeRecieve(model.campusDTO),
                    SizedBox(
                        height: 8,
                        child: Container(
                          color: kBackgroundGrey[2],
                        )),
                    Container(child: buildBeanReward()),
                    SizedBox(
                        height: 8,
                        child: Container(
                          color: kBackgroundGrey[2],
                        )),
                    Container(
                        child: layoutOrder(
                            model.currentCart, model.campusDTO.name)),
                    layoutSubtotal(),
                    selectPaymentMethods()
                    //SizedBox(height: 16),
                  ],
                );
              case ViewStatus.Error:
                return ListView(
                  children: [
                    Center(
                      child: Text(
                        "Có gì đó sai sai..\n Vui lòng thử lại.",
                        style: kTextPrimary.copyWith(
                            fontSize: 20, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 8),
                    Image.asset(
                      'assets/images/global_error.png',
                      fit: BoxFit.contain,
                    ),
                  ],
                );
              default:
                return LoadingScreen();
            }
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
                      style: TextStyle(
                        fontSize: 12,
                        // fontWeight: FontWeight.w100,
                        color: Colors.black45,
                      ),
                      children: [
                        TextSpan(
                          text:
                              "${orderViewModel.orderAmount.beanAmount.toString()} ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.orange,
                          ),
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

  Widget layoutOrder(Cart cart, String store) {
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                      "Thêm",
                      style: TextStyle(color: kPrimary),
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
        layoutStore(cart.items, cart.itemQuantity(), store),
      ],
    );
  }

  Widget layoutStore(List<CartItem> list, int quantity, String store) {
    List<Widget> card = new List();

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
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  store,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(quantity.toString() + " món")
              ],
            ),
          ),
          ...card
        ],
      ),
    );
  }

  Widget productCard(CartItem item) {
    List<Widget> list = new List();
    double price = 0;
    if (item.master.type != ProductType.MASTER_PRODUCT) {
      price = item.master.price * item.quantity;
    }

    list.add(Text(item.master.name,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)));
    for (int i = 0; i < item.products.length; i++) {
      list.add(SizedBox(
        height: 10,
      ));
      list.add(Text(
          item.products[i].name.contains("Extra")
              ? item.products[i].name.replaceAll("Extra", "+")
              : item.products[i].name,
          style: TextStyle(fontSize: 13, color: kBackgroundGrey[5])));
      price += item.products[i].price * item.quantity;
    }

    if (item.description != null && item.description.isNotEmpty) {
      list.add(SizedBox(
        height: 8,
      ));
      list.add(Text(
        item.description,
        style: TextStyle(fontSize: 14),
      ));
    }

    bool isGift = false;
    if (item.master.type == ProductType.GIFT_PRODUCT) {
      isGift = true;
    }

    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: kBackgroundGrey[0],
        padding: EdgeInsets.only(right: 5, left: 5, top: 10, bottom: 10),
        child: InkWell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
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
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65 - 120,
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
                                  style: TextStyle(color: Colors.black),
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
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  selectQuantity(item)
                ],
              ),
            ],
          ),
        ),
      ),
      secondaryActions: [
        IconSlideAction(
            color: kBackgroundGrey[2],
            foregroundColor: Colors.red,
            icon: Icons.delete,
            onTap: () async {
              await orderViewModel.deleteItem(item);
            }),
      ],
    );
  }

  Widget layoutAddress(CampusDTO store) {
    return ScopedModelDescendant<OrderViewModel>(
      builder: (context, child, model) {
        return Column(
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.orange),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  child: Text(
                    store.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              width: Get.width,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    model.location != null ? Colors.white : Colors.yellow[100],
              ),
              child: RichText(
                text: TextSpan(
                    text: "Nhận đơn tại ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: kPrimary),
                    children: [
                      TextSpan(
                          text: "(*)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.red))
                    ]),
              ),
            ),
            SizedBox(
              height: 0,
            ),
            InkWell(
              onTap: () async {
                await model.processChangeLocation();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                          model.location != null
                              ? model.location.address
                              : "Bạn vui lòng chọn địa điểm giao hàng",
                          style: kTextSecondary.copyWith(
                            color: Colors.grey,
                          )),
                    ),
                    Icon(
                      Icons.navigate_next,
                      color: Colors.orange,
                      size: 24,
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget timeRecieve(CampusDTO dto) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
            text: "🔔 Nhận hàng lúc: ",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: kPrimary),
            children: [
              TextSpan(
                  text:
                      "${dto.selectedTimeSlot.arrive.substring(0, 5)}",
                  style: TextStyle(fontSize: 14, color: Colors.black))
            ]),
      ),
    );
  }

  Widget layoutSubtotal() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
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
                        style: kTextSecondary,
                      ),
                      Text(
                          NumberFormat.simpleCurrency(locale: 'vi')
                              .format(orderViewModel.orderAmount.totalAmount),
                          style: kTextSecondary),
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
                      Text("Tổng cộng",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          NumberFormat.simpleCurrency(locale: 'vi')
                              .format(orderViewModel.orderAmount.finalAmount),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget selectPaymentMethods() {
    return ScopedModelDescendant<OrderViewModel>(
      builder: (context, child, model) {
        List<Widget> listPayments = new List();
        Map<String, dynamic> paymentsType = model.listPayments;
        for (int i = 0; i < paymentsType.length; i++) {
          listPayments.add(
            RadioListTile(
              activeColor: kPrimary,
              groupValue: model.currentCart.payment,
              value: paymentsType.values.elementAt(i),
              title: Text(paymentsType.keys.elementAt(i)),
              onChanged: (value) async {
                await model.changeOption(value);
              },
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              color: model.currentCart.payment != null
                  ? kBackgroundGrey[0]
                  : Colors.yellow[100],
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: RichText(
                text: TextSpan(
                    text: "Phương thức thanh toán ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: kPrimary),
                    children: [
                      TextSpan(
                          text: "(*)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.red))
                    ]),
              ),
            ),
            ...listPayments
          ],
        );
      },
    );
  }

  Widget bottomBar() {
    return ScopedModelDescendant<OrderViewModel>(
      builder: (context, child, model) {
        switch (model.status) {
          case ViewStatus.Completed:
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
              child: model.currentCart.payment != null && model.location != null
                  ? ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tổng tiền",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                NumberFormat.simpleCurrency(locale: 'vi')
                                    .format(model.orderAmount.finalAmount),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        FlatButton(
                          onPressed: () async {
                            if (model.currentCart.payment != null &&
                                model.location != null) {
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
                          color: kPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              Text("Chốt đơn 👌",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
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
                            onPressed: () async {},
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
                                      text:
                                          "Vui lòng chọn những phần bắt buộc ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                      children: [
                                        TextSpan(
                                            text: "(*)",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: Colors.red))
                                      ]),
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

  Widget selectQuantity(CartItem item) {
    Color minusColor = kBackgroundGrey[4];
    if (item.quantity > 1) {
      minusColor = kPrimary;
    }
    Color plusColor = kPrimary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            AntDesign.minuscircleo,
            size: 16,
            color: minusColor,
          ),
          onPressed: () async {
            if (item.quantity != 1) {
              item.quantity--;
              await orderViewModel.updateQuantity(item);
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
        Icon(Icons.arrow_back_ios_outlined, color: Colors.orange, size: 16,)
      ],
    );
  }

  List<Widget> _buildOtherAmount(List<OtherAmount> otherAmounts) {
    if (otherAmounts == null) return [SizedBox.shrink()];
    NumberFormat formatter = NumberFormat();
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    return otherAmounts
        .map((amountObj) => Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${amountObj.name}", style: TextStyle()),
                  RichText(
                    text: new TextSpan(
                      text: amountObj.amount < 0 ? '🌟' : '',
                      children: <TextSpan>[
                        new TextSpan(
                          text:
                              "${formatter.format(amountObj.amount)} ${amountObj.unit}",
                          style: new TextStyle(
                            color: amountObj.amount < 0
                                ? Colors.orange
                                : Colors.grey,
                            decoration: amountObj.amount < 0
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        new TextSpan(
                          text: amountObj.amount < 0 ? '🌟' : '',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
