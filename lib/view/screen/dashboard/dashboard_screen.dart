import 'dart:convert';
import 'dart:ui';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:joy_society/data/model/js_model.dart';
import 'package:joy_society/data/model/notification/notification_model.dart';
import 'package:joy_society/data/model/response/notification/notification_response_list_model.dart';
import 'package:joy_society/data/model/response/notification/notification_response_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/notification/pie_socket_notification.dart';
import 'package:joy_society/provider/auth_provider.dart';
import 'package:joy_society/provider/main_provider.dart';
import 'package:joy_society/provider/notification_provider.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/js_data_provider.dart';
import 'package:joy_society/utill/shared_prefs.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/screen/auth/auth_screen.dart';
import 'package:joy_society/view/screen/createPost/longPost/long_post_screen.dart';
import 'package:joy_society/view/screen/createPost/questionsAndPolls/questions_and_polls_screen.dart';
import 'package:joy_society/view/screen/createPost/quickPost/quick_post_screen.dart';
import 'package:joy_society/view/screen/createPost/quickPost/widget/post_bottom_sheet_widget.dart';
import 'package:joy_society/view/screen/event/eventList/event_list_screen.dart';
import 'package:joy_society/view/screen/goals/goals_home_screen.dart';
import 'package:joy_society/view/screen/home/home_feed_screen.dart';
import 'package:joy_society/view/screen/members/manageMembers/manage_members_screen.dart';
import 'package:joy_society/view/screen/notification/notification_screen.dart';
import 'package:joy_society/view/screen/plans/planList/plan_list_screen.dart';
import 'package:joy_society/view/screen/subscription_screen/subscription_screen.dart';
import 'package:joy_society/view/screen/topic/topicList/select_topic.dart';
import 'package:joy_society/view/screen/topic/topicList/topics_list_screen.dart';
import 'package:joy_society/view/screen/tribe/tribeManage/tribe_manage_screen.dart';
import 'package:joy_society/view/screen/workshop/workshipsList/workshops_list_screen.dart';
import 'package:piesocket_channels/channels.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart';

import '../../../data/model/response/chat_response.dart' as chatResponse;
import '../../../data/model/response/profile_model.dart';
import '../../../provider/profile_provider.dart';
import '../../../utill/app_constants.dart';
import '../tribe/tribe_list_screen.dart';

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key? key}) : super(key: key);
  static String tag = '/DashBoardScreen';

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  int selectedIndex = 2;
  bool _isProfileMenuSettingVisible = false;
  String? userName;
  String? subscription;
  String? profileImageUrl;
  static int newNotifications = 0;
  bool showNotifications = false;
  NotificationResponseListModel notifications = NotificationResponseListModel();
  List<NotificationResponseModel> unreadNotifications = [];
  List<NotificationResponseModel> readNotifications = [];

  SharedPrefs prefs = SharedPrefs();
  bool newNotificationAdded = false;

  List<DrawerItemModel> mDrawerList = getDrawerItems();
  List<DrawerItemModel> mProfileSettingMenuList = getProfileMenuSettingItems();

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProfileModel? profModel = ProfileModel();

  // will be holding the notificationItems
  static List<String> notificationItems = [];

  void showProfileMenuSetting() {
    setState(() {
      _isProfileMenuSettingVisible = !_isProfileMenuSettingVisible;
    });
  }

  void updateNotifications(updatedNotifications) async {
    await prefs.setNotificationItems(updatedNotifications);
    print(updatedNotifications);
  }

  PieSocketNotification socketNotification = PieSocketNotification(
      apiKey: AppConstants.pieSocketApiKey,
      clusterId: AppConstants.pieSocketClusterId,
      roomId: AppConstants.pieSocketRoomId);

  void listenForNotifications() {
    Channel channel = socketNotification.channel!;

    channel.listen("system:message", (PieSocketEvent event) {
      NotificationModel notification =
          NotificationModel.fromJson(json.decode(event.toString()));

      if (notification.data?.event != "system:boot") {
        getNotifications();
        setState(() {
          // notificationItems = updatedNotifications;
          newNotificationAdded = true;
          newNotifications = newNotifications + 1;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  getNotifications() async {
    notifications =
        await Provider.of<NotificationProvider>(context, listen: false)
            .getNotifications();
    setState(() {
      unreadNotifications = notifications.results
          .where((element) => !element.readStatus!)
          .toList();
      readNotifications = notifications.results
          .where((element) => element.readStatus!)
          .toList();
    });
  }

  init() async {
    //setStatusBarColor(fa_color_primary);
    getMemberContent();
    listenForNotifications();
    await getProfileData();
    await getNotifications();
  }

  getProfileData() async {
    ProfileModel? profile =
        await Provider.of<ProfileProvider>(context, listen: false)
            .getProfileData();

    if (profile != null) {
      setState(() {
        userName = profile.fullName ?? "";
        profileImageUrl = profile.profilePic ?? "";
        subscription = profile.isSubscribed ?? '';
      });
    } else {
      Provider.of<ProfileProvider>(context, listen: false)
          .getProfileData()
          .then((value) => {
                if (value != null)
                  {
                    setState(() {
                      userName = value.fullName ?? "";
                      profileImageUrl = value.profilePic ?? "";
                      subscription = profile?.isSubscribed ?? '';
                    })
                  }
              });
    }
  }

  String getProfileImage() {
    return Provider.of<ProfileProvider>(context, listen: false)
            .profileModel
            ?.profilePic ??
        (profileImageUrl ?? "");
  }

  String getProfileName() {
    return Provider.of<ProfileProvider>(context, listen: false)
            .profileModel
            ?.fullName ??
        (userName ?? "Robert");
  }

  getProfileDetail() async {
    ProfileModel? existingProfileModel =
        Provider.of<ProfileProvider>(context, listen: false).profileModel;
    String currentUserName = "";
    if (existingProfileModel != null) {
      currentUserName = existingProfileModel.fullName ?? "";
    } else {
      profModel = await Provider.of<ProfileProvider>(context, listen: false)
          .getProfileData();
      currentUserName = profModel!.fullName ?? "";
    }

    setState(() {
      userName = currentUserName;
    });
    // await getProfileData();
  }

  getMemberContent() async {
    await Provider.of<MainProvider>(context, listen: false).getMemberContent();
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body!.text).documentElement!.text;

    return parsedString;
  }

  @override
  void dispose() {
    //setStatusBarColor(fa_color_secondary);
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {});
    selectedIndex = index;
    if (selectedIndex == 2) {
      //_createPost();
      _bottomPost();
    }
  }

  void _bottomPost() {
    showModalBottomSheet<int>(
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        //for bottom post
        return PostBottomSheetWidget(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuickPostScreen()),
                      );
                    },
                    child: _buildListItem(
                      context,
                      title: Text(
                        getTranslated('QUICK_POST', context),
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  _buildListItem(
                    context,
                    title: Text(
                      getTranslated('LONG_POST', context),
                      style: poppinsRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                          color: Colors.black),
                    ),
                  ).onTap(() {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LongPostScreen()),
                    );
                  }),
                  // _buildListItem(
                  //   context,
                  //   title: Text(
                  //     getTranslated('ARTICLE', context),
                  //     style: poppinsRegular.copyWith(
                  //         fontSize: Dimensions.FONT_SIZE_LARGE,
                  //         color: Colors.black),
                  //   ),
                  // ),
                  _buildListItem(
                    context,
                    title: Text(
                      getTranslated('QUESTION_POLL', context),
                      style: poppinsRegular.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                          color: Colors.black),
                    ),
                  ).onTap(() {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuestionsAndPollsScreen()),
                    );
                  }),
                  // _buildListItem(
                  //   context,
                  //   title: Text(
                  //     getTranslated('EVENT', context),
                  //     style: poppinsRegular.copyWith(
                  //         fontSize: Dimensions.FONT_SIZE_LARGE,
                  //         color: Colors.black),
                  //   ),
                  // ).onTap(() {
                  //   Navigator.of(context).pop();
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const EventListScreen()),
                  //   );
                  // }),
                  // _buildListItem(
                  //   context,
                  //   title: Text(
                  //     getTranslated('TOPIC', context),
                  //     style: poppinsRegular.copyWith(
                  //         fontSize: Dimensions.FONT_SIZE_LARGE,
                  //         color: Colors.black),
                  //   ),
                  // ),
                  // _buildListItem(
                  //   context,
                  //   title: Text(
                  //     getTranslated('TRIBE', context),
                  //     style: poppinsRegular.copyWith(
                  //         fontSize: Dimensions.FONT_SIZE_LARGE,
                  //         color: Colors.black),
                  //   ),
                  // ).onTap(() {
                  //   Navigator.of(context).pop();
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const TribeListScreen()),
                  //   );
                  // }),
                  // GestureDetector(
                  //   onTap: () {
                  //     /*Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => const QuickPostScreen()),
                  //     );*/
                  //   },
                  //   child: _buildListItem(
                  //     context,
                  //     title: Text(
                  //       getTranslated('WORK_SHOP', context),
                  //       style: poppinsRegular.copyWith(
                  //           fontSize: Dimensions.FONT_SIZE_LARGE,
                  //           color: Colors.black),
                  //     ),
                  //   ),
                  // )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildListItem(
    BuildContext context, {
    Widget? title,
    Widget? leading,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: 10.0,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorResources.NAVIGATION_DIVIDER_COLOR,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (leading != null) leading,
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: DefaultTextStyle(
                style: poppinsRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.black),
                child: title,
              ),
            ),
          const Spacer(),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  List<Widget> widgetOptions = <Widget>[
    SelectTopic(didComeFromHomeScreen: true),
    const EventListScreen(),
    HomeFeedScreen(),
    TribeListScreen(),
    const WorkshopsListScreen(didComeFromHomeScreen: true),
  ];

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: ColorResources.BLACK),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Images.joy_society_logo,
              width: 150,
            ),
          ],
        ).onTap(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      DashBoardScreen(key: GlobalKey<ScaffoldState>())));
        }),
        backgroundColor: ColorResources.WHITE,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                // await getNotifications();
                setState(() {
                  newNotificationAdded = false;
                  newNotifications = 0;
                  showNotifications = !showNotifications;
                });
              },
              icon: !newNotificationAdded
                  ? const Icon(Icons.notifications, color: Colors.black87)
                  : Badge(
                      label: Text(
                        "$newNotifications",
                        style: poppinsRegular.copyWith(
                            fontSize: 10, color: ColorResources.WHITE),
                      ),
                      child: const Icon(Icons.notifications,
                          color: Colors.black87)))
        ],
      ),
      body: Stack(
        children: [
          widgetOptions.elementAt(selectedIndex),
          if (showNotifications)
            NotificationScreen(
              notifications: notifications,
              unreadNotifications: unreadNotifications,
              readNotifications: readNotifications,
            )
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle,
        backgroundColor: ColorResources.DARK_GREEN_COLOR,
        activeColor: Colors.white,
        height: 60,
        color: Colors.white,
        items: [
          TabItem(
            icon: Image.asset(Images.icon_tab_topic),
            //activeIcon: Image.asset(Images.icon_tab_topic_active, color: ColorResources.DARK_GREEN_COLOR,),
            title: 'Topic',
          ),
          TabItem(
            icon: Image.asset(Images.icon_tab_events),
            //activeIcon: Image.asset(Images.icon_tab_events_active, color: ColorResources.DARK_GREEN_COLOR,),
            title: 'Events',
          ),
          TabItem(
              icon: Image.asset(
                Images.icon_tab_close,
              ),
              //activeIcon: Image.asset(Images.icon_tab_close, ),
              isIconBlend: false),
          TabItem(
              icon: Image.asset(Images.icon_tab_tribes),
              //activeIcon: Image.asset(Images.icon_tab_tribes_active, color: ColorResources.DARK_GREEN_COLOR,),
              title: 'Tribes'),
          TabItem(
              icon: Image.asset(Images.icon_tab_workshop),
              //activeIcon: Image.asset(Images.icon_tab_workshop_active, color: ColorResources.DARK_GREEN_COLOR,),
              title: 'Workshop'),
        ],
        initialActiveIndex: selectedIndex,
        onTap: (int i) {
          onItemTapped(i);
        },
      ),
      drawer: Drawer(
        elevation: 0,
        backgroundColor: _isProfileMenuSettingVisible
            ? ColorResources.SECONDARY_COLOR
            : Colors.white,
        //backgroundColor: Colors.transparent,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 130,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: ColorResources.SECONDARY_COLOR,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(38)),
                    ),
                    margin: const EdgeInsets.all(0),
                    child: GestureDetector(
                      onTap: () {
                        showProfileMenuSetting();
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Visibility(
                                visible: _isProfileMenuSettingVisible,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios_outlined,
                                    color: Theme.of(context).cardColor,
                                  ),
                                  onPressed: () {
                                    showProfileMenuSetting();
                                  },
                                ),
                              ),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: Images.placeholder,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    image: getProfileImage(),
                                    imageErrorBuilder: (c, o, s) => Image.asset(
                                        Images.placeholder,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover),
                                  )),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Hi ${getProfileName()}',
                                      style: poppinsBold.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_LARGE,
                                          color: Colors.black)),
                                  const SizedBox(width: 8),
                                  Text('View your profile',
                                      style: poppinsRegular.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL,
                                          color: Colors.white)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    /*child:Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_outlined,
                            color: Theme.of(context).cardColor,
                          ),
                          onPressed: () {},
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(left: 16, top: 16),
                          leading: CircleAvatar(
                              backgroundImage: AssetImage(Images.profile_image),
                              radius: 30),
                          title: Text('Hi Robert',
                              style: poppinsBold.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_LARGE,
                                  color: Colors.black)),
                          subtitle: Text('View your profile',
                              style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL,
                                  color: Colors.white)),
                          onTap: () {
                            //NBProfileScreen().launch(context);
                            showProfileMenuSetting();
                          },
                        ),
                      ],
                    ),*/
                  ),
                ),
                Visibility(
                  visible: !_isProfileMenuSettingVisible,
                  child: Container(
                    color: ColorResources.PALE_GRAY_COLOR,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: mDrawerList.map((e) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.title!,
                                        style: poppinsRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_LARGE))
                                    .paddingAll(4),
                                const Divider(
                                    color: ColorResources
                                        .NAVIGATION_DIVIDER_COLOR),
                              ],
                            ).onTap(() {
                              if (Navigator.canPop(context))
                                Navigator.pop(context);
                              if (e.title == "Home") {
                              } else if (e.title == "Goal Setting") {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const GoalsHomeScreen()));
                              } else if (e.title == "Workshops") {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const WorkshopsListScreen(
                                          didComeFromHomeScreen: false,
                                        )));
                              } else if (e.title == "Events") {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const EventListScreen()));
                              } else if (e.title == "Tribes") {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        TribeListScreen()));
                              } else if (e.title == "Plans") {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const PlanListScreen()));
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => e.widget!));
                              }
                              if (_scaffoldKey.currentState!.isDrawerOpen!) {
                                _scaffoldKey.currentState!.openEndDrawer();
                              }
                            });
                          }).toList(),
                        ).paddingAll(8),
                        Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: subscription == "Completed"
                                ? AbsorbPointer(
                                    child: CustomButton(
                                        buttonText: 'SUBSCRIBED', onTap: () {}),
                                  )
                                : CustomButton(
                                    buttonText:
                                        getTranslated('SUBSCRIPTION', context),
                                    onTap: () {
                                      // Calling SubsCription Screen
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SubscriptionScreen()))
                                          .then((value) => getProfileData());
                                    }))
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _isProfileMenuSettingVisible,
                  child: Container(
                    color: ColorResources.SECONDARY_COLOR,
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: mProfileSettingMenuList.map((e) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.title!,
                                        style: poppinsRegular.copyWith(
                                            fontSize:
                                                Dimensions.FONT_SIZE_LARGE,
                                            color: ColorResources.WHITE))
                                    .paddingAll(4),
                                const Divider(
                                    color: ColorResources
                                        .CUSTOM_TEXT_BORDER_COLOR),
                              ],
                            ).onTap(() {
                              if (e.title == "Home") {
                                if (Navigator.canPop(context))
                                  Navigator.pop(context);
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => e.widget!));
                              }
                              if (_scaffoldKey.currentState!.isDrawerOpen!) {
                                _scaffoldKey.currentState!.openEndDrawer();
                              }
                            });
                          }).toList(),
                        ).paddingAll(8),
                        const SizedBox(
                          height: 24,
                        ),
                        InkWell(
                          onTap: () {
                            print('Logout button clicked');
                            Provider.of<AuthProvider>(context, listen: false)
                                .logout();
                            while (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AuthScreen()));
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Logout',
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: ColorResources.WHITE),
                                ).paddingOnly(left: 4)
                              ],
                            ).paddingOnly(left: 8),
                          ),
                        ).paddingAll(8),
                        InkWell(
                          onTap: () {
                            print('Account Deleted');
                            Provider.of<AuthProvider>(context, listen: false)
                                .logout();
                            while (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AuthScreen()));
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Delete Account',
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      color: ColorResources.WHITE),
                                ).paddingOnly(left: 4)
                              ],
                            ).paddingOnly(left: 8),
                          ),
                        ).paddingAll(8)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'CLOSE',
          onPressed: scaffold.hideCurrentSnackBar,
        )));
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 20;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 40;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(fontSize: 12, color: color);
  }
}
