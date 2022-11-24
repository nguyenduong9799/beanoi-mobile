import 'dart:async';

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/appbar.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/button.dart';
import 'package:unidelivery_mobile/Constraints/BeanOiTheme/index.dart';
import 'package:unidelivery_mobile/Constraints/constraints.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/NewsfeedDTO.dart';
import 'package:unidelivery_mobile/ViewModel/newsfeed_viewModel.dart';
import 'package:unidelivery_mobile/Widgets/beanoi_button.dart';

class NewsfeedScreen extends StatefulWidget {
  const NewsfeedScreen({Key key}) : super(key: key);

  @override
  State<NewsfeedScreen> createState() => _NewsfeedScreenState();
}

class _NewsfeedScreenState extends State<NewsfeedScreen> {
  NewsfeedViewModel _newsfeedViewModel;
  bool open = true;

  static const FILTER_ALL = 'FILTER_ALL';
  static const FILTER_NORMAL = 'FILTER_NORMAL';
  static const FILTER_GIFT = 'FILTER_GIFT';

  String filterBy = FILTER_ALL;

  void _buttonClose() {
    setState(() {
      open = false;
    });
  }

  void _buttonFilter() {}

  @override
  void initState() {
    super.initState();

    String now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String sevenDayBefore = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(const Duration(days: 7)));

    _newsfeedViewModel = NewsfeedViewModel();
    Timer.periodic(
        Duration(seconds: 5),
        (_) => _newsfeedViewModel.getNewsfeed(
            params: {"from-date": sevenDayBefore, "to-date": now}));
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   NewsfeedDTO lastFeed = _newsfeedViewModel.newsfeeds[0];

  // }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<NewsfeedViewModel>(
      model: _newsfeedViewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "THÔNG TẤN XÃ BEAN ƠI",
            style: BeanOiTheme.typography.h2
                .copyWith(color: BeanOiTheme.palettes.primary400),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: null,
        ),
        body: SafeArea(
          child: ListView(
            children: [
              if (open) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // color: BeanOiTheme.palettes.primary500,
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xff4BAA67),
                            Color(0xff94C9A3),
                          ],
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      // height: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    "Tặng quà cho bạn bè",
                                    style: BeanOiTheme.typography.h2.copyWith(
                                        color:
                                            BeanOiTheme.palettes.secondary200),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                      "Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Far far away, behind the word mountains, far",
                                      style: BeanOiTheme.typography.caption
                                          .copyWith(
                                              color: BeanOiTheme
                                                  .palettes.secondary100)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: TextButton(
                                    child: Text("Đã hiểu",
                                        style: BeanOiTheme.typography.subtitle1
                                            .copyWith(
                                                color: BeanOiTheme
                                                    .palettes.shades100)),
                                    onPressed: _buttonClose,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: Image.asset(
                                  'assets/images/option.png',
                                )),
                          )
                        ],
                      )),
                )
              ],
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: filterBy == FILTER_ALL
                              ? BeanOiTheme.palettes.primary300
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Tất cả",
                              style: BeanOiTheme.typography.subtitle1.copyWith(
                                  color: filterBy == FILTER_ALL
                                      ? BeanOiTheme.palettes.neutral100
                                      : BeanOiTheme.palettes.primary400)),
                        ),
                      ),
                      onTap: () => {
                        setState(() {
                          filterBy = FILTER_ALL;
                        })
                      },
                    ),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: filterBy == FILTER_NORMAL
                              ? BeanOiTheme.palettes.primary300
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Đặt món",
                              style: BeanOiTheme.typography.subtitle1.copyWith(
                                  color: filterBy == FILTER_NORMAL
                                      ? BeanOiTheme.palettes.neutral100
                                      : BeanOiTheme.palettes.primary400)),
                        ),
                      ),
                      onTap: () => {
                        setState(() {
                          filterBy = FILTER_NORMAL;
                        })
                      },
                    ),
                    InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: filterBy == FILTER_GIFT
                              ? BeanOiTheme.palettes.primary300
                              : null,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Tặng quà",
                              style: BeanOiTheme.typography.subtitle1.copyWith(
                                  color: filterBy == FILTER_GIFT
                                      ? BeanOiTheme.palettes.neutral100
                                      : BeanOiTheme.palettes.primary400)),
                        ),
                      ),
                      onTap: () => {
                        setState(() {
                          filterBy = FILTER_GIFT;
                        })
                      },
                    ),
                    
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: ScopedModelDescendant<NewsfeedViewModel>(
                  builder: (context, child, model) {
                    List<NewsfeedDTO> newsfeeds;
                    if (filterBy == FILTER_ALL) {
                      newsfeeds = model.newsfeeds;
                    } else if (filterBy == FILTER_NORMAL) {
                      newsfeeds = List<NewsfeedDTO>.from(model.newsfeeds
                          .where((element) => element.feedType == 'Normal'));
                    } else {
                      newsfeeds = List<NewsfeedDTO>.from(model.newsfeeds
                          .where((element) => element.feedType == 'Gift'));
                    }
                    if (newsfeeds == null || newsfeeds.length == 0) {
                      return Text("Khong co newsfeed");
                    }
                    return Container(
                        child: Column(
                      children: newsfeeds
                          .map((newsfeed) => _buildNewsfeedList(newsfeed))
                          .toList(),
                    ));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsfeedList(NewsfeedDTO newsfeed) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      // height: 100,
      child: Column(
        children: [
          if (newsfeed.feedType == 'Normal') ...[
            _buildNormalNewsfeed(newsfeed)
          ] else ...[
            _buildGiftNewsfeed(newsfeed)
          ]
        ],
      ),
    );
  }

  Widget _buildGiftNewsfeed(NewsfeedDTO newsfeed) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(0, 8, 8, 8),
      title: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 68,
                  width: 68,
                  decoration:
                      BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                  child:
                      ClipOval(child: Image.asset('assets/images/avatar.png')),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Flexible(
                              child: RichText(
                            text: TextSpan(
                                text:
                                    '${newsfeed.sender.name} đã tặng quà cho ',
                                style: BeanOiTheme.typography.subtitle2
                                    .copyWith(
                                        color: BeanOiTheme.palettes.neutral700),
                                children: [
                                  TextSpan(
                                      text: "${newsfeed.receiver.name}",
                                      style: BeanOiTheme.typography.body2
                                          .copyWith(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 1))),
                                ]),
                          )),
                        ],
                      ),
                      Row(
                        children: [
                          Text(Jiffy("${newsfeed.createAt}").fromNow(),
                              style: BeanOiTheme.typography.caption.copyWith(
                                  color: BeanOiTheme.palettes.neutral700))
                        ],
                      ),
                      Row(children: [
                        Flexible(
                          child: Text(
                              newsfeed.listProducts
                                  .map((p) => p.productName)
                                  .join(", "),
                              overflow: TextOverflow.ellipsis,
                              style: BeanOiTheme.typography.subtitle1.copyWith(
                                  color: BeanOiTheme.palettes.primary300)),
                        )
                      ])
                    ],
                  ))
            ],
          ),
          // Expanded(child: child)
        ],
      ),
    );
  }

  Widget _buildNormalNewsfeed(NewsfeedDTO newsfeed) {
    final productStoreNames =
        newsfeed.listProducts.map((e) => e.supplierStoreName).toList();
    final listUndupicateStoreName = [];
    for (var i = 0; i < productStoreNames.length; i++) {
      if (productStoreNames.indexOf(productStoreNames[i]) == i) {
        listUndupicateStoreName.add(productStoreNames[i]);
      }
    }
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      title: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 68,
                  width: 68,
                  decoration:
                      BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                  child:
                      ClipOval(child: Image.asset('assets/images/avatar.png')),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                                child: RichText(
                              text: TextSpan(
                                text:
                                    '${newsfeed.sender.name} đã chốt ${newsfeed.listProducts.length} món tại ',
                                style: BeanOiTheme.typography.subtitle2
                                    .copyWith(
                                        color: BeanOiTheme.palettes.neutral700),
                                children: listUndupicateStoreName
                                    .asMap()
                                    .entries
                                    .map((p) => p.key !=
                                            (listUndupicateStoreName.length - 1)
                                        ? TextSpan(
                                            text: "${p.value}, ",
                                            style: BeanOiTheme.typography.body2
                                                .copyWith(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1)))
                                        : TextSpan(
                                            text: "${p.value}",
                                            style: BeanOiTheme.typography.body2
                                                .copyWith(
                                                    color: Color.fromRGBO(
                                                        0, 0, 0, 1))))
                                    .toList(),
                              ),
                            )),
                          ],
                        ),
                        Row(
                          children: [
                            Text(Jiffy("${newsfeed.createAt}").fromNow(),
                                style: BeanOiTheme.typography.caption.copyWith(
                                    color: BeanOiTheme.palettes.neutral700))
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: newsfeed.listProducts
                                .map((p) => _buildProduct(p))
                                .toList(),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
          // Expanded(child: child)
        ],
      ),
    );
  }

  Widget _buildProduct(ProductNewsfeedDTO product) {
    return Row(
      children: [
        Container(
            child: Image.network(
          product.picUrl ?? defaultImage,
          width: 40,
          height: 40,
        ))
      ],
    );
  }
}
