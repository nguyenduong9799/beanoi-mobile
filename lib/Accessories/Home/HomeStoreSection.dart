import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:unidelivery_mobile/Accessories/CacheImage.dart';
import 'package:unidelivery_mobile/Accessories/section.dart';
import 'package:unidelivery_mobile/Accessories/shimmer_block.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Enums/index.dart';
import 'package:unidelivery_mobile/Model/DTO/SupplierDTO.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/ViewModel/account_viewModel.dart';
import 'package:unidelivery_mobile/ViewModel/index.dart';

class HomeStoreSection extends StatelessWidget {
  const HomeStoreSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<HomeViewModel>(
      builder: (context, child, model) {
        ViewStatus status = model.status;
        bool isMenuAvailable = Get.find<RootViewModel>().isCurrentMenuAvailable;
        switch (status) {
          case ViewStatus.Error:
            return Column(
              children: [
                Center(
                  child: Text(
                    "Có gì đó sai sai..\n Vui lòng thử lại.",
                    // style: kTextPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Image.asset(
                  'assets/images/global_error.png',
                  fit: BoxFit.contain,
                ),
              ],
            );
          case ViewStatus.Loading:
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ShimmerBlock(width: Get.width * 0.4, height: 40),
                  SizedBox(height: 8),
                  buildSupplier(null, true),
                  SizedBox(height: 8),
                  buildSupplier(null, true),
                  SizedBox(height: 8),
                  buildSupplier(null, true),
                  SizedBox(height: 8),
                  buildSupplier(null, true),
                  SizedBox(height: 8),
                  buildSupplier(null, true),
                ],
              ),
            );
          default:
            if (model.suppliers == null ||
                model.suppliers.isEmpty ||
                model.suppliers
                        .where((supplier) => supplier.available)
                        .length ==
                    0) {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
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
                      "Aaa, hiện tại các nhà hàng đang bận, bạn vui lòng quay lại sau nhé",
                      textAlign: TextAlign.center,
                      style: kSubtitleTextSyule.copyWith(color: Colors.orange),
                    ),
                  ],
                ),
              );
            }
            return Section(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16.0, 8, 16),
                    child: Text(
                      'Quán ngon hôm nay',
                      style: kHeadingextStyle.copyWith(fontSize: 18),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      isMenuAvailable ? Colors.transparent : Colors.grey,
                      BlendMode.saturation,
                    ),
                    child: Column(
                      children: [
                        ...model.suppliers
                            .where((supplier) => supplier.available)
                            .map((supplier) => InkWell(
                                onTap: () {
                                  model.selectSupplier(supplier);
                                },
                                child: buildSupplier(supplier)))
                            .toList(),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  _suggestRestaurant(),
                  SizedBox(height: 8),
                ],
              ),
            );
        }
      },
    );
  }

  Widget buildSupplier(SupplierDTO dto, [bool loading = false]) {
    if (loading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ShimmerBlock(
            height: 50,
            width: 50,
            borderRadius: 16,
          ),
          SizedBox(width: 8),
          ShimmerBlock(height: 50, width: Get.width - 80),
        ],
      );
    }
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 8,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Opacity(
                opacity: 1,
                child: (dto.imageUrl == null || dto.imageUrl == "")
                    ? Icon(
                        MaterialIcons.broken_image,
                        color: kPrimary.withOpacity(0.5),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        child: CacheImage(
                          imageUrl: dto.imageUrl,
                        ),
                      ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              dto.name,
              style:
                  TextStyle(color: dto.available ? Colors.black : Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  Widget _suggestRestaurant() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8, 16, 8),
      child: Center(
        child: Text.rich(
          TextSpan(
            text: "Gợi ý nhà hàng bạn thích cho chúng mình ",
            style: kDescriptionTextSyle.copyWith(
              fontSize: 12,
            ),
            children: [
              WidgetSpan(
                child: ScopedModel<AccountViewModel>(
                  model: Get.find<AccountViewModel>(),
                  child: ScopedModelDescendant<AccountViewModel>(
                      builder: (context, child, model) {
                    return InkWell(
                      onTap: () async {
                        await model.sendFeedback(
                            "Nhập nhà hàng mà bạn muốn chúng mình phục vụ nhé");
                      },
                      child: Text(
                        "tại đây",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              TextSpan(text: " 📝 nha."),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
