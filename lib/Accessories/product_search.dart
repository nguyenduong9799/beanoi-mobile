import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/CacheImage.dart';
import 'package:unidelivery_mobile/Constraints/constraints.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/format_price.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class ProductSearchItem extends StatelessWidget {
  const ProductSearchItem({
    Key key,
    @required this.product,
    this.index = -1,
    this.showOnHome = false,
  }) : super(key: key);

  final ProductDTO product;
  final int index;
  final bool showOnHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: index == 0 ? 16 : 0),
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            RootViewModel root = Get.find<RootViewModel>();
            root.openProductDetail(product);
          },
          child: Container(
            height: 140,
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    // color: Colors.grey,
                  ),
                  // width: 110,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CacheImage(imageUrl: product.imageURL),
                  ),
                ),
                SizedBox(width: 16),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: kSubtitleTextStyle.copyWith(fontSize: 18),
                      ),
                      SizedBox(height: 4),
                      Container(
                        // color: Colors.amber,
                        child: Text(
                          product.description ?? '',
                          style: kDescriptionTextStyle,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                              decoration: BoxDecoration(
                                color: kPrimary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                formatPrice(product.price),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                              decoration: BoxDecoration(
                                color: kBestSellerColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                "+ ${product.bean} bean",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
