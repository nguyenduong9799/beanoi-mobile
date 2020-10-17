import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';

const ORDER_TIME = 23;

class HomeScreen extends StatefulWidget {
  final AccountDTO user;
  const HomeScreen({Key key, @required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool switcher = false;
  PageController _scrollController = new PageController();
  HomeViewModel model = HomeViewModel();
  DateTime now = DateTime.now();
  DateTime orderTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    ORDER_TIME,
  );
  // int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 60;
  bool _endOrderTime = false;

  @override
  void initState() {
    super.initState();
    model.getProducts();
    if (orderTime.isBefore(DateTime.now())) {
      setState(() {
        _endOrderTime = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget?.user.uid);
    return ScopedModelDescendant<RootViewModel>(
      builder:
          (BuildContext context, Widget child, RootViewModel rootViewModel) {
        return ScopedModel(
          model: model,
          child: Scaffold(
            floatingActionButton: buildCartButton(rootViewModel),
            backgroundColor: Colors.white,
            //bottomNavigationBar: bottomBar(),
            body: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
                        child: ListView(
                          children: [
                            // banner(),
                            location(rootViewModel),
                            Center(
                              child: Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.blue[200],
                                ),
                                height: MediaQuery.of(context).size.height * 0.13,
                                width: double.infinity,
                                child: Image.asset(
                                  'assets/images/banner.png',
                                  fit: BoxFit.cover,
                                  // width: double.infinity,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            buildProducts(rootViewModel),
                            SizedBox(height: 16),
                            Center(
                              child: Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  // color: Colors.orange[300],
                                ),
                                height: MediaQuery.of(context).size.height * 0.08,
                                width: double.infinity,
                                // child: Center(
                                //     child: Text(
                                //   "Bottom Section",
                                //   style: TextStyle(
                                //     fontSize: 25,
                                //   ),
                                // )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    HomeAppBar(),
                    buildCountDown(),
                    !_endOrderTime
                        ? Positioned(left: 0, bottom: 0, child: tag())
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget location(RootViewModel rootViewModel) {
    return ScopedModel(
      model: rootViewModel,
      child: ScopedModelDescendant<RootViewModel>(
        builder: (context, child, root) {
          String text = "Đợi tý đang load...";
          if (root.changeAddress) {
            text = "Đang thay đổi...";
          } else {
            if (root.dto != null) {
              text = root.dto.location;
            }
          }

          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    text,
                    style: kTextSecondary,
                  ),
                ],
              ),
            ),
            onTap: () async {
              await root.processChangeAddress(model);
            },
          );
        },
      ),
    );
  }

  Widget buildCartButton(rootViewModel) {
    return !_endOrderTime
        ? ScopedModelDescendant(
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
                          await model.openCart(rootViewModel);
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
            })
        : SizedBox.shrink();
  }

  Positioned buildCountDown() {
    return Positioned(
      top: 150,
      right: 0,
      child: RotatedBox(
        quarterTurns: -1,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          decoration: BoxDecoration(
            color: const Color(0xFFE8581C),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          child: Column(
            children: [
              // Text("Còn lại"),
              !_endOrderTime
                  ? CountdownTimer(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      endTime: orderTime.millisecondsSinceEpoch,
                      onEnd: () {
                        setState(() {
                          _endOrderTime = true;
                        });
                      },
                    )
                  : Text(
                      "Bạn quay lại sau nhé :(",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  ScopedModelDescendant<HomeViewModel> buildProducts(
      RootViewModel rootViewModel) {
    return ScopedModelDescendant<HomeViewModel>(
      builder: (context, child, model) {
        List<ProductDTO> products = model.products;
        ViewStatus status = model.status;
        // status = ViewStatus.Loading;
        switch (status) {
          case ViewStatus.Error:
            return AspectRatio(
              aspectRatio: 1,
              child: Center(
                  child: Text("Có gì sai sai... \n ${model.error.toString()}")),
            );
          case ViewStatus.Loading:
            return AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: TextLiquidFill(
                    text: 'Đang tải',
                    waveColor: kPrimary,
                    boxBackgroundColor: kBackgroundGrey[1],
                    textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.bold,
                    ),
                    boxHeight: 300.0,
                  ),
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
            if (rootViewModel.dto == null) rootViewModel.getLocation();
            return productListSection(products);
          default:
            return Text("Some thing wrong");
        }
      },
    );
  }

  Widget banner() {
    return Container(
      height: 90,
      color: Colors.red,
    );
  }

  Widget productListSection(List<ProductDTO> products) {
    List<Widget> listContents = new List();
    // xay 1 trang gom 3 x 3 item
    for (int i = 0; i < products.length; i += 9) {
      List<ProductDTO> chunk;
      int endIndex = i + 9 > products.length ? products.length : i + 9;
      chunk = products.sublist(i, endIndex);
      Widget productPage = homeContent(chunk);
      listContents.add(productPage);
    }
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Theme(
        data: ThemeData(
          backgroundColor: Colors.grey,
          scaffoldBackgroundColor: Colors.grey,
          primaryColor: kPrimary,
        ),
        child: Swiper(
          loop: false,
          fade: 0.2,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) => listContents[index],
          itemCount: listContents.length,
          indicatorLayout: PageIndicatorLayout.WARM,
          pagination: new SwiperPagination(),
          // viewportFraction: 0.85,
          scale: 0.7,
          outer: true,
        ),
      ),
    );
  }

  Widget homeContent(List<ProductDTO> list) {
    return GridView.count(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      primary: false,
      crossAxisSpacing: 12,
      // childAspectRatio: 1 / 2,
      mainAxisSpacing: 8,
      crossAxisCount: 3,
      children: list
          .map(
            (item) => FoodItem(
              product: item,
            ),
          )
          .toList(),
    );
  }

  Widget tag() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 50,
      width: screenWidth,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
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
                final filterType = model.filterType;
                final filterCategories = model.filterCategories;
                return PageView(
                  // shrinkWrap: true,
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      width: screenWidth,
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      // color: Colors.amber,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...filterType.map((e) => filterButton(e)).toList(),
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  // color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: RawMaterialButton(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: kPrimary,
                                  ),
                                  onPressed: () {
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration: Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn,
                                    );
                                  },
                                  shape: CircleBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth,
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  // color: Colors.amber,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: RawMaterialButton(
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: kPrimary,
                                  ),
                                  onPressed: () {
                                    print('Change filter type');
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.minScrollExtent,
                                      duration: Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn,
                                    );
                                  },
                                  shape: CircleBorder(),
                                ),
                              ),
                            ),
                          ),
                          ...filterCategories
                              .map((e) => filterButton(e))
                              .toList(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget filterButton(Filter filter) {
    final title = filter.name;
    final id = filter.id;
    final isSelected = filter.isSelected;
    final isMultiple = filter.isMultiple;

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
            await onChangeFilter(id, isMultiple);
          },
          child: Row(
            children: [
              isSelected && isMultiple
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
                    ? kTextPrimary.copyWith(
                        fontWeight: FontWeight.bold,
                      )
                    : kTextPrimary.copyWith(color: Colors.black),
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
