import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WorkshopSubscriptionScreen extends StatefulWidget {
  const WorkshopSubscriptionScreen({super.key, required this.url});

  final String url;

  @override
  State<WorkshopSubscriptionScreen> createState() =>
      _WorkshopSubscriptionScreenState();
}

class _WorkshopSubscriptionScreenState
    extends State<WorkshopSubscriptionScreen> {
  late final WebViewController controller;
  var loadingPercentage = 0;

  bool urlChanged = false;
  late String currentUrl = widget.url;

  @override
  void initState() {
    super.initState();
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
          Navigator.pop(context);
        }
      }))
      ..loadRequest(Uri.parse(widget.url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          leading: CupertinoNavigationBarBackButton(color: Colors.grey.shade900,),
          leadingWidth: 45,
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(Images.logo_with_name_image, height: 25, width: 25,),
              const SizedBox(width: 16,),
              Text('Perform payment',
                  style: poppinsSemiBold.copyWith(
                      fontSize: 14, color: Colors.grey.shade900))
            ],
          ),
        ),
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
        ));
  }
}
