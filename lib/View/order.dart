import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Bussiness/BussinessHandler.dart';
import 'package:unidelivery_mobile/Model/DTO/StoreDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/acessories/dash_border.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/services/analytic_service.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderViewModel orderViewModel;
  String orderNote = "";

  @override
  void initState() {
    super.initState();
    orderViewModel = OrderViewModel.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: orderViewModel,
      child: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, OrderViewModel model) {
          return FutureBuilder(
            future: model.cart,
            builder: (BuildContext context, AsyncSnapshot<Cart> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  Cart cart = snapshot.data;
                  double total = model.countPrice(snapshot.data);
                  return Scaffold(
                    bottomNavigationBar: bottomBar(total),
                    appBar: DefaultAppBar(title: "Đơn hàng của bạn"),
                    body: FutureBuilder(
                      future: getStore(),
                      builder: (BuildContext context,
                          AsyncSnapshot<StoreDTO> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            StoreDTO dto = snapshot.data;
                            return SingleChildScrollView(
                              child: Center(
                                child: Column(
                                  children: [
                                    Hero(
                                      tag: CART_TAG,
                                      child: Container(
                                          margin: const EdgeInsets.only(top: 8),
                                          child: layoutAddress(dto.location)),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        child: buildBeanReward(total)),
                                    Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        child: layoutOrder(cart, dto.name)),
                                    layoutSubtotal(total),
                                    selectPaymentMethods()
                                    //SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            );
                          }
                        }
                        return Container();
                      },
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("Không có đơn hàng nào")),
                  );
                }
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator()),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildBeanReward(double total) {
    int bean = BussinessHandler.beanReward(total);
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
                      children: <TextSpan>[
                        TextSpan(
                          text: "${bean.toString()} bean",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: kPrimary,
                          ),
                        ),
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
          padding: const EdgeInsets.all(8),
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
      print("Khác" + item.master.type.toString());
      price = BussinessHandler.countPrice(item.master.prices, item.quantity);
    }

    print("Price: "+ price.toString());

    // if (item.master.type == MASTER_PRODUCT) {
    //   list.add(Text(item.products[0].name,
    //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)));
    //   price = item.products[0].price;
    //   for (int i = 1; i < item.products.length; i++) {
    //     list.add(SizedBox(
    //       height: 10,
    //     ));
    //     list.add(Text(
    //         item.products[i].name.contains("Extra")
    //             ? item.products[i].name.replaceAll("Extra", "+")
    //             : item.products[i].name,
    //         style: TextStyle(fontSize: 14)));
    //     price += item.products[i].price;
    //   }
    // } else {
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
      price +=
          BussinessHandler.countPrice(item.products[i].prices, item.quantity);
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
                          imageUrl: item.master.imageURL != null
                              ? item.master.imageURL
                              : defaultImage,
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
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65 - 110,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...list,
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              NumberFormat.simpleCurrency(locale: 'vi')
                                  .format(price),
                              style: TextStyle(fontSize: 14),
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
              showLoadingDialog();
              bool result = await removeItemFromCart(item);
              if (result) {
                await AnalyticsService.getInstance()
                    .logChangeCart(item.master, item.quantity, false);
                hideDialog();
                Get.back(result: false);
              } else {
                orderViewModel.notifyListeners();
                hideDialog();
              }
            }),
      ],
    );
  }

  Widget layoutAddress(String location) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: kBackgroundGrey[0],
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey),
              SizedBox(
                width: 10,
              ),
              Text(
                location,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Material(
              color: kBackgroundGrey[2],
              child: TextFormField(
                onChanged: (value) {
                  orderNote = value;
                  print("Note: " + orderNote);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.description),
                  hintText: "Ghi chú",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget layoutSubtotal(double total) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      // margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: kBackgroundGrey[0],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "Tổng tiền",
          //   style: TextStyle(fontWeight: FontWeight.bold),
          // ),
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
                              .format(total - DELIVERY_FEE),
                          style: kTextSecondary),
                    ],
                  ),
                ),
                MySeparator(
                  color: kPrimary,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Phí vận chuyển", style: kTextSecondary),
                      Text(
                          NumberFormat.simpleCurrency(locale: 'vi')
                              .format(DELIVERY_FEE),
                          style: kTextSecondary),
                    ],
                  ),
                ),
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
                              .format(total),
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
    return ScopedModel(
        model: orderViewModel,
        child: ScopedModelDescendant<OrderViewModel>(
          builder: (context, child, model) {
            List<Widget> listPayments = new List();
            for (int i = 0; i < model.options.keys.length; i++) {
              listPayments.add(RadioListTile(
                activeColor: kPrimary,
                groupValue: model.payment,
                value: model.options.keys.elementAt(i),
                title: Text(model.options[model.options.keys.elementAt(i)]),
                onChanged: (value) {
                  model.changeOption(value);
                },
              ));
            }

            return Container(
              color: kBackgroundGrey[0],
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Text(
                      "Phương thức thanh toán",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: kPrimary),
                    ),
                  ),
                  ...listPayments
                ],
              ),
            );
          },
        ));
  }

  Widget bottomBar(double total) {
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  NumberFormat.simpleCurrency(locale: 'vi').format(total),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          orderViewModel.payment != null
              ? FlatButton(
                  onPressed: () async {
                    if (orderViewModel.payment != null) {
                      await orderViewModel.orderCart(orderNote, total);
                    }
                    // pr.hide();
                    // showStateDialog();
                  },
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  textColor: Colors.white,
                  color: kPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text("Chốt đơn",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                )
              : FlatButton(
                  onPressed: () async {},
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  textColor: Colors.white,
                  color: kBackgroundGrey[4],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text("Vui lòng chọn phương thức thanh toán",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
          SizedBox(
            height: 8,
          )
        ],
      ),
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
            size: 20,
            color: minusColor,
          ),
          onPressed: () async {
            if (item.quantity != 1) {
              showLoadingDialog();
              item.quantity--;
              await updateItemFromCart(item);
              //await AnalyticsService.getInstance().logChangeCart(item.master, item.quantity, false);
              orderViewModel.notifyListeners();
              hideDialog();
            }
          },
        ),
        Text(item.quantity.toString()),
        IconButton(
          icon: Icon(
            AntDesign.pluscircleo,
            size: 20,
            color: plusColor,
          ),
          onPressed: () async {
            showLoadingDialog();
            item.quantity++;
            await updateItemFromCart(item);
            //await AnalyticsService.getInstance().logChangeCart(item.master, item.quantity, true);
            orderViewModel.notifyListeners();
            hideDialog();
          },
        )
      ],
    );
  }
}
