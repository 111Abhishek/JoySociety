import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/screen/topic/topicList/topics_list_screen.dart';

import '../../../localization/language_constants.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../basewidget/button/custom_button.dart';

class ContentListScreen extends StatefulWidget {
  const ContentListScreen({Key? key}) : super(key: key);

  @override
  State<ContentListScreen> createState() => _ContentListScreenState();
}

class _ContentListScreenState extends State<ContentListScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void _onContentClick() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => TopicsListScreen()));
  }

  String initValue = 'Questions';
  var itemList = ['Questions', 'Multi Choice', 'Hot Cold', 'Percentage'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 48, left: 8),
            child: Row(children: [
              CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Image.asset(Images.logo_with_name_image, height: 40, width: 40),
              const SizedBox(width: 10),
              Text(getTranslated('CONTENT', context),
                  style:
                      poppinsBold.copyWith(fontSize: 20, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ]),
          ),
          Container(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorResources.getIconBg(context),
                      borderRadius: const BorderRadius.only(
                        topLeft:
                            Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                        topRight:
                            Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                      ),
                    ),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                  color:
                                      ColorResources.NAVIGATION_DIVIDER_COLOR),
                              Text(
                                getTranslated('CONTENT_TYPE', context),
                                style: poppinsBold.copyWith(
                                    fontSize: 20, color: Colors.teal),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                  color:
                                      ColorResources.NAVIGATION_DIVIDER_COLOR),
                              Text(
                                getTranslated('QUICK_POST', context),
                                style: poppinsBold.copyWith(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Text(
                                getTranslated('CONTENT_TYPE_TITLE', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: 12, color: Colors.black),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).highlightColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 1))
                                    // changes position of shadow
                                  ],
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      isExpanded: true,
                                      value: initValue,
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                      items: itemList.map((String items) {
                                        return DropdownMenuItem(
                                            value: items, child: Text(items));
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          initValue = newValue!;
                                        });
                                      }),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                  color:
                                      ColorResources.NAVIGATION_DIVIDER_COLOR),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                getTranslated('ARTICLES', context),
                                style: poppinsBold.copyWith(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Text(
                                getTranslated('ARTICLES_TITLE', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: 12, color: Colors.black),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).highlightColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 1))
                                    // changes position of shadow
                                  ],
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      isExpanded: true,
                                      value: initValue,
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                      items: itemList.map((String items) {
                                        return DropdownMenuItem(
                                            value: items, child: Text(items));
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          initValue = newValue!;
                                        });
                                      }),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                  color:
                                      ColorResources.NAVIGATION_DIVIDER_COLOR),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                getTranslated('POLLS_AND_QUESTION', context),
                                style: poppinsBold.copyWith(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Text(
                                getTranslated(
                                    'POLLS_AND_QUESTION_TITLE', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: 12, color: Colors.black),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).highlightColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 1))
                                    // changes position of shadow
                                  ],
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      isExpanded: true,
                                      value: initValue,
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                      items: itemList.map((String items) {
                                        return DropdownMenuItem(
                                            value: items, child: Text(items));
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          initValue = newValue!;
                                        });
                                      }),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                  color:
                                      ColorResources.NAVIGATION_DIVIDER_COLOR),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                getTranslated('EVENTS', context),
                                style: poppinsBold.copyWith(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Text(
                                getTranslated('EVENTS_TITLE', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: 12, color: Colors.black),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).highlightColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 1))
                                    // changes position of shadow
                                  ],
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      isExpanded: true,
                                      value: initValue,
                                      icon: const Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                      items: itemList.map((String items) {
                                        return DropdownMenuItem(
                                            value: items, child: Text(items));
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          initValue = newValue!;
                                        });
                                      }),
                                ),
                              ),
                              //article
                              const SizedBox(
                                height: 20,
                              ),
                              const Divider(
                                  color:
                                      ColorResources.NAVIGATION_DIVIDER_COLOR),
                              Text(
                                getTranslated('ORGANIZATION', context),
                                style: poppinsBold.copyWith(
                                    fontSize: 20, color: Colors.teal),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                  color:
                                      ColorResources.NAVIGATION_DIVIDER_COLOR),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                getTranslated('TOPICS', context),
                                style: poppinsBold.copyWith(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Text(
                                getTranslated('TOPICS_TITLE', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: 12, color: Colors.black),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).highlightColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 1))
                                    // changes position of shadow
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getTranslated('MANAGE', context),
                                          style: poppinsRegular.copyWith(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        Image.asset(
                                          Images.icon_double_forward,
                                          height: 40,
                                          width: 40,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ).onTap(_onContentClick),
                              const SizedBox(
                                height: 16,
                              ),
                              const Divider(
                                  color:
                                      ColorResources.NAVIGATION_DIVIDER_COLOR),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                getTranslated('WELCOME_CHECKLIST', context),
                                style: poppinsBold.copyWith(
                                    fontSize: 16, color: Colors.black),
                              ),
                              Text(
                                getTranslated(
                                    'WELCOME_CHECKLIST_TITLE', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: 12, color: Colors.black),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).highlightColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 1))
                                    // changes position of shadow
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getTranslated('MANAGE', context),
                                          style: poppinsRegular.copyWith(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        Image.asset(
                                          Images.icon_double_forward,
                                          height: 40,
                                          width: 40,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: Dimensions.MARGIN_SIZE_SMALL),
                                child: CustomButton(
                                    onTap: () {},
                                    buttonText:
                                        getTranslated('LEARN_MORE', context)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
