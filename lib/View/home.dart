import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/View/login.dart';
import 'package:unidelivery_mobile/View/order.dart';
import 'package:unidelivery_mobile/ViewModel/home_viewModel.dart';
import 'package:unidelivery_mobile/ViewModel/login_viewModel.dart';
import 'package:unidelivery_mobile/acessories/appbar.dart';
import 'package:unidelivery_mobile/acessories/bottomnavigator.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/services/firebase.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    model.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget?.user.uid);
    return SafeArea(
      child: ScopedModel(
        model: model,
        child: Scaffold(
          floatingActionButton: ScopedModelDescendant<HomeViewModel>(
              builder: (context, child, model) {
            bool hasItemInCart = !model.cart.isEmpty;
            int quantity = model.cart.itemQuantity;

            return hasItemInCart
                ? FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      print('Tap order');
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OrderScreen(),
                      ));
                    },
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: kPrimary,
                            borderRadius: BorderRadius.circular(48),
                          ),
                          child: Icon(Icons.shopping_cart, color: Colors.white),
                        ),
                        Positioned(
                          top: -12,
                          left: 36,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.amber,
                            ),
                            child: Center(
                              child: Text(
                                quantity.toString(),
                                style: kTextPrimary.copyWith(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : SizedBox();
          }),
          bottomNavigationBar: ListView(
            shrinkWrap: true,
            children: [
              tag(),
              DefaultNavigatorBar(
                selectedIndex: 0,
              ),
            ],
          ),
          backgroundColor: Colors.white,
          //bottomNavigationBar: bottomBar(),
          body: Stack(
            children: [
              Container(
                // height: 800,
                child: ListView(
                  children: [
                    Container(
                      // height: 750,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: Column(
                            children: [
                              // banner(),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.blue[200],
                                  ),
                                  height: 80,
                                  width: double.infinity,
                                  child: Image.asset(
                                    'assets/images/banner.png',
                                    fit: BoxFit.cover,
                                    // width: double.infinity,
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              ScopedModelDescendant<HomeViewModel>(
                                builder: (context, child, model) {
                                  List<ProductDTO> products = model.products;
                                  Status status = model.status;
                                  switch (status) {
                                    case Status.Loading:
                                      return CircularProgressIndicator();
                                    case Status.Empty:
                                      return Center(
                                        child: Text("Empty list"),
                                      );
                                    case Status.Completed:
                                      return productListSection(products);
                                    default:
                                      return Text("Some thing wrong");
                                  }
                                },
                              ),
                              SizedBox(height: 16),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.orange[300],
                                  ),
                                  height: 80,
                                  width: double.infinity,
                                  child: Center(
                                      child: Text(
                                    "Bottom Section",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(height: 48),
                  ],
                ),
              ),
              HomeAppBar(),
            ],
          ),
        ),
      ),
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
      height: 430,
      child: Swiper(
        loop: true,
        fade: 0.2,
        // itemWidth: MediaQuery.of(context).size.width - 60,
        // itemHeight: 370,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, index) => listContents[index],
        itemCount: listContents.length,
        indicatorLayout: PageIndicatorLayout.SCALE,
        pagination: new SwiperPagination(),
        // viewportFraction: 0.85,
        scale: 0.7,
        outer: true,
      ),
    );
  }

  Widget homeContent(List<ProductDTO> list) {
    return GridView.count(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      primary: false,
      crossAxisSpacing: 8,
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
                        children: [
                          ...filterType.map((e) => filterButton(e)).toList(),
                          Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 40,
                              height: 40,
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
                                    _scrollController.position.maxScrollExtent,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                },
                                shape: CircleBorder(),
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
                                    _scrollController.position.minScrollExtent,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                },
                                shape: CircleBorder(),
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
              // TODO: Change by receive result from Navigator
              await model.updateItemInCart(
                ProductDTO('item1'),
                List.generate(
                    2,
                    (index) => ProductDTO('$index',
                        name: 'Prodcut Child ${index + 1}')),
                1,
              );
            },
            child: Opacity(
              opacity: 1,
              child: Column(
                children: [
                  Hero(
                    tag: this,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Opacity(
                        opacity: 1,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: FadeInImage(
                            image: NetworkImage(imageURL),
                            placeholder: AssetImage('assets/images/avatar.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      // color: Colors.blue,
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontWeight: FontWeight.bold),
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
