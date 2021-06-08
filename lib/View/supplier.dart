import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Accessories/touchopacity.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class SupplierScreen extends StatefulWidget {
  final SupplierDTO supplier;
  const SupplierScreen({Key key, @required this.supplier}) : super(key: key);

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  bool switcher = false;
  PageController _scrollController = new PageController();
  SupplierViewModel model;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    model = SupplierViewModel(widget.supplier.id);
    model.getProducts();
    model.getGifts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await model.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget?.user.uid);
    return ScopedModel(
      model: model,
      child: Scaffold(
        appBar: DefaultAppBar(
          title: widget.supplier.name,
        ),
        floatingActionButton: CartButton(),
        body: SafeArea(
          child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: Column(
              children: [
                tag(),
                Flexible(
                  child: buildProducts(),
                ),
                // Flexible(
                //   child: RefreshIndicator(
                //       key: _refreshIndicatorKey,
                //       onRefresh: _refresh,
                //       child: Column(
                //         children: [
                //           buildProducts(),
                //           loadMoreIcon(),
                //         ],
                //       )),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ScopedModelDescendant<SupplierViewModel> buildProducts() {
    return ScopedModelDescendant<SupplierViewModel>(
      builder: (context, child, model) {
        ViewStatus status = model.status;
        // status = ViewStatus.Loading;
        switch (status) {
          case ViewStatus.Error:
            return Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/global_error.png',
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Có gì đó sai sai..\n Vui lòng thử lại.",
                      // style: kTextPrimary,
                    ),
                  ],
                ),
              ),
            );
          case ViewStatus.Loading:
            return AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: LoadingBean(),
                ));
          case ViewStatus.Empty:
            return Container(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              color: Colors.black45,
              height: 400,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: AspectRatio(
                        aspectRatio: 1.5,
                        child: Image.asset(
                          'assets/images/empty-product.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Text(
                      "Aaa, các món ăn hiện tại đã hết rồi, bạn vui lòng quay lại sau nhé",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          case ViewStatus.Completed:
          case ViewStatus.LoadMore:
            return Container(
              child: ScrollablePositionedList.builder(
                itemCount: model.collections.length,
                itemScrollController: itemScrollController,
                itemPositionsListener: itemPositionsListener,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                        child:
                            homeBestSellerCollection(model.collections[index]));
                  }
                  if (model.collections
                          .every((element) => !element.isSelected) ||
                      model.collections[index].isSelected) {
                    return Container(
                        child: homeContent(model.collections[index]));
                  }
                  return SizedBox.shrink();
                },
              ),
            );
          default:
            return Text("Some thing wrong");
        }
      },
    );
  }

  Widget homeBestSellerCollection(CollectionDTO collection) {
    return ScopedModelDescendant<SupplierViewModel>(
        builder: (context, child, model) {
      List<Widget> listProducts = List();
      if (collection.products != null && collection.products.isNotEmpty) {
        collection.products.forEach((product) {
          double price = product.price;
          if (product.type == ProductType.MASTER_PRODUCT) {
            price = product.minPrice;
          }
          listProducts.add(TouchOpacity(
            onTap: () {
              RootViewModel root = Get.find<RootViewModel>();
              root.openProductDetail(product);
            },
            child: Container(
              width: Get.width / 2,
              padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]),
                    ),
                    width: Get.width / 2,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CacheImage(
                        imageUrl: product.imageURL ?? defaultImage,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.name,
                    style: kTitleTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      decorationThickness: 0.5,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                      product.type != ProductType.MASTER_PRODUCT
                          ? formatPrice(price)
                          : "từ " + formatPrice(price ?? product.price),
                      style: TextStyle(color: kPrimary))
                ],
              ),
            ),
          ));
        });
        return Container(
          margin: EdgeInsets.only(top: 8, bottom: 0),
          color: kBackgroundGrey[0],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Center(
                  child: Text(
                    collection.name,
                    style: TextStyle(
                        color: kPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: collection.name.length * 0.8 * 8,
                  child: Divider(
                    color: kPrimary,
                  ),
                ),
              ),
              Wrap(
                children: [...listProducts],
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      }
      return SizedBox.shrink();
    });
  }

  Widget homeContent(CollectionDTO collection) {
    return ScopedModelDescendant<SupplierViewModel>(
        builder: (context, child, model) {
      List<Widget> listProducts = List();
      if (collection.products != null && collection.products.isNotEmpty) {
        collection.products.forEach((product) {
          double price = product.price;
          if (product.type == ProductType.MASTER_PRODUCT) {
            price = product.minPrice;
          }
          listProducts.add(InkWell(
            onTap: () {
              RootViewModel root = Get.find<RootViewModel>();
              root.openProductDetail(product);
            },
            child: Container(
              width: Get.width,
              padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: kBackgroundGrey[3]))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: product.imageURL ?? defaultImage,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                Shimmer.fromColors(
                          baseColor: Colors.grey[300],
                          highlightColor: Colors.grey[100],
                          enabled: true,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            // height: 100,
                            color: Colors.grey,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(
                          MaterialIcons.broken_image,
                          color: kPrimary.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                flex: 2,
                                child: Text(
                                  product.name,
                                  style: kTitleTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    decorationThickness: 0.5,
                                    fontSize: 14,
                                  ),
                                )),
                            Flexible(
                                child: Text(
                                    product.type != ProductType.MASTER_PRODUCT
                                        ? formatPrice(price)
                                        : "từ " +
                                            formatPrice(price ?? product.price),
                                    style: TextStyle(color: kPrimary)))
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: Get.width * 0.6,
                                child: Text(
                                  product.description ?? "",
                                  maxLines: 1,
                                  style: kDescriptionTextSyle.copyWith(
                                    decorationThickness: 0.5,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w200,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )),
                            Flexible(
                              child: RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.orange),
                                      text:
                                          "+ " + product.bean.toString() + " ",
                                      children: [
                                    WidgetSpan(
                                        alignment: PlaceholderAlignment.bottom,
                                        child: Image(
                                          image: AssetImage(
                                              "assets/images/icons/bean_coin.png"),
                                          width: 16,
                                          height: 16,
                                        ))
                                  ])),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
        });
        return Container(
          margin: EdgeInsets.only(top: 8, bottom: 0),
          color: kBackgroundGrey[0],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Center(
                  child: Text(
                    collection.name,
                    style: TextStyle(
                        color: kPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: collection.name.length * 0.8 * 8,
                  child: Divider(
                    color: kPrimary,
                  ),
                ),
              ),
              ...listProducts
            ],
          ),
        );
      }
      return SizedBox.shrink();
    });
  }

  Widget loadMoreIcon() {
    return ScopedModelDescendant<SupplierViewModel>(
      builder: (context, child, model) {
        switch (model.status) {
          case ViewStatus.LoadMore:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          default:
            return SizedBox.shrink();
        }
      },
    );
  }

  Widget tag() {
    return ValueListenableBuilder<Iterable<ItemPosition>>(
      valueListenable: itemPositionsListener.itemPositions,
      builder: (context, positions, child) {
        int firstIndex = -1;
        int lastIndex = -1;
        if (positions.isNotEmpty) {
          firstIndex = positions
              .where((ItemPosition position) => position.itemTrailingEdge > 0)
              .reduce((ItemPosition min, ItemPosition position) =>
                  position.itemTrailingEdge < min.itemTrailingEdge
                      ? position
                      : min)
              .index;
          lastIndex = positions
              .where((ItemPosition position) => position.itemLeadingEdge < 1)
              .reduce((ItemPosition max, ItemPosition position) =>
                  position.itemLeadingEdge > max.itemLeadingEdge
                      ? position
                      : max)
              .index;
        }

        return Container(
          height: 50,
          width: Get.width,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Animator(
            tween:
                Tween<Offset>(begin: Offset(-Get.width, 0), end: Offset(-0, 0)),
            duration: Duration(milliseconds: 700),
            builder: (context, animatorState, child) => Transform.translate(
              offset: animatorState.value,
              child: Container(
                width: Get.width,
                child: ScopedModelDescendant<SupplierViewModel>(
                  builder: (context, child, model) {
                    final filterCategories = model.collections;
                    switch (model.status) {
                      case ViewStatus.Loading:
                        return Shimmer.fromColors(
                          baseColor: kBackgroundGrey[0],
                          highlightColor: Colors.grey[100],
                          enabled: true,
                          child: Container(
                            width: Get.width,
                            color: Colors.grey,
                          ),
                        );
                      case ViewStatus.Empty:
                      case ViewStatus.Error:
                        return Container(
                          color: kBackgroundGrey[3],
                        );
                      default:
                        return Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: PageView(
                                    controller: _scrollController,
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Container(
                                        width: Get.width,
                                        padding: const EdgeInsets.all(10),
                                        child: ListView.separated(
                                          itemBuilder: (context, index) =>
                                              filterButton(
                                            filterCategories[index],
                                            index,
                                            firstIndex == index,
                                          ),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: filterCategories.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  SizedBox(width: 8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget filterButton(CollectionDTO filter, int index, bool isOnView) {
    final title = filter.name;
    final isSelected = isOnView;

    return ButtonTheme(
      minWidth: 62,
      height: 32,
      focusColor: kPrimary,
      hoverColor: kPrimary,
      textTheme: ButtonTextTheme.normal,
      child: ScopedModelDescendant<SupplierViewModel>(
          builder: (context, child, model) {
        final onChangeFilter = model.updateFilter;
        return FlatButton(
          color: isSelected ? Color(0xFF00d286) : kBackgroundGrey[0],
          padding: EdgeInsets.all(4),
          onPressed: () async {
            itemScrollController.scrollTo(
              index: index,
              duration: Duration(milliseconds: 300 * (index + 1)),
              curve: Curves.easeInOutCubic,
            );
          },
          child: Row(
            children: [
              isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Icon(
                        Icons.done,
                        size: 20,
                      ),
                    )
                  : SizedBox(),
              Text(
                title,
                style: isSelected
                    ? kSubtitleTextSyule.copyWith(
                        color: Colors.white,
                      )
                    : kSubtitleTextSyule.copyWith(
                        color: Colors.black,
                      ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      }),
    );
  }
}
