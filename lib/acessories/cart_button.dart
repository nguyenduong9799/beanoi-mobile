import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

import '../constraints.dart';

Widget buildCartButton() {
  return ScopedModel(
    model: RootViewModel.getInstance(),
    child: ScopedModelDescendant<RootViewModel>(
        builder: (context, child, model) {
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
        }),
  );
}