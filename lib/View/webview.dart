import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Accessories/index.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';
import 'package:unidelivery_mobile/Services/firebase_dynamic_link_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({
    Key key,
    @required this.url,
  }) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if ((defaultTargetPlatform == TargetPlatform.android))
      WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: widget.url,
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
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        gestureNavigationEnabled: true,
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('intent://')) {
            String url = request.url
                .substring(request.url.indexOf("https://unidelivery.mobile/"));
            String route = url.split(";")[0];
            Uri deepLink = Uri.parse(route);
            DynamicLinkService.handleNaviagtion(deepLink.path);
          }

          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
