import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Model/DTO/index.dart';

class BannerDetailScreen extends StatefulWidget {
  final BlogDTO blog;

  const BannerDetailScreen({Key key, this.blog}) : super(key: key);

  @override
  _BannerDetailScreenState createState() => _BannerDetailScreenState();
}

class _BannerDetailScreenState extends State<BannerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final htmlData = widget.blog.content;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(
        title: widget.blog.title,
        backButton: Container(
          child: IconButton(
            icon: Icon(
              AntDesign.close,
              size: 24,
              color: kPrimary,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.blog.imageUrl,
              imageBuilder: (context, imageProvider) => Container(
                width: Get.width,
                height: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[100],
                enabled: true,
                child: Container(
                  color: Colors.grey,
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                MaterialIcons.broken_image,
                color: kPrimary.withOpacity(0.5),
              ),
            ),
            Html(
              data: htmlData,
              onLinkTap: (url) {},
              onImageTap: (src) {},
              onImageError: (exception, stackTrace) {},
            ),
          ],
        ),
      ),
    );
  }
}
