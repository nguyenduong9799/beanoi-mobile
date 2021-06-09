import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Accessories/CacheImage.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class StorePromotion extends StatefulWidget {
  final ProductDTO dto;
  StorePromotion({this.dto});
  BaseModel model;

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
    return Material(
      elevation: 10,
      color: kPrimary,
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
      child: ScopedModel(
        model: Get.find<RootViewModel>(),
        child: ScopedModelDescendant<RootViewModel>(
          builder: (context, child, model) {
            return InkWell(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              onTap: () async {
                await model.openProductDetail(widget.dto);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: Get.width * 0.25,
                            height: Get.width * 0.25,
                            child: CacheImage(
                              imageUrl: widget.dto.imageURL ?? defaultImage,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        SingleChildScrollView(
                          child: Container(
                            width: Get.width * 0.35,
                            height: Get.width * 0.25,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.dto.name,
                                  style: Get.theme.textTheme.headline1
                                      .copyWith(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  widget.dto.supplierName,
                                  style: Get.theme.textTheme.headline4
                                      .copyWith(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Container(
                        width: Get.width * 0.25,
                        height: Get.width * 0.25,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: "${widget.dto.price} ",
                                  style: Get.theme.textTheme.headline4
                                      .copyWith(color: Colors.white),
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.bottom,
                                      child: Image(
                                        image: AssetImage(
                                            "assets/images/icons/bean_coin.png"),
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  ]),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              "Đổi ngay",
                              style: Get.theme.textTheme.headline4
                                  .copyWith(color: kBean),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
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
