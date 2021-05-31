import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/CategoryDTO.dart';
import 'package:unidelivery_mobile/ViewModel/home_viewModel.dart';

class HomeCategorySection extends StatelessWidget {
  const HomeCategorySection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<HomeViewModel>(
      builder: (BuildContext context, Widget child, HomeViewModel model) {
        var categories = model.categories;
        if (categories == null ||
            categories.length == 0 ||
            model.status == ViewStatus.Completed) {
          return SizedBox();
        }
        return Column(
          children: [
            Container(
              child: Image(
                image: AssetImage("assets/images/bean_oi_category.png"),
                width: 95,
                height: 25,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(0xff333333),
                ),
              ),
              width: Get.width,
              height: 180,
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                crossAxisSpacing: 10,
                crossAxisCount: 4,
                children:
                    categories.map((category) => buildCategoryItem(category)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildCategoryItem(CategoryDTO category) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          print('Click category');
          Get.toNamed(RouteHandler.PRODUCT_FILTER_LIST,
              arguments: {"category": category.id});
        },
        child: Container(
          width: 45,
          height: 60,
          child: Column(
            children: [
              Container(
                width: 45,
                height: 45,
                child: CacheImage(
                  imageUrl: category.imgURL,
                ),
              ),
              Text(
                category.categoryName,
                style: kTitleTextStyle.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
