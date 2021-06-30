import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Accessories/touchopacity.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/CategoryDTO.dart';
import 'package:unidelivery_mobile/ViewModel/category_viewModel.dart';

class HomeCategorySection extends StatefulWidget {
  const HomeCategorySection({
    Key key,
  }) : super(key: key);

  @override
  _HomeCategorySectionState createState() => _HomeCategorySectionState();
}

class _HomeCategorySectionState extends State<HomeCategorySection> {
  CategoryViewModel _categoryViewModel;
  @override
  void initState() {
    super.initState();
    _categoryViewModel = CategoryViewModel();
    _categoryViewModel.getCategories(params: {"type": 1, "showOnHome": true});
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _categoryViewModel,
      child: ScopedModelDescendant<CategoryViewModel>(
        builder: (BuildContext context, Widget child, CategoryViewModel model) {
          var categories =
              model.categories?.where((element) => element.showOnHome);
          if (model.status == ViewStatus.Loading) {
            return _buildLoading();
          }
          if (categories == null || categories.length == 0) {
            return Text("Khong co cate");
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
                padding: EdgeInsets.all(8),
                width: Get.width,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 8,
                  children: categories
                      .map((category) => buildCategoryItem(category))
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildCategoryItem(CategoryDTO category) {
    return Material(
      color: Colors.white,
      child: TouchOpacity(
        onTap: () {
          print('Click category');
          Get.toNamed(RouteHandler.PRODUCT_FILTER_LIST, arguments: category);
        },
        child: Container(
          width: Get.width / 4 - 20,
          // height: Get.width / 4 - 30 + 35,
          child: Column(
            children: [
              Container(
                width: Get.width / 4 - 30,
                height: Get.width / 4 - 30,
                child: CacheImage(
                  imageUrl: category.imgURL,
                ),
              ),
              Text(
                category.categoryName ?? "",
                style: kTitleTextStyle.copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(0xff333333),
        ),
      ),
      width: Get.width,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: List.filled(
          8,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShimmerBlock(
              width: Get.width / 4 - 30,
              height: Get.width / 4 - 30,
              borderRadius: 8,
            ),
          ),
        ),
      ),
    );
  }
}
