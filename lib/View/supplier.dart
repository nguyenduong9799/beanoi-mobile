import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
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
        floatingActionButton: CartButton(),
        body: SafeArea(
          child: Center(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: CustomScrollView(
                controller: model.scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    leading: Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 24,
                          color: kPrimary,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    elevation: 10,
                    pinned: true,
                    floating: false,
                    expandedHeight: Get.width * 0.25 + kToolbarHeight + 32 + 50,
                    bottom: PreferredSize(
                        preferredSize: Size.fromHeight(50), child: tag()),
                    title: Text(
                      widget.supplier.name,
                      style: TextStyle(color: kPrimary),
                    ),
                    flexibleSpace: ScopedModelDescendant<SupplierViewModel>(
                      builder: (context, child, model) {
                        if (model.isLoadGift) {
                          return Container(
                            margin: EdgeInsets.only(top: kToolbarHeight),
                            width: Get.width,
                            color: Colors.grey[200],
                          );
                        } else if (model.status == ViewStatus.Error ||
                            model.gifts.isEmpty ||
                            model.gifts == null) {
                          return Container(
                            margin: EdgeInsets.only(top: kToolbarHeight),
                            child: CachedNetworkImage(
                              imageUrl: defaultPromotionImage,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
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
                                  color: Colors.grey,
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                MaterialIcons.broken_image,
                                color: kPrimary.withOpacity(0.5),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(top: kToolbarHeight),
                            height: Get.width * 0.25 + 32,
                            color: kBackgroundGrey[3],
                            child: Swiper(
                                itemCount: model.gifts.length,
                                itemBuilder: (context, index) => Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: StorePromotion(
                                      dto: model.gifts[index],
                                    )), // -> Text widget.
                                //viewportFraction: 1,
                                loop: false,
                                control: new SwiperControl(
                                  color: Color(0xffEE9617),
                                  iconPrevious: AntDesign.leftcircle,
                                  iconNext: AntDesign.rightcircle,
                                )),
                          );
                        }
                      },
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                    <Widget>[buildProducts(), loadMoreIcon()],
                  ))
                ],
              ),
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
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: model.collections.length,
              itemBuilder: (context, index) {
                if (model.collections.every((element) => !element.isSelected) ||
                    model.collections[index].isSelected) {
                  return homeContent(model.collections[index]);
                }
                return SizedBox.shrink();
              },
            );
          default:
            return Text("Some thing wrong");
        }
      },
    );
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
                children: [
                  Container(
                    width: 64,
                    height: 64,
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
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
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
    return Container(
      height: 50,
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Animator(
        tween: Tween<Offset>(begin: Offset(-Get.width, 0), end: Offset(-0, 0)),
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
                                          filterButton(filterCategories[index]),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: filterCategories.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
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
  }

  Widget filterButton(CollectionDTO filter) {
    final title = filter.name;
    final id = filter.id;
    final isSelected = filter.isSelected;

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
            await onChangeFilter(id);
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
                    ? kTextPrimary.copyWith(fontStyle: FontStyle.italic)
                    : kTextPrimary.copyWith(
                        color: Colors.black, fontStyle: FontStyle.italic),
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
