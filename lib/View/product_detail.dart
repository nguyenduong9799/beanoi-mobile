import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Model/DTO/CartDTO.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/ViewModel/product_viewModel.dart';
import 'package:unidelivery_mobile/constraints.dart';
import 'package:unidelivery_mobile/enums/view_status.dart';
import 'package:unidelivery_mobile/utils/shared_pref.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductDTO dto;

  ProductDetailScreen({this.dto});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  List<Tab> affectPriceTabs;
  List<Tab> unaffectPriceTabs;

  TabController _unaffectPriceController;
  TabController _affectPriceController;

  ProductDetailViewModel productDetailViewModel;

  ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    print("Product: " + widget.dto.toString());
    productDetailViewModel = new ProductDetailViewModel(widget.dto);

    pr = new ProgressDialog(
      context,
      showLogs: true,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );

    if (widget.dto.type == MASTER_PRODUCT) {
      affectPriceTabs = new List<Tab>();
      List<String> affectkeys =
          productDetailViewModel.affectPriceContent.keys.toList();
      for (int i = 0; i < affectkeys.length; i++) {
        print(affectkeys[i].toString());
        affectPriceTabs.add(Tab(
          child: Text(affectkeys[i].toUpperCase() + " (*)"),
        ));
      }

      _affectPriceController =
          TabController(vsync: this, length: affectPriceTabs.length);
      _affectPriceController.addListener(_handleAffectTabSelection);
    }

    unaffectPriceTabs = new List<Tab>();

    List<String> keys =
        productDetailViewModel.unaffectPriceContent.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      print(keys[i].toString());
      unaffectPriceTabs.add(Tab(
        child: Text(keys[i].toUpperCase() + " (*)"),
      ));
    }

    if (widget.dto.extraId != null) {
      productDetailViewModel.getExtra(widget.dto.extraId);
      unaffectPriceTabs.add(Tab(child: Text("Thêm ")));
    }

    _unaffectPriceController =
        TabController(vsync: this, length: unaffectPriceTabs.length);
    _unaffectPriceController.addListener(_handleUnaffectTabSelection);
  }

  void _handleAffectTabSelection() {
    if (_affectPriceController.indexIsChanging) {
      productDetailViewModel.changeAffectIndex(_affectPriceController.index);
    }
  }

  void _handleUnaffectTabSelection() {
    if (_unaffectPriceController.indexIsChanging) {
      productDetailViewModel
          .changeUnAffectIndex(_unaffectPriceController.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Container(
              margin: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimary.withOpacity(0.8),
              ),
              child: BackButton(color: Colors.white),
            ),
            backgroundColor: kBackgroundGrey[0],
            elevation: 0,
            pinned: true,
            floating: false,
            expandedHeight: 250.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.dto.id,
                child: ClipRRect(
                  child: Opacity(
                    opacity: 0.8,
                    child: CachedNetworkImage(
                      imageUrl: widget.dto.imageURL ?? "",
                      imageBuilder: (context, imageProvider) => Container(
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
                      tabUnaffectAtritbute(),
                      unAffectAtributeContent(),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(
                widget.dto.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
              widget.dto.type != MASTER_PRODUCT
                  ? Flexible(
                      child: Text(
                      NumberFormat.simpleCurrency(locale: 'vi')
                          .format(widget.dto.price),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ))
                  : Container()
            ],
          ),
          SizedBox(
            height: 16,
          ),
          // Text(
          //   " " + widget.dto.description,
          //   style: TextStyle(color: Colors.grey, fontSize: 16),
          // ),
          SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }

  Widget tabAffectAtritbute() {
    if (widget.dto.type == MASTER_PRODUCT) {
      return Container(
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(color: Hexcolor("ffc500"), width: 2))),
        width: MediaQuery.of(context).size.width,
        child: TabBar(
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          labelColor: kSecondary,
          unselectedLabelColor: kSecondary,
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          isScrollable: true,
          tabs: affectPriceTabs,
          indicatorColor: kPrimary,
          controller: _affectPriceController,
        ),
      );
    }
    return Container();
  }

  Widget AffectAtributeContent() {
    List<Widget> attributes;
    List<ProductDTO> listOptions;
    if (widget.dto.type == MASTER_PRODUCT) {
      return ScopedModelDescendant(
        builder:
            (BuildContext context, Widget child, ProductDetailViewModel model) {
          attributes = new List();
          listOptions = model.affectPriceContent[
              model.affectPriceContent.keys.elementAt(model.affectIndex)];

          for (int i = 0; i < listOptions.length; i++) {
            attributes.add(Container(
              padding: EdgeInsets.only(right: 8),
              child: RadioListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(listOptions[i].name),
                    Flexible(
                        child: Text(
                      NumberFormat.simpleCurrency(locale: 'vi')
                          .format(listOptions[i].price),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ))
                  ],
                ),
                groupValue: model.affectPriceChoice[
                    model.affectPriceContent.keys.elementAt(model.affectIndex)],
                value: listOptions[i],
                onChanged: (e) {
                  model.changeAffectPriceAtrribute(e);
                },
              ),
            ));
          }

          return Container(
            color: kBackgroundGrey[0],
            child: Column(
              children: [...attributes],
            ),
          );
        },
      );
    }
    return Container();
  }

  Widget tabUnaffectAtritbute() {
    if (unaffectPriceTabs.length != 0)
      return Container(
        width: MediaQuery.of(context).size.width,
        color: kPrimary,
        padding: EdgeInsets.only(top: 8),
        child: TabBar(
          labelColor: kPrimary,
          unselectedLabelColor: kBackgroundGrey[0],
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              color: kBackgroundGrey[0]),
          isScrollable: true,
          tabs: unaffectPriceTabs,
          indicatorColor: kBackgroundGrey[0],
          controller: _unaffectPriceController,
        ),
      );
    return Container();
  }

  Widget unAffectAtributeContent() {
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
              if (widget.dto.type == MASTER_PRODUCT) {
                listOptions = model.unaffectPriceContent[model
                    .unaffectPriceContent.keys
                    .elementAt(model.unaffectIndex)];
                for (int i = 0; i < listOptions.length; i++) {
                  attributes.add(RadioListTile(
                    title: Text(listOptions[i]),
                    groupValue: model.unaffectPriceChoice[model
                        .unaffectPriceContent.keys
                        .elementAt(model.unaffectIndex)],
                    value: listOptions[i],
                    onChanged: (e) {
                      model.changeUnAffectPriceAtrribute(e);
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
                      await pr.show();
                      List<ProductDTO> listChoices = new List<ProductDTO>();
                      if (widget.dto.type == MASTER_PRODUCT) {
                        for (int i = 0;
                            i < model.affectPriceChoice.keys.toList().length;
                            i++) {
                          print("Save product: " +
                              model.affectPriceChoice[
                                      model.affectPriceChoice.keys.elementAt(i)]
                                  .toString());
                          listChoices.add(model.affectPriceChoice[
                              model.affectPriceChoice.keys.elementAt(i)]);
                        }
                      }

                      if (widget.dto.extraId != null) {
                        for (int i = 0; i < model.extra.keys.length; i++) {
                          if (model.extra[model.extra.keys.elementAt(i)]) {
                            listChoices.add(model.extra.keys.elementAt(i));
                          }
                        }
                      }

                      String description = "";
                      for (int i = 0;
                          i < model.unaffectPriceChoice.keys.toList().length;
                          i++) {
                        description += model.unaffectPriceChoice.keys
                                .elementAt(i) +
                            ": " +
                            model.unaffectPriceChoice[
                                model.unaffectPriceChoice.keys.elementAt(i)] +
                            "\n";
                      }
                      CartItem item = new CartItem(
                          widget.dto, listChoices, description, model.count);

                      print("Save product: " + widget.dto.toString());
                      await addItemToCart(item);
                      await pr.hide();
                      Navigator.pop(context, true);
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
                            Text(model.count.toString() + " Món",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            Text("Thêm",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            Text(
                              NumberFormat.simpleCurrency(locale: "vi")
                                  .format(model.total),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
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
            Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  size: 30,
                  color: model.minusColor,
                ),
                onPressed: () {
                  model.minusQuantity();
                },
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              model.count.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
