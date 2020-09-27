import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Bussiness/BussinessHandler.dart';
import 'package:unidelivery_mobile/Model/DAO/OrderDAO.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/ViewModel/orderTotal_viewModel.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/acessories/dash_border.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderViewModel orderViewModel;
  ProgressDialog pr;
  String orderNote = "";

  @override
  void initState() {
    super.initState();
    orderViewModel = new OrderViewModel();
    pr = new ProgressDialog(
      context,
      showLogs: true,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
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
                  double total = countPrice(snapshot.data);
                  return Scaffold(
                    bottomNavigationBar: bottomBar(total),
                    appBar: DefaultAppBar(title: "Đơn hàng của bạn"),
                    body: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            Hero(
                              tag: CART_TAG,
                              child: Container(
                                  margin: const EdgeInsets.only(top: 8),
                                  child: layoutAddress()),
                            ),
                            Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: buildBeanReward(total)),
                            Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: layoutOrder(snapshot.data)),
                            Container(
                                margin: const EdgeInsets.only(top: 8),
                                child: layoutSubtotal(total)),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
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

  Widget layoutOrder(Cart cart) {
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
                    "Các món đã đặt",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  OutlineButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    borderSide: BorderSide(color: kPrimary),
                    child: Text(
                      "Thêm",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
              Divider(
                color: Colors.black,
                thickness: 2,
              )
            ],
          ),
        ),
        layoutStore(cart.items),
      ],
    );
  }

  Widget layoutStore(List<CartItem> list) {
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

    return FutureBuilder(
      future: getStore(),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasData) {
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
                        snapshot.data['name'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ...card
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget productCard(CartItem item) {
    List<Widget> list = new List();
    double price = item.master.price;

    if (item.master.type == MASTER_PRODUCT) {
      list.add(Text(item.products[0].name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
      price = item.products[0].price;
      for (int i = 1; i < item.products.length; i++) {
        list.add(SizedBox(
          height: 10,
        ));
        list.add(Text(
            item.products[i].name.contains("Extra")
                ? item.products[i].name.replaceAll("Extra", "+")
                : item.products[i].name,
            style: TextStyle(fontSize: 14)));
        price += item.products[i].price;
      }
    } else {
      list.add(Text(item.master.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)));
      for (int i = 0; i < item.products.length; i++) {
        list.add(SizedBox(
          height: 10,
        ));
        list.add(Text(
            item.products[i].name.contains("Extra")
                ? item.products[i].name.replaceAll("Extra", "+")
                : item.products[i].name,
            style: TextStyle(fontSize: 14)));
        price += item.products[i].price;
      }
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
                      CachedNetworkImage(
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
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
                                  .format(price * item.quantity),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
              await pr.show();
              bool result = await removeItemFromCart(item);
              if (result) {
                await pr.hide();
                Navigator.of(context).pop(false);
              } else {
                orderViewModel.notifyListeners();
                await pr.hide();
              }
            }),
      ],
    );
  }

  Widget layoutAddress() {
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
                "FPT University",
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
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kBackgroundGrey[0],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tổng tiền",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: kBackgroundGrey[4]),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tạm tính",
                        style: TextStyle(),
                      ),
                      Text(
                          NumberFormat.simpleCurrency(locale: 'vi')
                              .format(total - DELIVERY_FEE),
                          style: TextStyle()),
                    ],
                  ),
                ),
                MySeparator(),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Phí vận chuyển", style: TextStyle()),
                      Text(
                          NumberFormat.simpleCurrency(locale: 'vi')
                              .format(DELIVERY_FEE),
                          style: TextStyle()),
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
          FlatButton(
            onPressed: () async {
              await pr.show();
              OrderDAO dao = new OrderDAO();
              int result = await dao.createOrders(orderNote);
              if (result == SUCCESS) {
                await deleteCart();
                await pr.hide();
                Navigator.pop(context, true);
              } else if (result == FAIL) {
                await pr.hide();
                showStatusDialog(
                    context,
                    Icon(
                      Icons.error_outline,
                      color: kFail,
                    ),
                    "Thất bại :(",
                    "Vui lòng thử lại sau");
              } else {
                await pr.hide();
                showStatusDialog(
                    context,
                    Icon(
                      Icons.error_outline,
                      color: kFail,
                    ),
                    "Thất bại :(",
                    "Có đủ tiền đâu mà mua (>_<)");
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
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
            Icons.do_not_disturb_on,
            size: 20,
            color: minusColor,
          ),
          onPressed: () async {
            if (item.quantity != 1) {
              await pr.show();
              item.quantity--;
              await updateItemFromCart(item);
              orderViewModel.notifyListeners();
              await pr.hide();
            }
          },
        ),
        Text(item.quantity.toString()),
        IconButton(
          icon: Icon(
            Icons.add_circle,
            size: 20,
            color: plusColor,
          ),
          onPressed: () async {
            await pr.show();
            item.quantity++;
            await updateItemFromCart(item);
            orderViewModel.notifyListeners();
            await pr.hide();
          },
        )
      ],
    );
  }

  double countPrice(Cart cart) {
    double total = 0;
    for (CartItem item in cart.items) {
      double subTotal = item.master.price;
      for (ProductDTO dto in item.products) {
        subTotal += dto.price;
      }
      total += (subTotal * item.quantity);
    }
    total += DELIVERY_FEE;
    return total;
  }
}
