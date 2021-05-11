import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';

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
              text: '',
              children: <TextSpan>[
                new TextSpan(
                  text:
                      "${formatter.format(otherAmount.amount)} ${otherAmount.unit}",
                  style: otherAmount.amount >= 0
                      ? new TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.none,
                        )
                      : kTitleTextStyle.copyWith(
                          fontSize: 14,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
