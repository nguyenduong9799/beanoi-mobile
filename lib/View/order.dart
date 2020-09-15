
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/ViewModel/quantity_viewModel.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/acessories/dash_border.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
import 'package:unidelivery_mobile/constraints.dart';
class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

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

        layoutStore("Bà Mười", [
          productCard("https://beptruong.edu.vn/wp-content/uploads/2018/06/cach-uop-thit-nuong-com-tam.jpg", "Cơm Tấm", "", "", "", 20000),
        ]),

        layoutStore("Hẻm 447", [
          productCard("https://www.huongnghiepaau.com/wp-content/uploads/2019/01/che-buoi-an-giang.jpg", "Chè Bưởi", "size M", "Trân châu đen", "Ít đá", 7000),
          productCard("https://bizweb.dktcdn.net/100/004/714/articles/nguyen-lieu-tra-sua-gia-re.jpg?v=1559644357347", "Trà sữa", "size M", "Trân châu đen", "Ít đá", 27000),
        ])
      ],
    );
  }
  
  Widget layoutStore(String store, List<Widget> card){

    int length = card.length;
    for(int i = 0; i < card.length; i++){
      if(i % 2 != 0){
        card.insert(i, Container(
            color: kBackgroundGrey[0],
            child: MySeparator(color: kBackgroundGrey[4],)));
      }
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
                  Text(length.toString() + " món", style: TextStyle(),),
                ],
            ),
          ),
          ...card
        ],
      ),
    );
  }

  Widget productCard(String imageUrl, String name, String size, String topping, String note,  double price){
    List<Widget> list = new List();
    list.add(Text(name + " " + size, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)));

    if(topping.isNotEmpty){
      list.add(SizedBox(height: 10,));
      list.add(Text(topping, style: TextStyle(fontSize: 14)));
    }

    if(note.isNotEmpty){
      list.add(SizedBox(height: 10,));
      list.add(Text(note, style: TextStyle(fontSize: 14),));
    }
    return ScopedModel(
      model: new QuantityViewModel(price),
      child: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, QuantityViewModel model) {
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
                            Image(
                              image: NetworkImage(imageUrl),
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
                        selectQuantity()
                      ],
                    ),

                  ],
                ),
              ),
            ),
            secondaryActions: [
              IconSlideAction(
                color: kBackgroundGrey[2],
                foregroundColor: Colors.blue,
                  icon: Icons.edit,
                  onTap: () {}
              ),
              IconSlideAction(
                color: kBackgroundGrey[3],
                foregroundColor: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    model.deleteQuantity();
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
                      Text("27.000 VND", style: TextStyle(
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
                      Text("10.000 VND", style: TextStyle()),
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
                      Text("50.000 VND", style: TextStyle(fontWeight: FontWeight.bold)),
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
                    Text("37.000 VND", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
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

  Widget selectQuantity(){
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, QuantityViewModel model) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.do_not_disturb_on, size: 20, color: model.minusColor,),
              onPressed: (){
                model.minusQuantity();
              },
            ),
            Text(model.count.toString()),
            IconButton(
              icon: Icon(Icons.add_circle, size: 20, color: model.addColor,),
              onPressed: (){
                model.addQuantity();
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
