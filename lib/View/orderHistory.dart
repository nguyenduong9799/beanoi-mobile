import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';
import 'package:unidelivery_mobile/acessories/dash_border.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/utils/enum.dart';

class OrderHistoryScreen extends StatefulWidget {
  OrderHistoryScreen({Key key}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<bool> _selections = [true, false];

  OrderHistoryViewModel model = OrderHistoryViewModel();

  @override
  void initState() {
    super.initState();
    orderHandler();
  }

  Future<void> orderHandler() async {
    OrderFilter filter =
        _selections[0] ? OrderFilter.ORDERING : OrderFilter.DONE;
    try {
      await model.getOrders(filter);
    } catch (e) {} finally {}
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OrderHistoryViewModel>(
      model: model,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Lịch sử",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
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
                      setState(() {
                        _selections = _selections.map((e) => false).toList();
                        _selections[index] = true;
                      });
                      await orderHandler();
                    },
                    borderRadius: BorderRadius.circular(24),
                    isSelected: _selections,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          "Đang giao",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text(
                          "Hoàn thành",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                child: _buildOrders(),
                color: Color(0xffefefef),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrders() {
    return ScopedModelDescendant<OrderHistoryViewModel>(
        builder: (context, child, model) {
      final status = model.status;
      final orders = model.orders;
      if (status == Status.Loading)
        return Center(
          child: Container(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              backgroundColor: kPrimary,
            ),
          ),
        );
      else if (status == Status.Empty)
        return Expanded(
          child: SvgPicture.asset(
            'assets/images/order_history.svg',
            semanticsLabel: 'Acme Logo',
            fit: BoxFit.cover,
          ),
        );

      return Expanded(
        child: ListView(
          padding: EdgeInsets.all(8),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 16),
              child: Text(
                "12/02/2020",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ...orders.map((e) => _buildOrderItem(e, context)).toList(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "Bạn đã xem hết rồi đây :)",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            // Container(
            //   height: 300,
            //   child: ListView.separated(
            //       padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            //       itemCount: orders?.length + 1,
            //       separatorBuilder: (context, index) =>
            //           Divider(color: kPrimary, height: 16),
            //       itemBuilder: (context, index) {
            //         return index == orders?.length
            //             ? Padding(
            //                 padding: const EdgeInsets.all(8.0),
            //                 child: Center(
            //                   child: Text(
            //                     "Bạn đã xem hết rồi đây :)",
            //                     style: TextStyle(color: Colors.grey),
            //                   ),
            //                 ),
            //               )
            //             : _buildOrderItem(orders[index], context);
            //       }),
            // ),
          ],
        ),
      );
    });
  }

  Widget _buildOrderItem(OrderDTO order, BuildContext context) {
    return Container(
      // height: 80,
      margin: EdgeInsets.fromLTRB(8, 0, 8, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          // side: BorderSide(color: Colors.red),
        ),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                _settingModalBottomSheet(context);
              },
              contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "1 món",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "FPT University",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${order.total} đ",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: kPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Text("Chi tiết", style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        builder: (BuildContext bc) {
          return OrderDetailBottomSheet();
        });
  }
}

class OrderDetailBottomSheet extends StatelessWidget {
  const OrderDetailBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        // color: Colors.grey,
      ),
      height: 450,
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Text(
                'Menu',
                style: TextStyle(color: Colors.black45),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Divider(),
                ),
              ),
              Text(
                '22/02/2020',
                style: TextStyle(color: Colors.black45),
              ),
            ],
          ),
          SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemBuilder: (context, index) => Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "${index + 1}x",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                            child: Text(
                          "Món ${index + 1}",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )),
                        Text("${(index + 1) * 15000}đ"),
                      ],
                    ),
                  ],
                ),
                separatorBuilder: (context, index) => Divider(),
                itemCount: 8,
              ),
            ),
          ),
          layoutSubtotal(context),
        ],
      ),
    );
  }

  Widget layoutSubtotal(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8),
      // margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: kBackgroundGrey[0],
        borderRadius: BorderRadius.circular(4),
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
                      Text("27.000 VND", style: TextStyle()),
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
                      Text("10.000 VND", style: TextStyle()),
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
                      Text("50.000 VND",
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
}
