import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/route_constraint.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      width: Get.width,
      height: 200,
      decoration: BoxDecoration(
        color: kPrimary,
        // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(54),bottomRight: Radius.circular(24)),
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              kPrimary,
              Color(0xff3BB78F),
            ]),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _location(),
                ),
                SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey[300],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                          child: Image.asset(
                        'assets/images/history.png',
                        width: 20,
                      )),
                      onTap: () {
                        Get.toNamed(RouteHandler.ORDER_HISTORY);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InkWell _location() {
    return InkWell(
      onTap: () async {
        // await root.processChangeLocation();
        print('Tap');
      },
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: Colors.red[400],
            size: 30,
          ),
          SizedBox(
            width: 4,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "KHU VỰC",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                child: Row(
                  children: [
                    Text(
                      'Unibean',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
