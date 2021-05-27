import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';

class HomeCollection extends StatelessWidget {
  const HomeCollection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double kWitdthItem = 140;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text(
          "NẠP NĂNG LƯỢNG, FIX BUG SỪNG SỰC 💻",
          style: kTitleTextStyle,
        ),
        SizedBox(height: 4),
        Text(
          "Các món được lựa chọn cho các bạn IT",
          style: kDescriptionTextSyle.copyWith(fontSize: 12),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8),
        Container(
          width: Get.width,
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => SizedBox(width: 16),
            itemBuilder: (context, index) {
              return Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    print('View Detail item');
                  },
                  child: Container(
                    width: kWitdthItem,
                    height: 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          fit: BoxFit.fitWidth,
                          width: kWitdthItem,
                          height: kWitdthItem,
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/unidelivery-fad6f.appspot.com/o/images%2Fproducts%2F7b5ad3410d4572cecc6d40e54dbe6142.jpg?alt=media&token=0103ca63-1be8-4ce4-a984-712cc50acd30',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
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
                              color: Colors.grey,
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            MaterialIcons.broken_image,
                            color: kPrimary.withOpacity(0.5),
                          ),
                        ),
                        Text("Product"),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Flexible(
                              flex: 5,
                              child: Text("200.000 đ",
                                  style: kDescriptionTextSyle.copyWith(
                                      fontSize: 12)),
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              flex: 5,
                              child: Material(
                                child: InkWell(
                                  onTap: () {
                                    print("ADD TO CART");
                                  },
                                  child: Container(
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: kPrimary)),
                                    child: Text(
                                      "Chọn",
                                      style: TextStyle(fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: 6,
          ),
        )
      ],
    );
  }
}
