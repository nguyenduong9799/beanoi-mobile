
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/View/home.dart';
import 'package:unidelivery_mobile/ViewModel/order_viewModel.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/acessories/dash_border.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';
class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  double total;
  ProgressDialog pr;


  @override
  void initState() {
    super.initState();
    total = 0;
    pr = new ProgressDialog(
      context,
      showLogs: true,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar(),
      appBar: DefaultAppBar(title: "Đơn hàng của bạn"),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: layoutAddress()),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: layoutOrder()),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: layoutSubtotal())
            ],
          ),
        ),
      ),
    );
  }

  Widget layoutOrder(){
    return FutureBuilder(
      future: getCart(),
      builder: (BuildContext context, AsyncSnapshot<Cart> snapshot) {
        if(snapshot.hasData){
          if(snapshot.data != null){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: kBackgroundGrey[0],
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Các món đã đặt", style: TextStyle(fontWeight: FontWeight.bold),),
                          OutlineButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomeScreen(),));
                            },
                            borderSide: BorderSide(
                                color: Colors.black
                            ),
                            child: Text("Thêm", style: TextStyle(color: Colors.black),),
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

                layoutStore(snapshot.data.storeName, snapshot.data.items),

              ],
            );
          }
          return Text("Chưa có đơn nào");
        }
        return CircularProgressIndicator();
      },
    );
  }
  
  Widget layoutStore(String store, List<CartItem> list){

    List<Widget> card = new List();
    for(CartItem item in list){
        card.add(productCard(item));
    }

    return Container(
      color: kBackgroundGrey[0],
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(store, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),),
                  Text(list.length.toString() + " món", style: TextStyle(),),
                ],
            ),
          ),
          ...card
        ],
      ),
    );
  }

  Widget productCard(CartItem item){
    List<Widget> list = new List();
    list.add(Text(item.products[0].name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)));

    double price = item.products[0].price;

    for(int i = 1; i < item.products.length; i++){
      list.add(SizedBox(height: 10,));
      list.add(Text(item.products[i].name, style: TextStyle(fontSize: 14)));
      price += item.products[i].price;
    }

    if(item.description.isNotEmpty){
      list.add(SizedBox(height: 10,));
      list.add(Text(item.description, style: TextStyle(fontSize: 14),));
    }

    return ScopedModel(
      model: new OrderViewModel(price, item.quantity),
      child: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, OrderViewModel model) {
          if(model.count > 0)
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
                            FadeInImage(
                              placeholder: AssetImage('assets/images/avatar.png'),
                              image: NetworkImage(item.products[0].imageURL),
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width * 0.25,
                            ),
                            SizedBox(width: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.65 - 120,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...list,
                                  SizedBox(height: 10,),
                                  Text(NumberFormat.simpleCurrency(locale: 'vi').format(model.total), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)
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
                color: kBackgroundGrey[3],
                foregroundColor: Colors.red,
                  icon: Icons.delete,
                  onTap: () async {
                    model.deleteQuantity();
                    await pr.show();
                    await removeItemFromCart(item);
                    await pr.hide();
                  }
              ),
            ],
          );
          return Container();

        },
      ),
    );
  }

  Widget layoutAddress(){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kBackgroundGrey[0],
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 10,),
                Text("FPT University", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
              ],),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Material(
              color:  kBackgroundGrey[2],
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description),
                  hintText: "Ghi chú"
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget layoutSubtotal(){
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
          Text("Tổng tiền", style: TextStyle(fontWeight: FontWeight.bold),),
          Container(
            margin: EdgeInsets.only(top: 15),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: kBackgroundGrey[4]
              ),
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tạm tính", style: TextStyle(),),
                      Text(NumberFormat.simpleCurrency(locale: 'vi').format(total), style: TextStyle(
                      )),
                    ],
                  ),
                ),
                MySeparator(
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Phí vận chuyển",  style: TextStyle()),
                      Text(NumberFormat.simpleCurrency(locale: 'vi').format(5000), style: TextStyle()),
                    ],
                  ),
                ),
                Divider(
                    color: Colors.black
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tổng cộng",  style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(NumberFormat.simpleCurrency(locale: 'vi').format(total + 5000), style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget bottomBar(){
      return  Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
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
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tổng tiền", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),),
                    Text(NumberFormat.simpleCurrency(locale: 'vi').format(total + 5000), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
                  ],
              ),
            ),
            SizedBox(height: 15,),
            FlatButton(
              onPressed: () async {
                showLoadingDialog();
                // pr.hide();
                // showStateDialog();
              },
              padding: EdgeInsets.only(left: 8.0, right:  8.0),
              textColor: Colors.white,
              color: kPrimary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Text("Chốt đơn"),
            )
          ],
        ),
      );
  }

  Widget selectQuantity(CartItem item){
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, OrderViewModel model) {
        total += model.price;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.do_not_disturb_on, size: 20, color: model.minusColor,),
              onPressed: () async {
                int count = model.count;
                model.minusQuantity();
                if(model.count != count){
                  await pr.show();
                  item.quantity = model.count;
                  await updateItemFromCart(item);
                  await pr.hide();
                }
              },
            ),
            Text(model.count.toString()),
            IconButton(
              icon: Icon(Icons.add_circle, size: 20, color: model.addColor,),
              onPressed: () async {
                model.addQuantity();
                await pr.show();
                item.quantity = model.count;
                await updateItemFromCart(item);
                await pr.hide();

              },
            )
          ],
        );
      },
    );
  }

  Future<void> showLoadingDialog() async {
    showDialog<dynamic>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.white,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.all(Radius.circular(8.0))),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dialogContent()
                ],
              ),
            ));
      },
    );
    // Delaying the function for 200 milliseconds
  }

  Widget dialogContent(){
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(width: 8.0),
                SpinKitDualRing(
                  color: Colors.blue[400],
                  size: 40,
                ),
                const SizedBox(width: 20.0),
                Text(
                  "Loading...",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 60,),
            Center(child: Text("Thành công", style: TextStyle(fontWeight: FontWeight.bold),)),
            SizedBox(height: 10,),
            Text("Đơn hàng của bạn sẽ được giao trong vòng 20 phút nữa"),
            SizedBox(height: 20,),
            ButtonTheme(
              minWidth: double.infinity,
              child: FlatButton(
                color: kPrimary,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("OK"),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }
  
}
