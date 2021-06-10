import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/touchopacity.dart';
import 'package:unidelivery_mobile/Constraints/constraints.dart';
import 'package:unidelivery_mobile/ViewModel/product_filter_viewModel.dart';

class ParamScreen extends StatefulWidget {
  ParamScreen({Key key}) : super(key: key);

  @override
  _ParamScreenState createState() => _ParamScreenState();
}

class _ParamScreenState extends State<ParamScreen> {
  List<String> categories = [];
  bool loadingParams = true;
  List selectedCategories;
  ProductFilterViewModel model = Get.find<ProductFilterViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCategories = List.from(model.params['category-id'] ?? []);
    fetchParam();
  }

  fetchParam() async {
    setState(() {
      loadingParams = true;
    });
    await model.getCategories();
    setState(() {
      loadingParams = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text("Bộ lọc"),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context, {});
            }),
      ),
      body: ScopedModel(
        model: model,
        child: loadingParams
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.white,
                width: Get.width,
                height: Get.height,
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Flexible(child: buildCategories()),
                    buildBtns(),
                  ],
                ),
              ),
      ),
    );
  }

  Container buildBtns() {
    return Container(
      padding: EdgeInsets.all(8),
      width: Get.width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TouchOpacity(
              onTap: () {
                model.setParam({'category-id': []});
                Get.back();
              },
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Bỏ chọn",
                    style: kTitleTextStyle.copyWith(color: kPrimary),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: TouchOpacity(
              onTap: () {
                model.setParam({'category-id': selectedCategories});
                Get.back();
              },
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Áp dụng",
                    style: kTitleTextStyle.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategories() {
    return ScopedModelDescendant<ProductFilterViewModel>(
      builder: (context, child, model) {
        final categoriesParams = model.categories;

        print("Change");
        return Container(
          width: Get.width,
          child: ListView(
            children: [
              Text(
                "Loại sản phẩm",
                style: kDescriptionTextStyle,
              ),
              ...categoriesParams
                  .map(
                    (cate) => CheckboxListTile(
                      value: selectedCategories.contains(cate.id),
                      onChanged: (value) {
                        if (selectedCategories.contains(cate.id)) {
                          setState(() {
                            selectedCategories.remove(cate.id);
                          });
                        } else {
                          setState(() {
                            selectedCategories.add(cate.id);
                          });
                        }
                      },
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        cate.categoryName,
                        style: kTitleTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }
}
