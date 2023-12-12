import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utill/color_resources.dart';

class WebViewScreen extends StatefulWidget {
  final String? url;
 const WebViewScreen({Key? key, this.url}) : super(key: key);
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<WebViewScreen> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  bool urlChanged = false;
  String url = '';
  @override
  void initState() {
    url = widget.url!;
      controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(onPageStarted: (url) {
        setState(() {
          loadingPercentage = 0;
        });
      }, onProgress: (progress) {
        setState(() {
          loadingPercentage = progress;
        });
      }, onPageFinished: (url) {
        setState(() {
          loadingPercentage = 100;
        });
      }, onUrlChange: (url) {
        if (url.url.toString() != widget.url) {
          Navigator.pop(context , true);
        }
      }))
      ..loadRequest(Uri.parse(widget.url!))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
            children: [
              WebViewWidget(controller: controller),
              if (loadingPercentage < 100)
                LinearProgressIndicator(
                  value: loadingPercentage / 100,
                  color: ColorResources.DARK_GREEN_COLOR,
                  backgroundColor: ColorResources.APP_BACKGROUND_COLOR,
                )
            ],
          )),
    );
  }
}
