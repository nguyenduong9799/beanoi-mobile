
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/ProductDTO.dart';
import 'package:unidelivery_mobile/ViewModel/product_viewModel.dart';
import 'package:unidelivery_mobile/constraints.dart';


class ProductDetailScreen extends StatefulWidget {
  ProductDTO dto;

  ProductDetailScreen(this.dto);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin{

  List<Tab> myTabs;

  TabController _tabController;

  ProductDetailViewModel productDetailViewModel;


  @override
  void initState() {
    super.initState();
    myTabs = new List<Tab>();
    productDetailViewModel = new ProductDetailViewModel(widget.dto.atrributes, widget.dto.topping, widget.dto.price);
    List<String> keys = productDetailViewModel.content.keys.toList();

    for(int i = 0; i < keys.length; i ++){
      print(keys[i].toString());
      myTabs.add(Tab(
        child: Text(keys[i].toUpperCase() + " (*)") ,));
    }
    myTabs.add(Tab(
      child: Text("Thêm"),
    ));

    print("Parent: " + widget.dto.id);

    _tabController = TabController(vsync: this, length: myTabs.length);


    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if(_tabController.indexIsChanging){
      productDetailViewModel.changeIndex(_tabController.index);
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
                color: kBackgroundGrey[4],
              ),


              child: BackButton(

      color: Colors.black
      ),
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
                    child: FadeInImage(
                      image: NetworkImage(widget.dto.imageURL),
                      width: MediaQuery.of(context).size.width,
                      placeholder: AssetImage('assets/images/avatar.png'),
                      // height: 250,
                      fit: BoxFit.cover,
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

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    productTitle(),
                    tabAtritbute(),
                    atributeContent(),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }


  Widget productTitle(){
    return Container(
      color: kBackgroundGrey[0],
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(widget.dto.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)),
              Flexible(child: Text(NumberFormat.simpleCurrency(locale: 'vi').format(widget.dto.price), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),))
            ],
          ),
          SizedBox(height: 16,),
          Text(" " + widget.dto.description, style: TextStyle(color: kBackgroundGrey[5],),),
          SizedBox(height: 8,)
        ],
      ),
    );
  }

  Widget tabAtritbute(){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: kPrimary,
      padding: EdgeInsets.only(top: 8),
      child: TabBar(
        labelColor:  kPrimary,
        unselectedLabelColor: kBackgroundGrey[0],
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
            ),
            color: kBackgroundGrey[0]),

        isScrollable: true,
        tabs: myTabs,
        indicatorColor: kBackgroundGrey[0],
        controller: _tabController,
      ),
    );
  }

  Widget atributeContent(){
    List<Widget> attributes;
    List<String> listOptions;
    return ScopedModel(
      model: productDetailViewModel,
      child: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, ProductDetailViewModel model) {
          if(!model.isExtra){
            attributes = new List();
            listOptions =  model.content[model.content.keys.elementAt(model.index)];
            for(int i = 0; i < listOptions.length; i++){
              attributes.add(Row(
                children: [
                  Radio(
                    groupValue: model.option[model.index],
                    value: listOptions[i],
                    onChanged: (e){
                      model.changeAtrribute(e);
                    },
                  ),
                  SizedBox(width: 5,),
                  Text(listOptions[i])
                ],
              ));
            }
          }
          else{
            attributes = new List();
            for(int i = 0; i < model.extra.keys.toList().length; i++){
              attributes.add(Row(
                children: [
                  Checkbox(
                    value: model.extra[model.extra.keys.elementAt(i)],
                    onChanged: (value) {
                      model.changExtra(value, i);
                    },
                  ),
                  SizedBox(width: 5,),
                  Text(model.extra.keys.elementAt(i))
                ],
              ));
            }
          }

          return Container(
            color: kBackgroundGrey[0],
            child: Column(
children: [
  ...attributes
],
            ),
          );
        },
      ),
    );
  }

  Widget bottomBar(){
    return  Container(
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
            SizedBox(height: 8,),
            Center(child: selectQuantity()),
            SizedBox(height: 8,),
            orderButton(),
            SizedBox(height: 8,)
          ],
        ),
      ),
    );
  }

  Widget orderButton(){
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, ProductDetailViewModel model) =>
          FlatButton(
            padding: EdgeInsets.all(8),
            onPressed: (){},
            textColor: kBackgroundGrey[0],
            color: model.buttonColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))
            ),
            child: Column(
              children: [
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(model.count.toString() + " Món", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text("Thêm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(NumberFormat.simpleCurrency(locale: "vi").format(model.total), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                  ],
                ),
                SizedBox(height: 8,),
              ],
            ),
          )
    );
}

  Widget selectQuantity(){
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, ProductDetailViewModel model) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline, size: 30, color: model.minusColor,),
              onPressed: (){
                model.minusQuantity();
              },
            ),
            SizedBox(width: 16,),
            Text(model.count.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            SizedBox(width: 8,),
            IconButton(
              icon: Icon(Icons.add_circle_outline, size: 30, color: model.addColor,),
              onPressed: (){
                model.addQuantity();
              },
            )
          ],
        );
      },
    );
  }

}
