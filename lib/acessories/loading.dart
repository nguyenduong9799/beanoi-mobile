import 'package:flutter/material.dart';
import 'package:unidelivery_mobile/constraints.dart';

class LoadingBean extends StatelessWidget {
  const LoadingBean({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image(
            width: 72,
            height: 72,
            image: AssetImage("assets/images/loading.gif"),
          ),
        ],
      ),
    );
  }
}
