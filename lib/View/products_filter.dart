import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/ViewModel/product_filter_viewModel.dart';
import 'package:unidelivery_mobile/ViewModel/root_viewModel.dart';

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
    await prodFilterModel.getProductsWithFilter(params: this.widget.params);
  }

  @override
  void initState() {
    super.initState();
    prodFilterModel = ProductFilterViewModel();
    prodFilterModel.getProductsWithFilter(params: this.widget.params);
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
                                child: CacheImage(
                                  imageUrl: product.imageURL ??
                                      "https://firebasestorage.googleapis.com/v0/b/unidelivery-fad6f.appspot.com/o/00014100085607A.png?alt=media&token=40439c48-411b-41c9-a910-6c2f429509f8",
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product.name,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: kSubtitleTextSyule.copyWith(
                                        fontSize: 18),
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                    // color: Colors.amber,
                                    child: Text(
                                      product.description ?? '',
                                      style: kDescriptionTextSyle,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Flexible(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(8, 4, 8, 4),
                                          decoration: BoxDecoration(
                                            color: kPrimary,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            "${product.price} đ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(8, 4, 8, 4),
                                          decoration: BoxDecoration(
                                            color: kBestSellerColor,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            "+ ${product.bean} bean",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
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
