import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class CartButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CartButtonState();
  }
}

class _CartButtonState extends State<CartButton> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: Get.find<RootViewModel>(),
      child: ScopedModelDescendant<RootViewModel>(
          builder: (context, child, model) {
        if (model.status == ViewStatus.Loading) {
          return SizedBox.shrink();
        }
        return FutureBuilder(
            future: model.cart,
            builder: (context, snapshot) {
              Cart cart = snapshot.data;
              if (cart == null) return SizedBox.shrink();
              int quantity = cart?.itemQuantity();
              return Container(
                margin: EdgeInsets.only(bottom: 32),
                child: FloatingActionButton(
                  backgroundColor: Colors.transparent,
                  elevation: 4,
                  heroTag: CART_TAG,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    // side: BorderSide(color: Colors.red),
                  ),
                  onPressed: () async {
                    await model.openCart();
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
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
            });
      }),
    );
  }
}
