import 'dart:developer';
import 'dart:math' as math;

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/data/model/response/workshop_feed_response_model.dart';
import 'package:joy_society/data/model/response/workshop_model.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/provider/tribe_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/web_view_screen.dart';
import 'package:joy_society/view/screen/workshop/workshopFeed/widgets/post_like_widget.dart';
import 'package:joy_society/view/screen/workshop/workshopFeed/widgets/workshop_feed_post.dart';
import 'package:joy_society/view/screen/workshop/workshopPost/workshop_long_post_screen.dart';
import 'package:joy_society/view/screen/workshop/workshopPost/workshop_quick_post_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data/model/response/create_post_model.dart';
import '../../../../data/model/response/tribe_model.dart';
import '../../../../localization/language_constants.dart';
import '../../../../provider/post_provider.dart';
import '../../../../utill/app_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/widgets.dart';
import '../../createPost/longPost/long_post_screen.dart';
import '../../createPost/questionsAndPolls/questions_and_polls_screen.dart';
import '../../createPost/quickPost/quick_post_screen.dart';
import '../../createPost/quickPost/widget/post_bottom_sheet_widget.dart';

class WorkshopFeedScreen extends StatefulWidget {
  final WorkshopModel workshop;

  const WorkshopFeedScreen({super.key, required this.workshop});

  @override
  State<WorkshopFeedScreen> createState() => _WorkshopFeedScreenState();
}

class _WorkshopFeedScreenState extends State<WorkshopFeedScreen> {
  List<Result> data = [];
  List<TextEditingController> Cmtctrl = [];

  ProfileModel? userProfile;

  final ScrollController scrollController = new ScrollController();

  bool isLoading = false;
  bool isLastPage = false;
  SharedPreferences? sharedPreferences;
  bool load = false;
  int page = 1;

  int selectedIndex = -1;
  String searchText = '';
  String? userId;
  int? isCommetWidgetId;

  @override
  void initState() {
    _getId();
    _getFeed();

    super.initState();

    chatMessageFocusNode = FocusNode();
  }

  _getId() {
    // userId = sharedPreferences?.getString(AppConstants.USER_ID);
    // log(userId!);
  }

  _getFeed() async {
    WorkshopFeedResponse fulldata =
        await Provider.of<WorkshopProvider>(context, listen: false)
            .fetchWorkshopFeedList(page, widget.workshop.id);
    setState(() {
      data = fulldata.results!;
      userProfile =
          Provider.of<ProfileProvider>(context, listen: false).profileModel;
    });
    print("UserProfile: ${userProfile?.fullName ?? 'Not there'}");
  }

  late FocusNode chatMessageFocusNode;

  final messageController = TextEditingController();

  String message = "";
  bool emojiShowing = false;

  _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  @override
  void dispose() {
    for (var controllers in Cmtctrl) {
      controllers.dispose();
    }
    scrollController.dispose();
    setState(() {
      message = "";
    });
    chatMessageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              primary: true,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Column(children: [
                    InkWell(
                        onTap: () => _bottomPost(),
                        child: IgnorePointer(
                            child: feedTextWidget(
                                true, messageController, Result()))),
                    const SizedBox(height: 5),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(height: 5),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.poll_rounded),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              QuestionsAndPollsScreen(
                                                workshop: widget.workshop,
                                              ))).then((value) => _getFeed());
                                },
                                child: const Text(
                                  'Activity/Poll',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        ]),
                    const SizedBox(height: 40),
                    postFeedWidget()
                  ])),
            )));
  }

  Widget feedTextWidget(
      bool isTextPosting, TextEditingController commentCtrl, Result obj) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(Images.instructor_placeholder))),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: TextField(
                focusNode: chatMessageFocusNode,
                keyboardType: TextInputType.multiline,
                controller: commentCtrl,
                onChanged: (value) {
                  setState(() {
                    message = value;
                  });
                },
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Colors.grey.shade700),
                        borderRadius: BorderRadius.circular(50)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(50)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    fillColor: Colors.grey.shade100,
                    hintText: isTextPosting
                        ? "Share what's on your mind..."
                        : 'Write a comment',
                    suffixIconColor: MaterialStateColor.resolveWith((states) =>
                        states.contains(MaterialState.focused)
                            ? Colors.grey.shade700
                            : Colors.grey.shade500),
                    suffixIcon: isTextPosting
                        ? const SizedBox()
                        : IconButton(
                            focusColor: Colors.grey.shade700,
                            icon: Icon(!emojiShowing
                                ? Icons.emoji_emotions_outlined
                                : Icons.emoji_emotions_rounded),
                            onPressed: () {
                              setState(() {
                                emojiShowing = !emojiShowing;
                              });
                            },
                          ),
                    hintStyle: poppinsMedium.copyWith(
                        fontSize: 12, color: Colors.grey.shade700)),
                style: const TextStyle(fontSize: 12),
              )),
              isTextPosting
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () async {
                        if (commentCtrl.text.isNotEmpty) {
                          String sendMessage = commentCtrl.text;
                          chatMessageFocusNode.unfocus();
                          commentCtrl.clear();
                          setState(() {
                            message = "";
                            emojiShowing = false;
                          });

                          CreatePostModel requestModel = CreatePostModel(
                              commnet: sendMessage,
                              image: null,
                              parent: "",
                              timeline: obj.id);
                          log(requestModel.toString());
                          await Provider.of<TribeProvider>(context,
                                  listen: false)
                              .createPost(requestModel, AppConstants.ADD_CMT);
                          await _getFeed();
                          setState(() {});
                        }

                        // Send Message
                      },
                      icon: Icon(Icons.send,
                          color: messageController.text.isEmpty
                              ? Colors.grey.shade500
                              : Colors.grey.shade700),
                      splashColor: Colors.black,
                    ),
            ],
          ),
          emojiShowing
              ? const SizedBox(
                  height: 8,
                )
              : const SizedBox(),
          Offstage(
              offstage: !emojiShowing,
              child: SizedBox(
                height: 250,
                child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {},
                    textEditingController: messageController,
                    onBackspacePressed: _onBackspacePressed,
                    config: const Config(
                      columns: 7,
                      emojiSizeMax: 28,
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      initCategory: Category.SMILEYS,
                      bgColor: Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: ColorResources.DARK_GREEN_COLOR,
                      backspaceColor: ColorResources.DARK_GREEN_COLOR,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      recentTabBehavior: RecentTabBehavior.RECENT,
                      recentsLimit: 28,
                      checkPlatformCompatibility: true,
                      noRecents: Text(
                        'No Recents',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,
                      ),
                      // Needs to be const Widget
                      loadingIndicator: SizedBox.shrink(),
                      // Needs to be const Widget
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                    )),
              ))
        ]));
  }

  Widget postFeedWidget() {
    return NotificationListener(
        onNotification: (ScrollNotification scrollInfo) {
          log("Workshop feed screen: $scrollInfo");
          if (scrollInfo is ScrollEndNotification) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              log("End of notification hit!");
            }
          }
          // if (scrollInfo is ScrollEndNotification) {
          //   if (!isLastPage &&
          //       scrollInfo.metrics.pixels ==
          //           scrollInfo.metrics.maxScrollExtent &&
          //       !load) {
          //     page++;
          //
          //     load = true;
          //     isLoading = true;
          //     setState(() {});
          //   }
          // }
          return isLastPage;
        },
        child: FutureBuilder<WorkshopFeedResponse?>(
            future: Provider.of<WorkshopProvider>(context, listen: false)
                .fetchWorkshopFeedList(page, widget.workshop.id),
            builder: (_, snap) {
              if (snap.hasData) {
                if (snap.data!.results != null) {
                  isLastPage = snap.data!.results!.length != 10;
                } else {
                  isLastPage = true;
                }
                if (page == 1) data.clear();

                Result? matchedDataInList;
                if (data.isNotEmpty &&
                    snap.data != null &&
                    snap.data!.results != null) {
                  for (int i = 0; i < snap.data!.results!.length; i++) {
                    if (snap.data!.results![i].id == data[data.length - 1].id) {
                      matchedDataInList = data[data.length - 1];
                    }
                  }
                }
                if (matchedDataInList == null &&
                    snap.data != null &&
                    snap.data!.results != null) {
                  data.addAll(snap.data!.results!);
                }

                for (int i = 0; i < data.length; i++) {
                  Cmtctrl.add(TextEditingController());
                }
                load = false;
                return ListView.builder(
                    itemCount: data.length,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 8, top: 8),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var object = data[index];

                      return Column(children: [
                        WorkshopFeedPost(
                            workshopPost: object,
                            userProfile: userProfile,
                            effect: () async {
                              await _getFeed();
                            }),
                        const SizedBox(
                          height: 16,
                        )
                      ]);
                    });
              }
              return snapWidgetHelper(snap);
            }));
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
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
              child: ListView(shrinkWrap: true, children: [
            Column(children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WorkshopQuickPostScreen(
                            workshopId: widget.workshop.id)),
                  ).then((value) {
                    Navigator.of(context).pop();
                    _getFeed();
                  });
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
                // Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WorkshopLongPostScreen(
                          workshopId: widget.workshop.id)),
                ).then((value) {
                  Navigator.of(context).pop();
                  _getFeed();
                });
              }),
            ])
          ]));
        });
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
}
