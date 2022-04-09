import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OtherAmountWidget extends StatelessWidget {
  final otherAmount;
  const OtherAmountWidget({Key key, this.otherAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NumberFormat formatter = NumberFormat();
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${otherAmount.name}"),
          RichText(
            text: new TextSpan(
              text: '',
              children: <TextSpan>[
                new TextSpan(
                  text:
                      "${formatter.format(otherAmount.amount)} ${otherAmount.unit}",
                  style: otherAmount.amount >= 0
                      ? Get.theme.textTheme.headline4
                          .copyWith(color: Colors.grey)
                      : Get.theme.textTheme.headline4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
