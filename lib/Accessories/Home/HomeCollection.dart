import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/touchopacity.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/CollectionDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/ViewModel/collection_viewmodel.dart';
import 'package:unidelivery_mobile/ViewModel/home_viewModel.dart';

class HomeCollection extends StatelessWidget {
  const HomeCollection({
    Key key,
  }) : super(key: key);
  final double kWitdthItem = 125;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<HomeViewModel>(
      model: Get.find<HomeViewModel>(),
      child: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, HomeViewModel model) {
          var collections = model.homeCollections;
          if (model.status == ViewStatus.Loading ||
              collections == null ||
              collections?.length == 0) {
            return SizedBox();
          }
          return Column(
            children: collections
                .where((element) => element.products != null && element.products?.length != 0)
                .map((c) => buildHomeCollection(c))
                .toList(),
          );
        },
      ),
    );
  }

  Column buildHomeCollection(CollectionDTO collection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text(
          collection.name,
          style: kTitleTextStyle,
        ),
        SizedBox(height: 4),
        Text(
          collection.description ?? "",
          style: Get.theme.textTheme.headline4
              .copyWith(color: kDescriptionTextColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8),
        Container(
          width: Get.width,
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 16),
            itemBuilder: (context, index) {
              return Material(
                color: Colors.white,
                child: TouchOpacity(
                  onTap: () {
                    print('View Detail item');
                  },
                  child: buildProductInCollection(collection.products[index]),
                ),
              );
            },
            itemCount: collection.products?.length,
          ),
        )
      ],
    );
  }

  Container buildProductInCollection(ProductDTO product) {
    return Container(
      width: kWitdthItem,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(
            fit: BoxFit.fitWidth,
            width: kWitdthItem,
            height: kWitdthItem,
            imageUrl: product.imageURL,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              enabled: true,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
              ),
            ),
            errorWidget: (context, url, error) => Icon(
              MaterialIcons.broken_image,
              color: kPrimary.withOpacity(0.5),
            ),
          ),
          Text(
            NumberFormat.simpleCurrency(locale: "vi").format(product.price),
            style: Get.theme.textTheme.headline5.copyWith(
              color: kBestSellerColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            product.name,
            style: kTitleTextStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Material(
            child: InkWell(
              onTap: () {
                print("ADD TO CART");
              },
              child: Container(
                width: kWitdthItem,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kPrimary)),
                child: Text(
                  "Chọn",
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
