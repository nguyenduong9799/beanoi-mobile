import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Accessories/product_search.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/ViewModel/product_filter_viewModel.dart';

class ProductsFilterPage extends StatefulWidget {
  final params;
  ProductsFilterPage({Key key, this.params}) : super(key: key);

  @override
  _ProductsFilterPageState createState() => _ProductsFilterPageState();
}

class _ProductsFilterPageState extends State<ProductsFilterPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  ProductFilterViewModel prodFilterModel;

  Future<void> _refreshHandler() async {
    await prodFilterModel.getProductsWithFilter();
  }

  @override
  void initState() {
    super.initState();
    prodFilterModel = ProductFilterViewModel();
    prodFilterModel.setParam(this.widget.params);
    prodFilterModel.getProductsWithFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "Danh sách sản phẩm",
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshHandler,
        child: Column(
          children: [
            // _buildFilter(),
            _buildListProduct(),
          ],
        ),
      ),
    );
  }

  Widget _buildListProduct() {
    return ScopedModel(
      model: prodFilterModel,
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

          return Flexible(
            child: ListView.separated(
              itemCount: model.listProducts.length + 1,
              separatorBuilder: (context, index) => SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index == model.listProducts.length) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Bạn đã xem hết rồi đấy 🐱‍👓",
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                final product = model.listProducts.elementAt(index);
                return ProductSearchItem(product: product, index: index);
              },
            ),
          );
        },
      ),
    );
  }

  Container _buildFilter() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
      color: Colors.white,
      child: Text("Filter controler"),
    );
  }

  Widget _buildLoading() {
    return Flexible(
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
                  aspectRatio: 1, child: ShimmerBlock(width: 140, height: 140)),
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
    );
  }
}
