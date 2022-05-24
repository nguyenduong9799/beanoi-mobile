import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/CacheImage.dart';
import 'package:unidelivery_mobile/Accessories/shimmer_block.dart';
import 'package:unidelivery_mobile/Constraints/constraints.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/format_price.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/ViewModel/root_viewModel.dart';

class UpSellCollection extends StatefulWidget {
  const UpSellCollection({
    Key key,
  }) : super(key: key);
  @override
  _UpSellCollectionState createState() => _UpSellCollectionState();
}

class _UpSellCollectionState extends State<UpSellCollection> {
  ProductDetailViewModel productDetailViewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OrderViewModel>(
      model: Get.find<OrderViewModel>(),
      child: ScopedModelDescendant<OrderViewModel>(
        builder: (BuildContext context, Widget child, OrderViewModel model) {
          var collections = model.upSellCollections;
          if (collections == null || collections?.length == 0)
            return SizedBox();
          if (model.loadingUpsell == true ||
              collections == null ||
              collections?.length == 0) {
            return Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Đợi tí nha",
                        style: kTitleTextStyle.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: Get.width,
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return Container(
                          height: 60,
                          width: 170,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: kBackgroundGrey[2],
                                spreadRadius: 4,
                                blurRadius: 4,
                                offset:
                                    Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  // color: Colors.grey,
                                ),
                                // width: 110,
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: ShimmerBlock(),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: ShimmerBlock(),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: 2,
                    ),
                  )
                ],
              ),
            );
          }

          return Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      collections[0].name,
                      style: kTitleTextStyle.copyWith(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Container(
                  width: Get.width,
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      var product = collections[0].products[index];
                      return Material(
                        color: Colors.white,
                        child: buildProductInCollection(product, index),
                      );
                    },
                    itemCount: collections[0].products?.length,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Container buildProductInCollection(ProductDTO product, index) {
    return Container(
      height: 60,
      width: 180,
      padding: EdgeInsets.fromLTRB(4, 4, 0, 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            await Get.find<RootViewModel>().addUpSellProductToCart(product,
                fetchDetail: true, showOnHome: true);
            await Get.find<OrderViewModel>().prepareOrder();
          },
          child: Container(
            height: 60,
            width: 170,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: kBackgroundGrey[2],
                  spreadRadius: 4,
                  blurRadius: 4,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
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
                SizedBox(width: 8),
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
                          maxLines: 2,
                          style: kSubtitleTextStyle.copyWith(fontSize: 12),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                // padding: EdgeInsets.fromLTRB(4, 4, 8, 4),
                                // decoration: BoxDecoration(
                                //   color: kPrimary,
                                //   borderRadius: BorderRadius.circular(16),
                                // ),
                                child: Text(
                                  formatPrice(product.price),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                ),
                              ),
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
