import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/Utils/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductDTO dto;

  ProductDetailScreen({this.dto});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  List<String> affectPriceTabs;

  ProductDetailViewModel productDetailViewModel;

  @override
  void initState() {
    super.initState();
    productDetailViewModel = new ProductDetailViewModel(widget.dto);
    if (widget.dto.type == ProductType.MASTER_PRODUCT ||
        widget.dto.type == ProductType.COMPLEX_PRODUCT) {
      affectPriceTabs = new List<String>();
      List<String> affectkeys =
          productDetailViewModel.affectPriceContent.keys.toList();
      for (int i = 0; i < affectkeys.length; i++) {
        affectPriceTabs.add(affectkeys[i].toUpperCase());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundGrey[0],
      bottomNavigationBar: bottomBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Container(
              margin: EdgeInsets.only(left: 8),
              padding: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimary.withOpacity(0.8),
              ),
              child: CupertinoNavigationBarBackButton(color: Colors.white),
            ),
            elevation: 0,
            pinned: true,
            floating: false,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                child: CacheImage(
                  imageUrl: widget.dto.imageURL ?? defaultImage,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Container(
                // height: 500,
                width: MediaQuery.of(context).size.width,
                //padding: EdgeInsets.fromLTRB(30, 20, 20, 10),

                child: ScopedModel(
                  model: productDetailViewModel,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      productTitle(),
                      tabAffectAtritbute(),
                      AffectAtributeContent(),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget productTitle() {
    return Container(
      color: kBackgroundGrey[0],
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.dto.name + " ",
                  style: Get.theme.textTheme.headline1
                      .copyWith(color: Colors.black),
                ),
              ),
              widget.dto.type != ProductType.GIFT_PRODUCT
                  ? Flexible(
                      child: RichText(
                          text: TextSpan(
                              text: "+ " + widget.dto.bean.toString() + " ",
                              style: Get.theme.textTheme.headline1
                                  .copyWith(color: Colors.orange),
                              children: [
                            WidgetSpan(
                                alignment: PlaceholderAlignment.bottom,
                                child: Image(
                                  image: AssetImage(
                                      "assets/images/icons/bean_coin.png"),
                                  width: 30,
                                  height: 30,
                                ))
                          ])),
                    )
                  : SizedBox.shrink()
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            widget.dto.description != null ? " " + widget.dto.description : "",
            style: Get.theme.textTheme.headline4.copyWith(color: Colors.grey),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
          SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }

  Widget tabAffectAtritbute() {
    // Tab extraTab = Tab(
    //   child: Text("Thêm"),
    // );
    String extraTab = "Thêm";

    if (widget.dto.type == ProductType.MASTER_PRODUCT ||
        widget.dto.type == ProductType.COMPLEX_PRODUCT) {
      return ScopedModelDescendant<ProductDetailViewModel>(
        builder: (context, child, model) {
          if (model.extra != null) {
            if (affectPriceTabs.isEmpty) {
              affectPriceTabs.add(extraTab);
            } else if (affectPriceTabs.last != extraTab) {
              affectPriceTabs.add(extraTab);
            }
          } else {
            if (affectPriceTabs.isEmpty) {
              return SizedBox.shrink();
            } else if (affectPriceTabs.last == extraTab) {
              affectPriceTabs.removeLast();
            }
          }

          return Container(
              width: Get.width,
              color: kPrimary,
              padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
              child: CustomTabView(
                itemCount: affectPriceTabs.length,
                tabBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: Text.rich(
                      TextSpan(text: affectPriceTabs[index], children: [
                    TextSpan(
                        text: affectPriceTabs[index] != extraTab ? " *" : "",
                        style: Get.theme.textTheme.headline4
                            .copyWith(color: Colors.red))
                  ])),
                ),
                onPositionChange: (index) {
                  model.changeAffectIndex(index);
                },
              ));
        },
      );
    }
    return Container();
  }

  Widget AffectAtributeContent() {
    List<Widget> attributes;
    List<String> listOptions;
    return ScopedModelDescendant(
      builder:
          (BuildContext context, Widget child, ProductDetailViewModel model) {
        switch (model.status) {
          case ViewStatus.Error:
            return Center(child: Text("Có gì sai sai... \n"));
          case ViewStatus.Loading:
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          case ViewStatus.Empty:
            return Center(
              child: Text("Empty list"),
            );
          case ViewStatus.Completed:
            if (!model.isExtra) {
              attributes = new List();
              if (widget.dto.type == ProductType.MASTER_PRODUCT) {
                listOptions = model.affectPriceContent[
                    model.affectPriceContent.keys.elementAt(model.affectIndex)];
                for (int i = 0; i < listOptions.length; i++) {
                  attributes.add(RadioListTile(
                    title: Text(listOptions[i]),
                    groupValue: model.selectedAttributes[model
                        .affectPriceContent.keys
                        .elementAt(model.affectIndex)],
                    value: listOptions[i],
                    onChanged: (e) {
                      model.changeAffectPriceAtrribute(e);
                    },
                  ));
                }
              }
            } else {
              attributes = new List();
              for (int i = 0; i < model.extra.keys.toList().length; i++) {
                attributes.add(CheckboxListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(model.extra.keys.elementAt(i).name.contains("Extra")
                          ? model.extra.keys
                              .elementAt(i)
                              .name
                              .replaceAll("Extra", "+")
                          : model.extra.keys.elementAt(i).name),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(NumberFormat.simpleCurrency(locale: "vi")
                              .format(model.extra.keys.elementAt(i).price)),
                        ),
                      )
                    ],
                  ),
                  value: model.extra[model.extra.keys.elementAt(i)],
                  onChanged: (value) {
                    model.changExtra(value, i);
                  },
                ));
              }
            }
            return Container(
              color: kBackgroundGrey[0],
              child: Column(
                children: [...attributes],
              ),
            );
          default:
            return Container();
        }
      },
    );
  }

  Widget bottomBar() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: kBackgroundGrey[0],
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: ScopedModel(
        model: productDetailViewModel,
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 8,
            ),
            Center(child: selectQuantity()),
            SizedBox(
              height: 8,
            ),
            orderButton(),
            SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }

  Widget orderButton() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child,
                ProductDetailViewModel model) =>
            model.order
                ? FlatButton(
                    padding: EdgeInsets.all(8),
                    onPressed: () async {
                      await model.addProductToCart();
                    },
                    textColor: kBackgroundGrey[0],
                    color: kPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(model.count.toString() + " Món ",
                                  style: Get.theme.textTheme.headline3
                                      .copyWith(color: Colors.white)),
                            ),
                            Flexible(
                              child: Text("Thêm ",
                                  style: Get.theme.textTheme.headline3
                                      .copyWith(color: Colors.white)),
                            ),
                            widget.dto.type != ProductType.GIFT_PRODUCT
                                ? Flexible(
                                    child: Text(
                                      formatPrice(model.total),
                                      style: Get.theme.textTheme.headline3
                                          .copyWith(color: Colors.white),
                                    ),
                                  )
                                : Flexible(
                                    child: RichText(
                                        text: TextSpan(
                                            text: model.total.toString() + " ",
                                            style: Get.theme.textTheme.headline3
                                                .copyWith(color: Colors.white),
                                            children: [
                                          WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.bottom,
                                              child: Image(
                                                image: AssetImage(
                                                    "assets/images/icons/bean_coin.png"),
                                                width: 20,
                                                height: 20,
                                              ))
                                        ])),
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  )
                : FlatButton(
                    padding: EdgeInsets.all(8),
                    onPressed: () {},
                    textColor: kBackgroundGrey[0],
                    color: kBackgroundGrey[5],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text("Vui lòng chọn những trường bắt buộc (*)",
                            style: Get.theme.textTheme.headline3
                                .copyWith(color: Colors.white)),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ));
  }

  Widget selectQuantity() {
    return ScopedModelDescendant(
      builder:
          (BuildContext context, Widget child, ProductDetailViewModel model) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.remove_circle_outline,
                size: 30,
                color: model.minusColor,
              ),
              onPressed: () {
                model.minusQuantity();
              },
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              model.count.toString(),
              style:
                  Get.theme.textTheme.headline1.copyWith(color: Colors.black),
            ),
            SizedBox(
              width: 8,
            ),
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                size: 30,
                color: model.addColor,
              ),
              onPressed: () {
                model.addQuantity();
              },
            )
          ],
        );
      },
    );
  }
}
