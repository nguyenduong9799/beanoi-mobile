import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${otherAmount.name}", style: TextStyle()),
          RichText(
            text: new TextSpan(
              text: otherAmount.amount < 0 ? '🌟' : '',
              children: <TextSpan>[
                new TextSpan(
                  text:
                      "${formatter.format(otherAmount.amount)} ${otherAmount.unit}",
                  style: new TextStyle(
                    color: otherAmount.amount < 0 ? Colors.orange : Colors.grey,
                    decoration: otherAmount.amount < 0
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                new TextSpan(
                  text: otherAmount.amount < 0 ? '🌟' : '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
