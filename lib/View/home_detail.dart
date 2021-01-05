import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Model/DTO/CollectionDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/StoreDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/loading.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/index.dart';

const ORDER_TIME = 11;

class HomeScreenDetail extends StatefulWidget {
  final StoreDTO store;
  const HomeScreenDetail({Key key, @required this.store}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenDetail> {
  bool switcher = false;
  PageController _scrollController = new PageController();
  static HomeViewModel model = HomeViewModel.getInstance();
  DateTime now = DateTime.now();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final double height = 200;

  @override
  void initState() {
    super.initState();
    model.getProducts(widget.store.id);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await model.getProducts(widget.store.id);
  }

  @override
  Widget build(BuildContext context) {
    // print(widget?.user.uid);
    return ScopedModel(
      model: RootViewModel.getInstance(),
      child: ScopedModelDescendant<RootViewModel>(
        builder:
            (BuildContext context, Widget child, RootViewModel rootViewModel) {
          return ScopedModel(
            model: model,
            child: Scaffold(
              floatingActionButton: buildCartButton(rootViewModel),
              body: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: _refresh,
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            leading: CupertinoNavigationBarBackButton(
                                color: Colors.white),
                            backgroundColor: kPrimary,
                            elevation: 10,
                            pinned: true,
                            floating: false,
                            expandedHeight: height,
                            bottom: PreferredSize(
                                preferredSize: Size.fromHeight(50),
                                child: tag()),
                            title: Text(
                              widget.store.name,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kBackgroundGrey[0]),
                            ),
                            flexibleSpace: LayoutBuilder(
                              builder: (context, constraints) {
                                var top = constraints.biggest.height;
                                if (top <= kToolbarHeight + 50) {
                                  model.updateShrinkStatus(true);
                                } else {
                                  model.updateShrinkStatus(false);
                                }
                                return Container(
                                  width: Get.width,
                                  margin: EdgeInsets.only(top: 70),
                                  decoration: BoxDecoration(
                                    color: kBackgroundGrey[0],
                                  ),
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Container(
                                        width: Get.width,
                                        height: 50,
                                        margin: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: kPrimary,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16)),
                                        ),
                                      ),
                                      Container(
                                        width: Get.width,
                                        height: 40,
                                        margin: EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: kPrimary,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(16),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          SliverList(
                              delegate: SliverChildListDelegate(
                            <Widget>[
                              Container(
                                child: Text('Hello'),
                              ),
                              buildProducts(rootViewModel),
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCartButton(rootViewModel) {
    return ScopedModelDescendant(
        rebuildOnChange: true,
        builder: (context, child, HomeViewModel model) {
          return FutureBuilder(
              future: model.cart,
              builder: (context, snapshot) {
                Cart cart = snapshot.data;
                if (cart == null) return SizedBox.shrink();
                int quantity = cart?.itemQuantity();
                return Container(
                  margin: EdgeInsets.only(bottom: 40),
                  child: FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    elevation: 8,
                    heroTag: CART_TAG,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      // side: BorderSide(color: Colors.red),
                    ),
                    onPressed: () async {
                      print('Tap order');
                      await model.openCart();
                    },
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            AntDesign.shoppingcart,
                            color: kPrimary,
                          ),
                        ),
                        Positioned(
                          top: -10,
                          left: 32,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.red,
                              //border: Border.all(color: Colors.grey),
                            ),
                            child: Center(
                              child: Text(
                                quantity.toString(),
                                style: kTextPrimary.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }

  ScopedModelDescendant<HomeViewModel> buildProducts(
      RootViewModel rootViewModel) {
    return ScopedModelDescendant<HomeViewModel>(
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
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: model.scrollController,
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
    return ScopedModelDescendant<HomeViewModel>(
        builder: (context, child, model) {
      List<Widget> listProducts = List();
      if (collection.products != null && collection.products.isNotEmpty) {
        collection.products.forEach((product) {
          double price = product.prices[0];
          if (product.type == ProductType.MASTER_PRODUCT) {
            price = product.minPrice;
          }
          listProducts.add(InkWell(
            onTap: () {
              model.openProductDetail(product);
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: kBackgroundGrey[3]))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(
                        product.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decorationThickness: 0.5),
                      )),
                      Flexible(
                          child: Text(
                              product.type != ProductType.MASTER_PRODUCT
                                  ? formatPrice(price)
                                  : "từ " + formatPrice(price),
                              style: TextStyle(color: kPrimary)))
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                      width: Get.width * 0.65,
                      child: Text(
                        product.description ?? "",
                        maxLines: 1,
                        style: TextStyle(decorationThickness: 0.5),
                        overflow: TextOverflow.ellipsis,
                      ))
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
                child: Text(
                  collection.name,
                  style: TextStyle(
                      color: kPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
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

  Widget tag() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 50,
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Animator(
        tween:
            Tween<Offset>(begin: Offset(-screenWidth, 0), end: Offset(-0, 0)),
        duration: Duration(milliseconds: 700),
        builder: (context, animatorState, child) => Transform.translate(
          offset: animatorState.value,
          child: Container(
            width: screenWidth,
            child: ScopedModelDescendant<HomeViewModel>(
              builder: (context, child, model) {
                final filterCategories = model.collections;
                switch (model.status) {
                  case ViewStatus.Loading:
                    return Shimmer.fromColors(
                      baseColor: kBackgroundGrey[0],
                      highlightColor: Colors.grey[100],
                      enabled: true,
                      child: Container(
                        width: screenWidth,
                        color: Colors.grey,
                      ),
                    );
                  default:
                    if (model.collections != null &&
                        model.collections.isNotEmpty) {
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
                                      width: screenWidth,
                                      padding: const EdgeInsets.all(10),
                                      child: ListView.separated(
                                        itemBuilder: (context, index) =>
                                            filterButton(
                                                filterCategories[index]),
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
                    return Container(
                      color: kBackgroundGrey[3],
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
      child: ScopedModelDescendant<HomeViewModel>(
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

class FoodItem extends StatefulWidget {
  final ProductDTO product;
  FoodItem({Key key, this.product}) : super(key: key);

  @override
  _FoodItemState createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final name = product.name;
    final imageURL = product.imageURL;
    return Container(
      // width: MediaQuery.of(context).size.width * 0.3,
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        // color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: ScopedModelDescendant<HomeViewModel>(
            builder: (context, child, model) {
          return InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () async {
              print('Add item to cart');
              model.openProductDetail(product);
            },
            child: Opacity(
              opacity: 1,
              child: Column(
                children: [
                  Hero(
                    tag: product.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Opacity(
                        opacity: 1,
                        child: AspectRatio(
                          aspectRatio: 1.14,
                          child: (imageURL == null || imageURL == "")
                              ? Icon(
                                  MaterialIcons.broken_image,
                                  color: kPrimary.withOpacity(0.5),
                                )
                              : CachedNetworkImage(
                                  imageUrl: imageURL,
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
                                      width: 100,
                                      height: 100,
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
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.blue,
                      height: 60,
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
