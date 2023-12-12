import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/members_followers_model.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/member_response_model.dart';
import '../../../../data/model/response/members_followers.dart';
import '../../../../provider/members_follwers_provider.dart';
import '../../../../utill/custom_themes.dart';
import '../../../basewidget/loader_widget.dart';

class MemberProfilePage extends StatefulWidget {
  final Result? memberResp;
  final FollowingModel? followersResponse;
  const MemberProfilePage({super.key, this.memberResp, this.followersResponse});

  @override
  State<MemberProfilePage> createState() => _MemberProfilePageState();
}

class _MemberProfilePageState extends State<MemberProfilePage> {
  String? localFollow;
  MemberResponseModel? _memberDetailResponse;
  @override
  void initState() {
    localFollow = widget.followersResponse!.results!
            .any((element) => element.id == widget.memberResp!.userId)
        ? "Unfollow"
        : "Follow";
    _callApi();
    super.initState();
  }

  _callApi() async {
    _memberDetailResponse =
        await Provider.of<MemberFollowerProvider>(context, listen: false)
            .getMemberInfo(widget.memberResp!.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
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
              "Members Detail Screen",
              style: poppinsBold.copyWith(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: ColorResources.WHITE,
      ),
      body: _memberDetailResponse == null
          ? Center(child: Loader().visible(_memberDetailResponse == null))
          : SingleChildScrollView(
              child: Container(
                color: ColorResources.APP_BACKGROUND_COLOR,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(
                            "assets/images/members_background.jpeg",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          color: ColorResources.WHITE,
                          child: Row(
                            children: [
                              const Align(
                                alignment: Alignment.bottomCenter,
                                child: FractionalTranslation(
                                  translation: Offset(0.0, -0.2),
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundColor: ColorResources.GREEN,
                                    backgroundImage: AssetImage(
                                        Images.instructor_placeholder),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_memberDetailResponse!.fullName}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          "${_memberDetailResponse!.followerCount}\nFollowers",
                                          style: const TextStyle(
                                              color: ColorResources
                                                  .textPrimaryColor),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${_memberDetailResponse!.followingCount}\nFollowing",
                                          style: const TextStyle(
                                              color: ColorResources
                                                  .textPrimaryColor),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${_memberDetailResponse!.numberOfJoinedTribes}\nTribes",
                                          style: const TextStyle(
                                              color: ColorResources
                                                  .textPrimaryColor),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${_memberDetailResponse!.numberOfJoinedWorkshops}\nWorkshop",
                                          style: const TextStyle(
                                              color: ColorResources
                                                  .textPrimaryColor),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorResources
                                                .APP_BACKGROUND_COLOR,
                                          ),
                                          onPressed: () {},
                                          child: const Text(
                                            "Activity",
                                            style: TextStyle(
                                                color: ColorResources.GREEN),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorResources
                                                .APP_BACKGROUND_COLOR,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (localFollow == "Follow") {
                                                localFollow = "Unfollow";
                                                // Perform the follow action here, and you can update the followersResponse accordingly
                                                Provider.of<MemberFollowerProvider>(
                                                        context,
                                                        listen: false)
                                                    .follow(
                                                        widget.memberResp!
                                                            .userId!,
                                                        true);
                                              } else {
                                                localFollow = "Follow";
                                                // Perform the unfollow action here, and you can update the followersResponse accordingly
                                                Provider.of<MemberFollowerProvider>(
                                                        context,
                                                        listen: false)
                                                    .follow(
                                                        widget.memberResp!
                                                            .userId!,
                                                        false);
                                              }
                                            });
                                          },
                                          child: Text(
                                            localFollow!,
                                            style: const TextStyle(
                                                color: ColorResources.GREEN),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorResources
                                                .APP_BACKGROUND_COLOR,
                                          ),
                                          onPressed: () {},
                                          child: const Text(
                                            "Chat",
                                            style: TextStyle(
                                                color: ColorResources.GREEN),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Profile Picture

                        // User Information
                        Container(
                         
                          width: MediaQuery.of(context).size.width,
                          color: ColorResources.WHITE,
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const Text(
                                //   'About me',
                                //   style: TextStyle(
                                //     fontSize: 22,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                // Text(
                                //   "${_memberDetailResponse!.miniBio}",
                                //   style: const TextStyle(
                                //     color: ColorResources.textPrimaryColor,
                                //     fontSize: 16,
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 20,
                                // ),
                                Text(
                                  'Badges',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'I am New Here',
                                  style: TextStyle(
                                    color: ColorResources.textPrimaryColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          color: ColorResources.WHITE,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tribes',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color:
                                            ColorResources.APP_BACKGROUND_COLOR,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      child: const Text(
                                        'Getting started:N',
                                        style: TextStyle(
                                          color:
                                              ColorResources.textPrimaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color:
                                            ColorResources.APP_BACKGROUND_COLOR,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      child: const Text(
                                        'How To Finally Escape',
                                        style: TextStyle(
                                          color:
                                              ColorResources.textPrimaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: ColorResources.APP_BACKGROUND_COLOR,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: const Text(
                                    'Diet Culture',
                                    style: TextStyle(
                                      color: ColorResources.textPrimaryColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    ));
  }
}
