import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:unidelivery_mobile/Constraints/index.dart';

class DynamicScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<DynamicScreen> {
  String _linkMessage;
  bool _isCreatingLink = false;
  String _testString =
      'To test: long press link and then copy and click from a non-browser '
      "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
      'is properly setup. Look at firebase_dynamic_links/README.md for more '
      'details.';
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  Future<void> _createDynamicLink(bool short, String path) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://unidelivery.page.link',
      link: Uri.parse('https://unidelivery.mobile/$path'),
      androidParameters: AndroidParameters(
        packageName: 'com.unibean.unidelivery',
        minimumVersion: 0,
      ),
      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),
      iosParameters: IosParameters(
        bundleId: 'com.unibean.unideliveryMobile',
        minimumVersion: '0',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink = await parameters.buildShortLink();
      url = shortLink.shortUrl;
    } else {
      url = await parameters.buildUrl();
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic Links Example'),
        ),
        body: Builder(builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _controller,
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: !_isCreatingLink
                          ? () => _createDynamicLink(false, _controller.text)
                          : null,
                      child: const Text('Get Long Link'),
                    ),
                    ElevatedButton(
                      onPressed: !_isCreatingLink
                          ? () => _createDynamicLink(true, _controller.text)
                          : null,
                      child: const Text('Get Short Link'),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    if (_linkMessage != null) {
                      Get.toNamed(RouteHandler.WEBVIEW,
                          arguments: _linkMessage);
                    }
                  },
                  onLongPress: () {
                    Clipboard.setData(ClipboardData(text: _linkMessage));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied Link!')),
                    );
                  },
                  child: Text(
                    _linkMessage ?? '',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                Text(_linkMessage == null ? '' : _testString)
              ],
            ),
          );
        }),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  return Material(
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Hello World DeepLink'),
      ),
      body: const Center(
        child: Text('Hello, World!'),
      ),
    ),
  );
}
