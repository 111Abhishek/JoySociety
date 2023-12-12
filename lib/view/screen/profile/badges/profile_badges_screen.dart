import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/user_profile/badges/user_profile_badge_list_model.dart';
import 'package:joy_society/data/model/response/user_profile/badges/user_profile_badge_model.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/basewidget/no_internet_screen.dart';
import 'package:joy_society/view/screen/profile/badges/widgets/profile_badge_card.dart';
import 'package:provider/provider.dart';

import '../../../../utill/custom_themes.dart';
import '../../../../utill/images.dart';

class ProfileBadgeScreen extends StatefulWidget {
  const ProfileBadgeScreen({super.key});

  @override
  State<ProfileBadgeScreen> createState() => _ProfileBadgeScreenState();
}

class _ProfileBadgeScreenState extends State<ProfileBadgeScreen> {
  List<UserProfileBadgeModel> userBadges = [];

  /// For going back from the page
 

  void init() async {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
            children: [
              CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Image.asset(
                Images.logo_with_name_image,
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 10),
              Text(
                "Badges",
                style: poppinsBold.copyWith(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: FutureBuilder<UserProfileBadgeListModel>(
              future: Provider.of<ProfileProvider>(context, listen: false)
                  .getUserBadges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // here the connection state is done, check for data
                  if (snapshot.hasData) {
                    if (snapshot.data!.data != null &&
                        snapshot.data!.data!.isNotEmpty) {
                      // here we will be populating the data
                      // will be returning the builder
                      userBadges = snapshot.data!.data!;

                      return Container(
                          padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 32),
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 1 / 1.2,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20),
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: userBadges.length,
                              itemBuilder: (context, index) => ProfileBadgeCard(
                                    badgeModel: userBadges[index],
                                  )));
                    } else {
                      return const Center(
                          child:
                              Text("You have acquired no badges as of now!"));
                    }
                  } else {
                    return const Center(
                        child: Text("Something wrong happened at the server!"));
                  }
                }
                return Loader();
              })),
    );
  }
}
