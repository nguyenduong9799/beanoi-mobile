import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class CartButton extends StatefulWidget {
  final bool isMart;
  CartButton({this.isMart = false});

  @override
  State<StatefulWidget> createState() {
    return _CartButtonState();
  }
}

class _CartButtonState extends State<CartButton> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: Get.find<OrderViewModel>(),
        child: ScopedModelDescendant<OrderViewModel>(
            builder: (context, child, model) {
          if (model.status == ViewStatus.Loading) {
            return SizedBox.shrink();
          }
          if (model.currentCart == null) return SizedBox.shrink();
          int quantity = model.currentCart.itemQuantity();
          return Container(
            margin: EdgeInsets.only(bottom: 40),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 4,
              heroTag: CART_TAG,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                // side: BorderSide(color: Colors.red),
              ),
              onPressed: () async {
                await Get.toNamed(RouteHandler.ORDER);
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      AntDesign.shoppingcart,
                      color: kPrimary,
                    ),
                  ),
                  Positioned(
                    top: -10,
                    left: 32,
                    child: AnimatedContainer(
                      duration: Duration(microseconds: 300),
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
                          style: Get.theme.textTheme.headline3
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }));
  }
}
