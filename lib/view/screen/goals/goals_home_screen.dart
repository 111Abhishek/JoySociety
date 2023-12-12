import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/screen/content/content_list_screen.dart';
import 'package:joy_society/view/screen/goals/accountibilityScreen/accountitbity_screen.dart';
import 'package:joy_society/view/screen/goals/goalsList/goals_list_screen.dart';
import 'package:joy_society/view/screen/goals/reflection1/goal_reflection1_screen.dart';
import 'package:joy_society/view/screen/members/memberList/members_list_screen.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/goal_list_response_model.dart';
import '../../../data/model/response/profile_model.dart';
import '../../../localization/language_constants.dart';
import '../../../provider/goal_provider.dart';
import '../../../provider/profile_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../basewidget/button/custom_button_secondary.dart';
import '../../basewidget/show_custom_snakbar.dart';
import '../subscription_screen/subscription_screen.dart';

class GoalsHomeScreen extends StatefulWidget {
  const GoalsHomeScreen({Key? key}) : super(key: key);

  @override
  State<GoalsHomeScreen> createState() => _GoalsHomeScreenState();
}

class _GoalsHomeScreenState extends State<GoalsHomeScreen> {
  GoalListResponseModel? pendingListModel;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProfileDetail();
      getPendingGoals();
    });

    super.initState();
  }

  getPendingGoals() async {
    pendingListModel = await Provider.of<GoalProvider>(context, listen: false)
        .getGoalsList(1, '', "In Progress", AppConstants.GOAL);
    setState(() {});
  }

  bool? isSubscribed;
  ProfileModel? profModel = ProfileModel();

  getProfileDetail() async {
    profModel = await Provider.of<ProfileProvider>(context, listen: false)
        .getProfileData();
    setState(() {
      isSubscribed = profModel!.isSubscribed == "Completed";
    });
  }

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  void _onContentClick() async {
    if (isSubscribed!) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ContentListScreen()));
    } else {
      _showCustomDialog(context, true);
    }
  }

  void _onMembersClick() async {
    if (isSubscribed!) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => MembersListScreen()));
    } else {
      _showCustomDialog(context, true);
    }
  }

  void _onAchievedGoalsClick() async {
    if (isSubscribed!) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => const GoalsListScreen(status: "Achieved")));
    } else {
      _showCustomDialog(context, true);
    }
  }

  void _onPendingGoalsClick() async {
    if (isSubscribed!) {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const GoalsListScreen(status: "In Progress")))
          .then((value) => getPendingGoals());
    } else {
      _showCustomDialog(context, true);
    }
  }

  void _onGoalCreateClick() async {
    if (isSubscribed!) {
      if (pendingListModel!.data!.length >= 2) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "You can't create more than 2 pending goals at a time",
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const GoalReflection1Screen()))
            .then((value) => getPendingGoals());
      }
    } else {
      _showCustomDialog(context, true);
    }
  }

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
              Text(getTranslated('GOALS', context),
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
                        // general setting
                        Container(
                          height: 100,
                          margin: const EdgeInsets.only(
                              top: 0, left: 16, right: 16),
                          decoration: const BoxDecoration(
                            color: ColorResources.SECONDARY_COLOR,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Image.asset(Images.icon_goal,
                                      height: 48,
                                      width: 48,
                                      color: Colors.white),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    getTranslated('SET_YOUR_GOALS', context),
                                    style: poppinsRegular.copyWith(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).onTap(_onGoalCreateClick),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 100,
                          margin: const EdgeInsets.only(
                              top: 0, left: 16, right: 16),
                          decoration: const BoxDecoration(
                            color: ColorResources.SECONDARY_COLOR,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Image.asset(Images.icon_in_progress_goals,
                                      height: 48,
                                      width: 48,
                                      color: Colors.white),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    getTranslated('PENDING_GOALS', context),
                                    style: poppinsRegular.copyWith(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).onTap(_onPendingGoalsClick),
                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          height: 100,
                          margin: const EdgeInsets.only(
                              top: 0, left: 16, right: 16),
                          decoration: const BoxDecoration(
                            color: ColorResources.SECONDARY_COLOR,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (isSubscribed!) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const AccountibilityCheckpointPage()));
                                  } else {
                                    _showCustomDialog(context, true);
                                  }
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Image.asset(Images.icon_review,
                                        height: 48,
                                        width: 48,
                                        color: Colors.white),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Text(
                                      'Accountability Checkpoint',
                                      style: poppinsRegular.copyWith(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 100,
                          margin: const EdgeInsets.only(
                              top: 0, left: 16, right: 16),
                          decoration: const BoxDecoration(
                            color: ColorResources.SECONDARY_COLOR,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Image.asset(Images.icon_achieved_goals,
                                      height: 65,
                                      width: 65,
                                      color: Colors.white),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    getTranslated('ACHIEVED_GOALS', context),
                                    style: poppinsRegular.copyWith(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).onTap(_onAchievedGoalsClick),

                        Container(
                          margin: const EdgeInsets.only(
                              top: 28, left: 16, right: 16),
                          child: Text(
                            "After 90 days review button showcase",
                            style: poppinsRegular.copyWith(
                                fontSize: 16,
                                color: ColorResources.TEXT_FORM_TEXT_COLOR),
                            textAlign: TextAlign.center,
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

  void _showCustomDialog(BuildContext context, bool isEvalPopUp) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // To prevent dismissing the dialog on tap outside
      builder: (BuildContext context) {
        return CustomDialog(
          isEvalPopUp: isEvalPopUp,
          onYesPressed: () {
            // Perform action for "Yes"
            Navigator.pop(context, true);
            isEvalPopUp
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SubscriptionScreen()))
                : Navigator.popUntil(context, (route) => route.isFirst);
          },
          onNoPressed: () {
            // Perform action for "No"
            Navigator.pop(context, false);
          },
          onClosePressed: () {
            // Perform action for "Close"
            Navigator.pop(context);
          },
        );
      },
    ).then((value) {
      // You can handle the result returned from the dialog here if needed
      if (value != null && value == true) {
        // User selected "Yes"
        // Do something
      } else if (value != null && value == false) {
        // User selected "No"
        // Do something else
      } else {
        // User closed the dialog
        // Do nothing or handle any other actions
      }
    });
  }
}

class CustomDialog extends StatelessWidget {
  final bool? isEvalPopUp;
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;
  final VoidCallback onClosePressed;

  CustomDialog(
      {required this.onYesPressed,
      required this.onNoPressed,
      required this.onClosePressed,
      this.isEvalPopUp});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClosePressed,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              isEvalPopUp!
                  ? "You're making progress! Upgrade to a premium membership now to take the next step to holistic success."
                  : 'Are you sure want to Visit home page?',
              style: poppinsBold.copyWith(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: isEvalPopUp!
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceEvenly,
            children: [
              Visibility(
                visible: !isEvalPopUp!,
                child: CustomButtonSecondary(
                  bgColor: ColorResources.DARK_GREEN_COLOR,
                  textColor: ColorResources.WHITE,
                  isCapital: false,
                  height: 45,
                  buttonText: "No",
                  onTap: onClosePressed,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              CustomButtonSecondary(
                  bgColor: ColorResources.DARK_GREEN_COLOR,
                  textColor: ColorResources.WHITE,
                  isCapital: false,
                  height: 45,
                  buttonText: isEvalPopUp! ? "Ok" : "Yes",
                  onTap: onYesPressed),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
