import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';

class ProductsFilterPage extends StatefulWidget {
  final params;
  ProductsFilterPage({Key key, this.params}) : super(key: key);

  @override
  _ProductsFilterPageState createState() => _ProductsFilterPageState();
}

class _ProductsFilterPageState extends State<ProductsFilterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: "Danh sách sản phẩm",
      ),
      body: Column(
        children: [
          // _buildFilter(),
          // SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              itemCount: 12 + 1,
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemBuilder: (context, index) {
                if (index == 12) {
                  return Text(
                    "Bạn đã xem hết rồi đấy 🐱‍👓",
                    textAlign: TextAlign.center,
                  );
                }
                return Container(
                  color: Colors.white,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        print("Product selected");
                      },
                      child: Container(
                        height: 90,
                        padding: EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                // color: Colors.grey,
                              ),
                              width: 75,
                              height: 75,
                              child: CacheImage(
                                imageUrl:
                                    "https://firebasestorage.googleapis.com/v0/b/unidelivery-fad6f.appspot.com/o/00014100085607A.png?alt=media&token=40439c48-411b-41c9-a910-6c2f429509f8",
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cơm chiên thập cẩm",
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: kSubtitleTextSyule.copyWith(
                                          fontSize: 14),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Cơm chiên thơm ngon bổ dưỡng",
                                      style: kDescriptionTextSyle,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                      decoration: BoxDecoration(
                                        color: kPrimary,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        "25.000 đ",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                                      decoration: BoxDecoration(
                                        color: kBestSellerColor,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        "+ 8 bean",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _buildFilter() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
      color: Colors.white,
      child: Text("Filter controler"),
    );
  }
}
