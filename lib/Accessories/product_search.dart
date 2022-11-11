import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/CacheImage.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';
import 'package:unidelivery_mobile/Constraints/constraints.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/format_price.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/Widgets/beanoi_button.dart';

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
            height: 110,
            padding: EdgeInsets.all(12),
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
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: kSubtitleTextStyle.copyWith(fontSize: 18),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 6, 8, 4),
                                child: Text(
                                  formatPrice(product.price),
                                  style: BeanOiTheme.typography.subtitle2
                                      .copyWith(
                                          color:
                                              BeanOiTheme.palettes.primary400),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 6, 8, 4),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                    text: "+ ${product.bean}",
                                    style: BeanOiTheme.typography.subtitle2
                                        .copyWith(
                                            color: BeanOiTheme
                                                .palettes.secondary1000),
                                  ),
                                  WidgetSpan(
                                      child: Container(
                                    margin: EdgeInsets.only(left: 5, bottom: 2),
                                    child: ImageIcon(
                                      AssetImage(
                                          "assets/images/icons/bean_coin.png"),
                                      color: Colors.orange,
                                    ),
                                    width: 15,
                                    height: 15,
                                  ))
                                ])),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
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
