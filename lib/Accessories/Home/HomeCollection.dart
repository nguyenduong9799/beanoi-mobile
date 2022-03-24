import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/CacheImage.dart';
import 'package:unidelivery_mobile/Accessories/touchopacity.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/CollectionDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/Utils/format_price.dart';
import 'package:unidelivery_mobile/ViewModel/home_viewModel.dart';
import 'package:unidelivery_mobile/ViewModel/root_viewModel.dart';

class HomeCollection extends StatefulWidget {
  const HomeCollection({
    Key key,
  }) : super(key: key);
  @override
  _HomeCollectionState createState() => _HomeCollectionState();
}

class _HomeCollectionState extends State<HomeCollection> {
  HomeViewModel _homeCollectionViewModel;

  @override
  void initState() {
    super.initState();
    _homeCollectionViewModel = HomeViewModel();
    _homeCollectionViewModel.getCollections();
  }

  final double kWitdthItem = 125;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<HomeViewModel>(
      model: Get.find<HomeViewModel>(),
      child: ScopedModelDescendant<HomeViewModel>(
        builder: (BuildContext context, Widget child, HomeViewModel model) {
          var collections = model.homeCollections;
          if (model.status == ViewStatus.Loading ||
              collections == null ||
              collections?.length == 0) {
            return SizedBox();
          }
          return Column(
            children: collections
                .where((element) =>
                    element.products != null && element.products?.length != 0)
                .map(
                  (c) => Container(
                      margin: EdgeInsets.only(bottom: 16),
                      color: Colors.white,
                      padding: EdgeInsets.all(8),
                      child: buildHomeCollection(c)),
                )
                .toList(),
          );
        },
      ),
    );
  }

  Widget buildHomeCollection(CollectionDTO collection) {
    return TouchOpacity(
      onTap: () {
        Get.toNamed(RouteHandler.PRODUCT_FILTER_LIST,
            arguments: {"collection-id": collection.id});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collection.name,
                    style: kTitleTextStyle.copyWith(fontSize: 20),
                  ),
                  Text(
                    collection.description ?? "",
                    style: Get.theme.textTheme.headline4
                        .copyWith(color: kDescriptionTextColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Text(
                'Xem tất cả',
                style: TextStyle(color: kPrimary),
              )
            ],
          ),
          SizedBox(height: 16),
          Container(
            width: Get.width,
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(width: 16),
              itemBuilder: (context, index) {
                var product = collection.products[index];
                return Material(
                  color: Colors.white,
                  child: TouchOpacity(
                    onTap: () {
                      RootViewModel root = Get.find<RootViewModel>();
                      if (product.type == ProductType.MASTER_PRODUCT) {}
                      root.openProductDetail(product, fetchDetail: true);
                    },
                    child: buildProductInCollection(product),
                  ),
                );
              },
              itemCount: collection.products?.length,
            ),
          )
        ],
      ),
    );
  }

  Container buildProductInCollection(ProductDTO product) {
    return Container(
      width: kWitdthItem,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: kWitdthItem,
            height: kWitdthItem,
            child: CacheImage(
              imageUrl: product.imageURL,
            ),
          ),

          SizedBox(height: 8),
          Text(
            product.type != ProductType.MASTER_PRODUCT
                ? formatPrice(product.price)
                : "từ " + formatPrice(product.minPrice ?? product.price),
            // NumberFormat.simpleCurrency(locale: "vi").format(product.price),
            style: Get.theme.textTheme.headline5.copyWith(
              color: kBestSellerColor,
            ),
          ),
          SizedBox(height: 4),
          Container(
            height: 40,
            child: Text(
              product.name,
              style: kTitleTextStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 4),
          // Material(
          //   child: InkWell(
          //     onTap: () {
          //       print("ADD TO CART");
          //     },
          //     child: Container(
          //       width: kWitdthItem,
          //       padding: EdgeInsets.all(4),
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(16),
          //           border: Border.all(color: kPrimary)),
          //       child: Text(
          //         "Chọn",
          //         style: TextStyle(fontSize: 12),
          //         textAlign: TextAlign.center,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
