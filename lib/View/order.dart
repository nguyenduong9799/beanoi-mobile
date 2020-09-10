
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/ViewModel/quantity_viewModel.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/acessories/dialog.dart';
class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: DefaultAppBar(title: "Thanh toán",),
      bottomNavigationBar: bottomBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: layoutOrder()),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: layoutAddress()),
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
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(child: Text("Đơn hàng của bạn", style: TextStyle(color: Hexcolor("ffc500"), fontSize: 20, fontWeight: FontWeight.bold),)),
          ),
          layoutStore("Bà Mười", [
            productCard("https://beptruong.edu.vn/wp-content/uploads/2018/06/cach-uop-thit-nuong-com-tam.jpg", "Cơm Tấm Trân Châu Đường Đen", "Size M", "20.000 VND"),
          ]),
          Divider(
            color: Hexcolor('ffc500'),
            thickness: 2,
          ),
          layoutStore("Hẻm 447", [
            productCard("https://www.huongnghiepaau.com/wp-content/uploads/2019/01/che-buoi-an-giang.jpg", "Chè Bưởi", "Size M", "7.000 VND"),
          ])
        ],
      ),
    );
  }
  
  Widget layoutStore(String store, List<Widget> card){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(store, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
          ),
          ...card
        ],
      ),
    );
  }

  Widget productCard(String imageUrl, String name, String size, String price){
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
      child: Card(
        elevation: 2.0,
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.fill,
                    width: MediaQuery.of(context).size.width * 0.33,
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.21,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyle(fontSize: 14)),
                        SizedBox(height: 10,),
                        Text(price, style: TextStyle(fontSize: 14)),
                        SizedBox(height: 5,),
                        Text(size, style: TextStyle(color: Colors.grey, fontSize: 13),)
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                  ),
                  selectQuantity()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget layoutAddress(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(5))
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Địa chỉ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                Icon(Icons.edit, color: Colors.grey)
              ],),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text("FPT University"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text("Lô E2a-7, Đường D1, Khu Công Nghệ Cao, Long Thạnh Mỹ, Quận 9, Thành phố Hồ Chí Minh"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Text("Nhớ rước tớ vào lúc 11:00 nhé honey", style: TextStyle(color: Colors.pinkAccent),),
                SizedBox(width: 5,),
                Icon(Icons.favorite, color: Colors.pinkAccent,)
              ],),
          )
        ],
      ),
    );
  }

  Widget layoutSubtotal(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tạm tính", style: TextStyle(fontWeight: FontWeight.bold),),
                Text("27.000 VND", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
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
                Text("Shipping",  style: TextStyle(fontWeight: FontWeight.bold)),
                Text("10.000 VND", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bottomBar(){
      return  Container(
        height: 50,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Tổng cộng", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),),
                  Text("37.000 VND", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                ],
            ),
            FlatButton(
              onPressed: () async {
                showLoadingDialog();
                // pr.hide();
                // showStateDialog();
              },
              padding: EdgeInsets.only(left: 8.0, right:  8.0),
              textColor: Colors.white,
              color: Hexcolor("ffc500"),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Text("Đặt hàng"),
            )
          ],
        ),
      );
  }

  Widget selectQuantity(){
    return ScopedModel(
      model: new QuantityViewModel(),
      child: ScopedModelDescendant(
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
      ),
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
                  textDirection: TextDirection.ltr,
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
                color: Hexcolor("ffc500"),
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
