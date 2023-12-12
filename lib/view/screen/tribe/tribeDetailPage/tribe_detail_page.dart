import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/utill/common_helper_fn.dart';
import 'package:joy_society/view/screen/tribe/tribeEvents/tribe_events.dart';
import 'package:provider/provider.dart';
import '../../../../data/model/response/event_model.dart';
import '../../../../data/model/response/tribe_model.dart';
import '../../../../provider/tribe_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dropdown.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/button/custom_button_secondary.dart';
import '../../../basewidget/web_view_screen.dart';
import '../../event/chat_screeens/event_chat_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../tribeFeed/tribe_feed.dart';
import '../tribeMemberScreen/tribes_member.dart';
import '../tribe_chat_helper_screen/event_chat_screen.dart';

class TribeDetailPage extends StatefulWidget {
  final TribeModel? tribeObj;

  TribeDetailPage({super.key, this.tribeObj});

  @override
  State<TribeDetailPage> createState() => _TribeDetailPageState();
}

class _TribeDetailPageState extends State<TribeDetailPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int? activeTab = 0;

  ProfileModel? profileModel;

  @override
  void initState() {
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: activeTab!);
    _tabController?.addListener(_onTabChanged);

    getProfileDetail();
    super.initState();
  }

  getProfileDetail() async {
    profileModel =
        Provider.of<ProfileProvider>(context, listen: false).profileModel;
  }

  void _onTabChanged() async {
    if (activeTab != _tabController!.index) {
      activeTab = _tabController!.index;

      switch (activeTab) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Container(
             
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              margin: const EdgeInsets.only(top: 0, left: 16, right: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: ColorResources.GRAY_BUTTON_BG_COLOR)),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder,
                          fit: BoxFit.cover,
                          image: widget.tribeObj!.tribe_url!,
                          imageErrorBuilder: (c, o, s) => Image.asset(
                            Images.logo_with_name_image,
                            fit: BoxFit.cover,
                          ),
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       Helper.getDateTime(widget.tribeObj!.start_datetime),
                    //       style: poppinsBold.copyWith(
                    //           fontSize: 14,
                    //           color: ColorResources.DARK_GREEN_COLOR),
                    //     ),
                    //     Text(
                    //       "-",
                    //       style: poppinsBold.copyWith(
                    //           fontSize: 14,
                    //           color: ColorResources.DARK_GREEN_COLOR),
                    //     ),
                    //     Text(
                    //       Helper.getDateTime(widget.tribeObj!.end_datetime),
                    //       style: poppinsBold.copyWith(
                    //           fontSize: 14,
                    //           color: ColorResources.DARK_GREEN_COLOR),
                    //     ),
                    //   ],
                    // ),
                    Text(
                      widget.tribeObj!.title!,
                      style: poppinsBold.copyWith(
                          fontSize: 22, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.tribeObj!.tagline!,
                      style: poppinsRegular.copyWith(
                          fontSize: 14, color: ColorResources.textPrimaryColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(bottom: 20),
                    //     child: Dropdown(
                    //       height: 50,
                    //       containerColor: ColorResources.DARK_GREEN_COLOR,
                    //       // height: 35,
                    //       //width: 50,
                    //       dropdownValue: dropDownCtrl.text,
                    //       item: const [
                    //         "RSVP",
                    //         "Maybe",
                    //         "Going",
                    //         "NotGoing"
                    //       ],
                    //       title: "",
                    //       onChanged: (newValue) {
                    //         setState(() {
                    //           dropDownCtrl.text = newValue;
                    //         });
                    //       },
                    //     ),
                    //   ),
                    // ),
                    //     const SizedBox(
                    //       width: 15,
                    //     ),
                    //     Expanded(
                    //       child: CustomButtonSecondary(
                    //         bgColor: ColorResources.DARK_GREEN_COLOR,
                    //         textColor: ColorResources.WHITE,
                    //         isCapital: false,
                    //         height: 50,
                    //         buttonText: "Join Now",
                    //         onTap: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (_) => WebViewScreen(
                    //                         url: widget.tribeObj!.zoom_link,
                    //                       )));
                    //         },
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: 15,
                    //     ),
                    //     Expanded(
                    //       child: CustomButtonSecondary(
                    //         bgColor: ColorResources.DARK_GREEN_COLOR,
                    //         textColor: ColorResources.WHITE,
                    //         isCapital: false,
                    //         height: 50,
                    //         buttonText: "Invite",
                    //         onTap: () async {
                    //           _onShare(context);
                    //           await Clipboard.setData(ClipboardData(
                    //               text: widget.tribeObj!.zoom_link!));
        
                    //           // copied successfully
                    //         },
                    //       ),
                    //     )
                    //   ],
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    TabBar(
                      controller: _tabController,
                      labelColor: ColorResources.DARK_GREEN_COLOR,
                      unselectedLabelColor: ColorResources.GRAY_TEXT_COLOR,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: ColorResources.DARK_GREEN_COLOR,
                      tabs: const [
                        Tab(
                          child: Text(
                            'Feed',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Member',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Chat',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Events in Tribe',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ])),
          // const SizedBox(
          //   height: 15,
          // ),
          Expanded(
            child: SingleChildScrollView(
                primary: true,
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  margin: const EdgeInsets.only(top: 0, left: 16, right: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: MediaQuery.of(context).size.height *
                      0.63, // Set the desired height for the scrollable area
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      FeedScreen(
                        tribeObj: widget.tribeObj,
                        userProfile: profileModel,
                      ),
                      TribeMembersScreen(
                        tribeId: widget.tribeObj!.id!,
                      ),
                      TribeChatScreen(
                        isfromEvent: false,
                        id: widget.tribeObj!.id!,
                      ),
                      TribeEventList(
                        tribalId: widget.tribeObj!.id!,
                      )
                      // ChatScreen()
                      // MessagingScreen(),
                    ],
                  ),
                )),
          )
        ]),
      ),
    );
  }
}
