import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Accessories/product_search.dart';
import 'package:unidelivery_mobile/Accessories/touchopacity.dart';
import 'package:unidelivery_mobile/Constraints/constraints.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/View/params_screen.dart';
import 'package:unidelivery_mobile/ViewModel/product_filter_viewModel.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

const SUGGEST_TAG = ["Mì", "Bánh", "Nước uống", "Nước ngọt", "Tả cho bé"];

class _SearchScreenState extends State<SearchScreen> {
  ProductFilterViewModel prodFilterModel;
  Timer _debounce;
  TextEditingController _controller;

  String currentQuery;
  bool showSuggestTag = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    prodFilterModel = Get.find<ProductFilterViewModel>();
    _controller.addListener(() {
      _onSearchChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  _onSearchChanged(String query) {
    print("Change $query");
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        setState(() {
          showSuggestTag = false;
        });
        if (query != currentQuery) {
          setState(() {
            currentQuery = query;
          });
          prodFilterModel.setParam({"product-name": query});
          prodFilterModel.getProductsWithFilter();
        }
      } else {
        setState(() {
          currentQuery = null;
          showSuggestTag = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Color(0xFFF5F5F5),
        title: buildSearch(),
      ),
      body: ScopedModel(
        model: prodFilterModel,
        child: Container(
          child: Column(
            children: [
              !showSuggestTag ? buildFilters() : SizedBox(),
              _buildListProduct(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildFilters() {
    return Container(
      color: Colors.white,
      width: Get.width,
      height: 72,
      padding: EdgeInsets.all(16),
      child: Center(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Center(
              child: Text(
                "Lọc: ",
                style: kDescriptionTextStyle.copyWith(fontSize: 14),
              ),
            ),
            SizedBox(width: 8),
            TouchOpacity(
              onTap: () async {
                // NAVIGATE TO FILTER
                await Navigator.push(
                  context,
                  ScaleRoute(page: ParamScreen()),
                );
                // TODO: CALL FETCH PARAM
                prodFilterModel.getProductsWithFilter();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color(0xFFF5F5F5)),
                ),
                child: ScopedModelDescendant<ProductFilterViewModel>(
                  builder: (context, child, model) {
                    final numberFilter = model.categoryParams.length;
                    final hasFilter = numberFilter > 0;
                    return Center(
                      child: Row(
                        children: [
                          Text(
                            "Loại sản phẩm ${hasFilter ? "($numberFilter)" : ''}",
                            style: hasFilter
                                ? kSubtitleTextStyle
                                : kDescriptionTextStyle,
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: kDescriptionTextColor,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextField buildSearch() {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: "Tìm món ăn, đồ uống ...",
        hintStyle: kDescriptionTextStyle.copyWith(fontSize: 14),
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: 16),
        suffixIcon: IconButton(
          onPressed: () {
            _controller.clear();
          },
          icon: Icon(
            MaterialIcons.close,
            color: Colors.grey,
          ),
        ),
      ),
      autofocus: true,
    );
  }

  Widget _buildListProduct() {
    return Container(
      child: ScopedModelDescendant<ProductFilterViewModel>(
        builder: (context, child, model) {
          if (model.status == ViewStatus.Loading) {
            return _buildLoading();
          }

          if (model.status == ViewStatus.Error) {
            return Flexible(
              child: Center(
                child: Text(model.msg ?? "Có gì đó sai sai",
                    style: kTitleTextStyle.copyWith(
                      color: Colors.red,
                    )),
              ),
            );
          }

          if (showSuggestTag) {
            return buildSuggestTagList();
          }

          return Flexible(
            child: Container(
              padding: EdgeInsets.only(top: 8),
              height: Get.height,
              color: Colors.white,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
                    child: Text(
                      "Tìm thấy ${model.listProducts.length} sản phẩm",
                      style: kDescriptionTextStyle,
                    ),
                  ),
                  ...model.listProducts.map((product) {
                    return ProductSearchItem(
                      product: product,
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Bạn đã xem hết rồi đấy 🐱‍👓",
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSuggestTagList() {
    return Flexible(
      child: Container(
        width: Get.width,
        color: Colors.white,
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Bạn muốn tìm gì 🤔",
                style: kDescriptionTextStyle.copyWith(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: SUGGEST_TAG
                      .map((tagName) => buildSuggestTag(tagName))
                      .toList()),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSuggestTag(String tagName) {
    return TouchOpacity(
      onTap: () {
        setState(() {
          _controller.text = tagName;
        });
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          tagName,
          style: kDescriptionTextStyle.copyWith(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Flexible(
      child: Container(
        color: Colors.white,
        child: ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) => Container(
            height: 140,
            width: Get.width,
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                    aspectRatio: 1,
                    child: ShimmerBlock(width: 140, height: 140)),
                SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBlock(width: 120, height: 20),
                      SizedBox(height: 4),
                      ShimmerBlock(width: 175, height: 20),
                      SizedBox(height: 8),
                      Flexible(child: Container()),
                      Row(
                        children: [
                          ShimmerBlock(width: 50, height: 20, borderRadius: 16),
                          SizedBox(width: 8),
                          ShimmerBlock(width: 50, height: 20, borderRadius: 16),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          separatorBuilder: (context, index) => SizedBox(height: 16),
        ),
      ),
    );
  }
}
