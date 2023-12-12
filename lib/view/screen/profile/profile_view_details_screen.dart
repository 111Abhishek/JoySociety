import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joy_society/data/model/response/member_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/js_data_provider.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';
import 'package:joy_society/view/screen/profile/adapter/list_profile_event_adapter.dart';

class ProfileViewDetailsScreen extends StatefulWidget {
  const ProfileViewDetailsScreen({super.key});

  @override
  ProfileViewDetailsScreenState createState() =>
      ProfileViewDetailsScreenState();
}

class ProfileViewDetailsScreenState extends State<ProfileViewDetailsScreen> {
  void onItemClick(int index, MemberModel obj) {
    //Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileViewDetailsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    List<MemberModel> items = getPeopleData();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        title: const Text(""),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(0),
              color: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 72,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage(Images.icon_person),
                    ),
                  ),
                  Container(height: 8),
                  Text("Damian Johnsonn",
                      style: poppinsBold.copyWith(
                          color: Colors.white, fontSize: 16)),
                  Text("Last active 3w ago",
                      style: poppinsRegular.copyWith(
                          color: Colors.white, fontSize: 12)),
                  Text("· 1 Post  · 0  Followers · 3  Following",
                      style: poppinsRegular.copyWith(
                          color: Colors.white, fontSize: 12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.MARGIN_SIZE_DEFAULT,
                                vertical: Dimensions.MARGIN_SIZE_SMALL),
                            child: CustomButtonSecondary(
                              onTap: () {},
                              buttonText: getTranslated('ACTIVITY', context),
                              borderColor: Colors.white,
                              textColor: Colors.white,
                              textStyle: poppinsRegular,
                              bgColor: Theme.of(context).primaryColor,
                              fontSize: 14,
                              height: 40,
                            ),
                          ),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.MARGIN_SIZE_DEFAULT,
                                vertical: Dimensions.MARGIN_SIZE_SMALL),
                            child: CustomButtonSecondary(
                              onTap: () {
                                //_updateTopicDetails();
                              },
                              buttonText: getTranslated('FOLLOW', context),
                              borderColor: Colors.white,
                              textColor: Colors.white,
                              textStyle: poppinsRegular,
                              bgColor: Theme.of(context).primaryColor,
                              fontSize: 14,
                              height: 40,
                            ),
                          ),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.MARGIN_SIZE_DEFAULT,
                                vertical: Dimensions.MARGIN_SIZE_SMALL),
                            child: CustomButtonSecondary(
                              onTap: () {
                                //_updateTopicDetails();
                              },
                              buttonText: getTranslated('CHAT_TITLE', context),
                              borderColor: Colors.white,
                              textColor: Colors.white,
                              textStyle: poppinsRegular,
                              bgColor: Theme.of(context).primaryColor,
                              fontSize: 14,
                              height: 40,
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Referred By",
                    style: poppinsBold.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: Dimensions.MARGIN_SIZE_SMALL),
                        child: CustomButtonSecondary(
                          onTap: () {},
                          buttonText: 'Elizabeth Joy',
                          borderColor: ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                          textColor: ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                          bgColor: Colors.white,
                          textStyle: poppinsRegular,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 8),
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Workshops",
                    style: poppinsBold.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: Dimensions.MARGIN_SIZE_SMALL),
                        child: CustomButtonSecondary(
                          onTap: () {},
                          buttonText: 'TRU Success: Part 1',
                          borderColor: ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                          textColor: ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                          bgColor: Colors.white,
                          textStyle: poppinsRegular,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: Dimensions.MARGIN_SIZE_SMALL),
                        child: CustomButtonSecondary(
                          onTap: () {},
                          buttonText: 'Let’s Talk About “The Apps”',
                          borderColor: ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                          textColor: ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                          bgColor: Colors.white,
                          textStyle: poppinsRegular,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tribes",
                    style: poppinsBold.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: Dimensions.MARGIN_SIZE_SMALL),
                        child: CustomButtonSecondary(
                          onTap: () {},
                          buttonText: 'Tribes',
                          borderColor: ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                          textColor: ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                          bgColor: Colors.white,
                          textStyle: poppinsRegular,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Events",
                    style: poppinsBold.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  ListProfileEventAdapter(items, onItemClick).getView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
