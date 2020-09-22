import 'package:flutter/material.dart';
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
                width: double.infinity,
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
            _buildOrders(),
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
        return CircularProgressIndicator();
      else if (status == Status.Empty)
        return Image.asset('assets/images/order_history.svg');

      return Expanded(
        child: ListView.separated(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            itemCount: orders?.length + 1,
            separatorBuilder: (context, index) =>
                Divider(color: kPrimary, height: 16),
            itemBuilder: (context, index) {
              return index == orders?.length
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "Bạn đã xem hết rồi đây :)",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : _buildOrderItem(orders[index], context);
            }),
      );
    });
  }

  Widget _buildOrderItem(OrderDTO order, BuildContext context) {
    return ListTile(
      onTap: () {
        _settingModalBottomSheet(context);
      },
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
      trailing: Text(
        "${order.total} đ",
        textAlign: TextAlign.right,
        style: TextStyle(
          color: kPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
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
                itemBuilder: (context, index) => Row(
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
