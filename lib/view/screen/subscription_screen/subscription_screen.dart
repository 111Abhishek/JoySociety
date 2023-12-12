import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_society/provider/subscription_provider.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/screen/subscription_screen/widget/subscription_card_widget.dart';
import 'package:provider/provider.dart';
import '../../../data/model/response/subscription_demo_model.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/images.dart';
import '../../basewidget/loader_widget.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  _getMembersList() async {
    await Provider.of<SubscriptionProvider>(context, listen: false)
        .getSubscriptionList();
  }

  @override
  void initState() {
    _getMembersList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 20, left: 8),
            child: Row(children: [
              CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Image.asset(Images.logo_with_name_image, height: 40, width: 40),
              const SizedBox(width: 10),
              Text("Subscriptions",
                  style: poppinsBold.copyWith(
                    color: Colors.black,
                    fontSize: 20,
                  )),
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          Consumer<SubscriptionProvider>(builder: (context, plan, child) {
            return Expanded(
                child: plan.isLoading
                    ? Center(child: Loader().visible(plan.isLoading))
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: plan.subscriptionResponse.results?.length,
                        itemBuilder: (ctx, index) {
                          return SubscriptionCardWidget(
                            subscriptionObj:
                                plan.subscriptionResponse.results?[index],
                          ).paddingOnly(bottom: 20);
                        },
                      ));
          })
        ],
      )),
    );
  }
}
