import 'package:flutter/material.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderDetailScreen({Key key}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Order Detail"),
    );
  }
}
