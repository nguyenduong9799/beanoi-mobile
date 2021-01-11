import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Bussiness/BussinessHandler.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/constraints.dart';

class StorePromotion extends StatefulWidget {
  final ProductDTO dto;
  StorePromotion(this.dto);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StorePromotionState();
  }
}

class _StorePromotionState extends State<StorePromotion> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: kBackgroundGrey[0],
      padding: EdgeInsets.all(8.0),
      child: Material(
        elevation: 20,
        color: kBackgroundGrey[0],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: Get.height / 5,
                  child: ClipPath(
                    clipper: PrimaryCippler(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Color(0xfff68741),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Text(
                              "Khuyến Mãi",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decorationThickness: 0.5),
                            )),
                            Row(
                              children: [
                                Text(
                                  BussinessHandler.beanReward(widget.dto.price)
                                      .toString(),
                                  style: TextStyle(color: kBean),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: kBean)),
                                    child: Center(
                                        child: Text(
                                      "Bean",
                                      style: TextStyle(color: kBean),
                                    ))),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(widget.dto.name,
                        style: TextStyle(color: kSecondary, fontWeight: FontWeight.bold, fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )),
                      OutlineButton(
                        onPressed: () {
                        },
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.orange),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Text(
                          "Đổi quà",
                          style: TextStyle(color: Colors.orange),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryCippler extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    path.lineTo(0, size.height * 0.7);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height * 0.7);

    var secondControlPoint = new Offset(3 * size.width / 4, size.height * 0.45);
    var secondEndPoint = new Offset(size.width, size.height * 0.7);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return oldClipper != this;
  }
}