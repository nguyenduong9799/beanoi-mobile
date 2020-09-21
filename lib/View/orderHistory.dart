import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/OrderDTO.dart';
import 'package:unidelivery_mobile/ViewModel/orderHistory_viewModel.dart';
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
                child: ToggleButtons(
                  renderBorder: false,
                  onPressed: (int index) async {
                    setState(() {
                      _selections = _selections.map((e) => false).toList();
                      _selections[index] = true;
                    });
                    await orderHandler();
                  },
                  isSelected: _selections,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        "Đang giao",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        "Hoàn thành",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
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
                  : _buildOrderItem2(orders[index]);
            }),
      );
    });
  }

  Widget _buildOrderItem2(OrderDTO order) {
    return ListTile(
      onTap: () {
        print("Tap ${order.id}");
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
}
