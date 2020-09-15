import 'package:animator/animator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/AccountDTO.dart';
import 'package:unidelivery_mobile/View/login.dart';
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

  @override
  Widget build(BuildContext context) {
    // print(widget?.user.uid);
    return SafeArea(
      child: ScopedModel(
        model: HomeViewModel(),
        child: Scaffold(
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      // banner(),
                      swipeLayout(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 48),
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

  Widget swipeLayout() {
    List<Widget> listContents = new List();
    for (int i = 0; i < 9; i++) {
      listContents.add(homeContent());
    }
    return Expanded(
      child: Swiper(
        loop: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, index) => listContents[index],
        itemCount: listContents.length,
        pagination: new SwiperPagination(),
      ),
    );
  }

  Widget homeContent() {
    return GridView.count(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      childAspectRatio: MediaQuery.of(context).size.width *
          0.25 /
          (30 + MediaQuery.of(context).size.width * 0.25),
      crossAxisCount: 3,
      children: List.generate(9, (index) => cardDetail()),
    );
  }

  Widget cardDetail() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Card(
        elevation: 2.0,
        child: InkWell(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.25,
                color: Colors.grey[300],
                child: Center(
                  child: Image(
                    image: NetworkImage(
                        "https://celebratingsweets.com/wp-content/uploads/2018/06/Strawberry-Shortcake-Cake-1-1.jpg"),
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.width * 0.25,
                  ),
                ),
              ),
              Text("Bánh Gato", style: TextStyle(fontSize: 14)),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
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
          color: isSelected ? Color(0xFF00d286) : kBackgroundGrey[3],
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
