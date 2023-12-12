import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/create_post_model.dart';
import 'package:joy_society/data/model/response/post_gallery.dart';
import 'package:joy_society/data/model/response/post_model.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/provider/home_controller.dart';
import 'package:joy_society/provider/home_provider.dart';
import 'package:joy_society/provider/post_card_controller.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/app_util.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/extensions/extensions.dart';
import 'package:joy_society/utill/extensions/string_extensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/screen/home/widget/post_card_comment.dart';
import 'package:joy_society/view/screen/home/widget/video_widget.dart';
import 'package:joy_society/view/screen/workshop/workshopFeed/widgets/workshop_feed_comment_widget.dart';
import 'package:joy_society/view/screen/workshop/workshopFeed/widgets/workshop_feed_comments_list.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:quiver/iterables.dart';
import 'package:simple_polls/models/poll_models.dart';
import 'package:simple_polls/widgets/polls_widget.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_polls/flutter_polls.dart';

import 'dart:math' as math;

import '../../../../data/model/response/polls_dummy.dart';

class PostCard extends StatefulWidget {
  final PostModel model;
  final Function(String) textTapHandler;

  // final VoidCallback likeTapHandler;
  final VoidCallback removePostHandler;
  ProfileModel? profile;

  PostCard(
      {Key? key,
      required this.model,
      required this.textTapHandler,
      this.profile,
      // required this.likeTapHandler,
      required this.removePostHandler})
      : super(key: key);

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  final HomeController homeController = Get.find();
  final PostCardController postCardController = Get.find();
  bool areCommentsVisible = false;
  late bool isPostLiked;
  int currentLikes = 0;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final messageController = TextEditingController();
  final commentController = TextEditingController();
  String ans = "";
  String message = "";
  String userFirstName = "";
  String userLastName = "";
  String? profilePic;
  late FocusNode chatMessageFocusNode;
  bool emojiShowing = false;
  double option1 = 1.0;
  double option2 = 0.0;
  double option3 = 1.0;
  double option4 = 1.0;
  String user = "king@mail.com";
  Map usersWhoVoted = {
    'sam@mail.com': 3,
    'mike@mail.com': 4,
    'john@mail.com': 1,
    'kenny@mail.com': 1
  };
  String creator = "eddy@mail.com";
  List<PollOptions> pollOptions = [];
  //[
  //   PollOptions(label: "Option 1", pollsCount: 40, isSelected: false, id: 1),
  //   PollOptions(label: "Option 2", pollsCount: 25, isSelected: false, id: 2),
  //   PollOptions(label: "Option 3", pollsCount: 35, isSelected: false, id: 3),
  // ];

  ProfileModel? profile;

  //final ChatDetailController chatDetailController = Get.find();
  //final SelectUserForChatController selectUserForChatController = Get.find();
  final FlareControls flareControls = FlareControls();

  String calculateAgo(String dateTimeString) {
    DateTime now = DateTime.now();
    DateTime postedTime = DateTime.parse(dateTimeString);
    Duration difference = now.difference(postedTime);
    int daysAgo = difference.inDays;
    if (daysAgo > 0) {
      return "Posted $daysAgo ${daysAgo == 1 ? 'day' : 'days'} ago";
    }
    int hoursAgo = difference.inHours;
    if (hoursAgo > 0) {
      return "Posted $hoursAgo ${hoursAgo == 1 ? 'hour' : 'hours'} ago";
    }
    int minutesAgo = difference.inMinutes;
    if (minutesAgo > 0) {
      return "Posted $minutesAgo ${minutesAgo == 1 ? 'minute' : 'minutes'} ago";
    }
    int secondsAgo = difference.inSeconds;
    return "Posted $secondsAgo ${secondsAgo == 1 ? 'second' : 'seconds'} ago";
  }

  double _hotColdValue = 50.0;
  double _percentageValue = 0.0;

  @override
  void initState() {
    isPostLiked = widget.model.likes
            ?.any((element) => element.id == widget.profile?.userId) ??
        false;
    currentLikes = widget.model.likeCount!;
    chatMessageFocusNode = FocusNode();
    // userFirstName = widget.profile?.fullName!.split(" ").first;
    // userLastName = widget.profile!.fullName!.split(" ").last;
    profilePic = widget.profile?.profilePic;
    profile = Provider.of<ProfileProvider>(context, listen: false).profileModel;

    for (int i = 0; i < widget.model.content!.answer_choice!.length; i++) {
      pollOptions.add(
        PollOptions(
            label: widget.model.content!.answer_choice![i],
            pollsCount: widget.model.content!.myAnswer!.isEmpty
                ? countVotes(widget.model.content!.answer_choice![i])
                : widget.model.content!.myAnswer!.first ==
                        widget.model.content!.answer_choice![i]
                    ? countVotes(widget.model.content!.answer_choice![i]) + 1
                    : countVotes(widget.model.content!.answer_choice![i]),
            isSelected: false,
            id: i),
      );
    }

    super.initState();
  }

  String removeHtmlTags(String input) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return input.replaceAll(exp, '');
  }
  // @override
  // void dispose() {
  //   setState(() {
  //     message = "";
  //   });
  //   chatMessageFocusNode.dispose();
  //   messageController.dispose();
  //   super.dispose();
  // }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'CLOSE',
          onPressed: scaffold.hideCurrentSnackBar,
        )));
  }

  _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  Widget feedTextWidget(
      bool isTextPosting, TextEditingController commentCtrl, PostModel obj) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              profile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        height: 35,
                        width: 35,
                        fit: BoxFit.cover,
                        alignment: Alignment.centerLeft,
                        image: profile!.profilePic ?? "",
                        imageErrorBuilder: (c, o, s) => Image.asset(
                          Images.instructor_placeholder,
                          fit: BoxFit.cover,
                          height: 35,
                          width: 35,
                        ),
                      ))
                  : SizedBox.shrink(),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: TextField(
                focusNode: chatMessageFocusNode,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
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
                            areCommentsVisible = true;
                          });

                          CreatePostModel requestModel = CreatePostModel(
                              commnet: sendMessage,
                              image: null,
                              parent: "",
                              timeline: obj.id);
                          // log(requestModel.toString());

                          Provider.of<WorkshopProvider>(context, listen: false)
                              .createCommentForPost(
                                  requestModel, AppConstants.ADD_CMT,
                                  (bool isSuccess, PostCommentModel? response,
                                      ErrorResponse? error) {
                            if (isSuccess) {
                              response!.createdBy = PostUserModel(
                                  firstName: userFirstName,
                                  lastName: userLastName,
                                  id: profile!.userId!);
                              setState(() {
                                widget.model.comments = [
                                  ...widget.model.comments!,
                                  response
                                ];
                                // postComments = [...postComments, response];
                                areCommentsVisible = true;
                              });
                            } else {
                              _showToast(context,
                                  error!.errorDescription ?? "Error Occurred");
                            }
                          });
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

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      addPostUserInfo().hP8,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          //  widget.model.content.type.
          widget.model.content!.type == "QUESTION"
              ? SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(removeHtmlTags(widget.model.content!.question!)),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          decoration: const BoxDecoration(
                            color: ColorResources.DARK_GREEN_COLOR,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Text("Share your answer",
                              style: poppinsMedium.copyWith(
                                  fontSize: 12, color: Colors.white)))
                    ],
                  ),
                )
              : widget.model.content!.type == "MULTIPLE CHOICE"
                  ? AbsorbPointer(
                      absorbing: false,
                      // absorbing: widget.model.content!.myAnswer!.isNotEmpty,
                      child: SimplePollsWidget(
                        onSelection: (PollFrameModel model,
                            PollOptions selectedOptionModel) async {
                          await Provider.of<HomeProvider>(context,
                                  listen: false)
                              .answerPollValue(
                                  widget.model.content!.id,
                                  selectedOptionModel.label,
                                  getMultipleCallback);
                          print('Now total polls are : ' +
                              model.totalPolls.toString());
                          print('Selected option has label : ' +
                              selectedOptionModel.label);
                        },
                        onReset: (PollFrameModel model) {
                          print(
                              'Poll has been reset, this happens only in case of editable polls');
                        },
                        optionsBorderShape:
                            const StadiumBorder(), //Its Default so its not necessary to write this line
                        model: PollFrameModel(
                          title: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.model.content!.question!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          totalPolls: widget.model.content!.myAnswer!.isEmpty
                              ? widget.model.content!.answers!.length
                              : widget.model.content!.answers!.length + 1,
                          endTime: DateTime.now()
                              .toUtc()
                              .add(const Duration(days: 30)),
                          // DateTime.now().toUtc().add(const Duration(days: 10)),
                          hasVoted: widget.model.content!.myAnswer!.isNotEmpty,
                          editablePoll:
                              !widget.model.content!.myAnswer!.isNotEmpty,
                          options: pollOptions,

                          // <PollOptions>[

                          //   PollOptions(
                          //     label: "Option 1",
                          //     pollsCount: 40,
                          //     isSelected: false,
                          //     id: 1,
                          //   ),
                          //   PollOptions(
                          //     label: "Option 2",
                          //     pollsCount: 25,
                          //     isSelected: false,
                          //     id: 2,
                          //   ),
                          //   PollOptions(
                          //     label: "Option 3",
                          //     pollsCount: 35,
                          //     isSelected: false,
                          //     id: 3,
                          //   ),
                          // ],
                        ),
                      ),
                      // child: Container(
                      //   // height: MediaQuery.of(context).size.height,
                      //   padding: const EdgeInsets.all(20),
                      //   child: ListView.builder(
                      //     itemCount: 1,
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     shrinkWrap: true,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       final List<String> pollAns =
                      //           widget.model.content!.answer_choice!.toList();

                      //       return Container(
                      //         margin: const EdgeInsets.only(bottom: 20),
                      //         child: FlutterPolls(
                      //           // userVotedOptionId:
                      //           //     widget.model.content!.myAnswer!.isEmpty
                      //           //         ? null
                      //           //         : 1,

                      //           pollId: widget.model.content!.id.toString(),
                      //           // hasVoted:
                      //           //     widget.model.content!.myAnswer!.isNotEmpty,
                      //           //  userVotedOptionId: 288,
                      //           onVoted: (PollOption pollOption,
                      //               int newTotalVotes) async {
                      //             await Provider.of<HomeProvider>(context,
                      //                     listen: false)
                      //                 .answerPollValue(widget.model.content!.id,
                      //                     ans, getMultipleCallback);

                      //             /// If HTTP status is success, return true else false
                      //             return true;
                      //           },
                      //           //   pollEnded: days < 0,
                      //           pollTitle: Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: HtmlWidget(
                      //               widget.model.content!.question!,
                      //               textStyle: const TextStyle(
                      //                 fontSize: 14,
                      //                 fontWeight: FontWeight.w600,
                      //               ),
                      //             ),
                      //           ),

                      //           pollOptions: List<PollOption>.from(
                      //             pollAns.map(
                      //               (option) {
                      //                 ans = option;
                      //                 var a = PollOption(
                      //                     // id: 1,
                      //                     title: Text(
                      //                       option,
                      //                       style: const TextStyle(
                      //                         fontSize: 14,
                      //                         fontWeight: FontWeight.w600,
                      //                       ),
                      //                     ),
                      //                     votes: countVotes(option));

                      //                 return a;
                      //               },
                      //             ),
                      //           ),
                      //           votedPercentageTextStyle: const TextStyle(
                      //             fontSize: 14,
                      //             fontWeight: FontWeight.w600,
                      //           ),
                      //           metaWidget: const Row(
                      //             children: [
                      //               SizedBox(width: 6),
                      //               Text(
                      //                 '•',
                      //               ),
                      //               SizedBox(
                      //                 width: 6,
                      //               ),
                      //               // Text(
                      //               //   days < 0 ? "ended" : "ends $days days",
                      //               // ),
                      //             ],
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                    )
                  : widget.model.content!.type == "HOT COLD"
                      ? widget.model.content!.myAnswer!.isEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                HtmlWidget(widget.model.content!.question!,
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.blue,
                                        Colors.white,
                                        Color.fromARGB(255, 255, 160, 17),
                                        Colors.deepOrange,
                                      ],
                                      stops: [0.0, 0.5, 0.5, 1.0],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Transform.translate(
                                    offset: const Offset(0.0,
                                        12.0), // Adjust the offset to position the slider at the bottom
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        thumbShape: CustomSliderThumbPainter(),
                                        // Other slider theme properties...
                                      ),
                                      child: Slider(
                                        min: 0,
                                        max: 100,
                                        value: _hotColdValue,
                                        onChangeEnd: (value) async {
                                          await Provider.of<HomeProvider>(
                                                  context,
                                                  listen: false)
                                              .answerPollValue(
                                                  widget.model.content!.id,
                                                  _hotColdValue.toString(),
                                                  getHotColdCallback);

                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(const SnackBar(
                                          //         content:
                                          //             Text("test complete"),
                                          //         backgroundColor:
                                          //             ColorResources.RED));
                                          // setState(() {});
                                        },
                                        onChanged: (newValue) {
                                          setState(() {
                                            _hotColdValue = newValue;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Negitive",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        )),
                                    Text("Positive",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        )),
                                  ],
                                )
                              ],
                            )
                          : AbsorbPointer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  HtmlWidget(widget.model.content!.question!,
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Community Average",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.blue,
                                          Colors.white,
                                          Color.fromARGB(255, 255, 160, 17),
                                          Colors.deepOrange,
                                        ],
                                        stops: [0.0, 0.5, 0.5, 1.0],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Transform.translate(
                                      offset: const Offset(0.0,
                                          12.0), // Adjust the offset to position the slider at the bottom
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          thumbShape:
                                              CustomSliderThumbPainter(),
                                          // Other slider theme properties...
                                        ),
                                        child: Slider(
                                          min: 0,
                                          max: 100,
                                          value: percentageValue(),
                                          onChangeEnd: (value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text("test complete"),
                                                    backgroundColor:
                                                        ColorResources.RED));
                                            // setState(() {});
                                          },
                                          onChanged: (newValue) {
                                            setState(() {
                                              _hotColdValue = newValue;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Negitive",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          )),
                                      Text("Positive",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  const Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Your Vote",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.blue,
                                          Colors.white,
                                          Color.fromARGB(255, 255, 160, 17),
                                          Colors.deepOrange,
                                        ],
                                        stops: [0.0, 0.5, 0.5, 1.0],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Transform.translate(
                                      offset: const Offset(0.0,
                                          12.0), // Adjust the offset to position the slider at the bottom
                                      child: SliderTheme(
                                        data: SliderThemeData(
                                          thumbShape:
                                              CustomSliderThumbPainter(),
                                          // Other slider theme properties...
                                        ),
                                        child: Slider(
                                          min: 0,
                                          max: 100,
                                          value: widget.model.content!.myAnswer!
                                                  .isEmpty
                                              ? 0
                                              : widget.model.content!.myAnswer!
                                                  .first
                                                  .toDouble(),
                                          onChangeEnd: (value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text("test complete"),
                                                    backgroundColor:
                                                        ColorResources.RED));
                                            // setState(() {});
                                          },
                                          onChanged: (newValue) {
                                            setState(() {
                                              _hotColdValue = newValue;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Negitive",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          )),
                                      Text("Positive",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            )
                      : widget.model.content!.type == "PERCENTAGE"
                          ? widget.model.content!.myAnswer!.isEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                      HtmlWidget(
                                          widget.model.content!.question!,
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        height: 120.0,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color.fromARGB(
                                                  255, 227, 255, 228),
                                              Color.fromARGB(255, 6, 238, 14)
                                            ],
                                            stops: [0.0, 1.0],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("0%"),
                                                  Text("100%"),
                                                ],
                                              ),
                                            ),
                                            SliderTheme(
                                              data: SliderThemeData(
                                                thumbShape:
                                                    CustomSliderThumbPainter(),
                                                // Other slider theme properties...
                                              ),
                                              child: Slider(
                                                min: 0,
                                                max: 100,
                                                value: _percentageValue,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _percentageValue = newValue;
                                                  });
                                                },
                                                onChangeEnd: (value) async {
                                                  await Provider.of<
                                                              HomeProvider>(
                                                          context,
                                                          listen: false)
                                                      .answerPollValue(
                                                          widget.model.content!
                                                              .id,
                                                          _percentageValue
                                                              .toString(),
                                                          getPercentageCallback);
                                                },
                                              ),
                                            ),
                                            Text(
                                              "${_percentageValue.toStringAsFixed(0)}%", // Show percentage value
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ])
                              : AbsorbPointer(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      HtmlWidget(
                                          widget.model.content!.question!,
                                          textStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Community Average",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        height: 120.0,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color.fromARGB(
                                                  255, 227, 255, 228),
                                              Color.fromARGB(255, 6, 238, 14)
                                            ],
                                            stops: [0.0, 1.0],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("0%"),
                                                  Text("100%"),
                                                ],
                                              ),
                                            ),
                                            SliderTheme(
                                              data: SliderThemeData(
                                                thumbShape:
                                                    CustomSliderThumbPainter(),
                                                // Other slider theme properties...
                                              ),
                                              child: Slider(
                                                min: 0,
                                                max: 100,
                                                value: widget.model.content!
                                                        .answers!.isEmpty
                                                    ? widget.model.content!
                                                        .myAnswer!.first
                                                        .toDouble()
                                                    : widget.model.content!
                                                        .answers!.first
                                                        .toDouble(),
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _percentageValue = newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                            Text(
                                              "${percentageValue().toStringAsFixed(0)}%",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Your Vote",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        height: 120.0,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color.fromARGB(
                                                  255, 227, 255, 228),
                                              Color.fromARGB(255, 6, 238, 14)
                                            ],
                                            stops: [0.0, 1.0],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("0%"),
                                                  Text("100%"),
                                                ],
                                              ),
                                            ),
                                            SliderTheme(
                                              data: SliderThemeData(
                                                thumbShape:
                                                    CustomSliderThumbPainter(),
                                                // Other slider theme properties...
                                              ),
                                              child: Slider(
                                                min: 0,
                                                max: 100,
                                                value: widget.model.content!
                                                    .myAnswer!.first
                                                    .toDouble(),
                                                onChanged: (newValue) {},
                                              ),
                                            ),
                                            Text(
                                              "${widget.model.content!.myAnswer!.first.toDouble().toStringAsFixed(0)}%",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      )
                                    ],
                                  ),
                                )
                          : HtmlWidget(widget.model.content?.post ?? ""),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  /* IconButton(
                      onPressed: () {},
                      icon: Icon(
                        
                        widget.model.isLikedByUser(profile!.userId!)
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: widget.model.isLikedByUser(profile!.userId!)
                            ? ColorResources.RED
                            : ColorResources.GRAY_TEXT_COLOR,
                      )),*/
                  Text(
                    "${widget.model.likes!.length}",
                    style: poppinsMedium.copyWith(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              widget.model.topic != null
                  ? Text(
                      "#${widget.model.topic!.name}",
                      style: poppinsMedium.copyWith(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    )
                  : const SizedBox(),
              Text(
                "${widget.model.comments?.length ?? 0} comments",
                style: poppinsMedium.copyWith(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            thickness: 2,
          ),
        ],
      ).hP16,
      commentAndLikeWidget().hP16,
      if (areCommentsVisible)
        ListView.builder(
            itemCount: widget.model.comments?.length ?? 0,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 8, top: 8),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var commentObj = widget.model.comments![index];
              return PostCardComment(
                  post: widget.model,
                  comment: commentObj,
                  profilePic: profile!.profilePic!,
                  userProfile: profile,
                  replyingCapability: true);
            }).hP16,
      const SizedBox(
        height: 10,
      ),
      feedTextWidget(false, commentController, widget.model),
    ]).vP16.shadow(context: context, radius: 10, shadowOpacity: 0.05).hP16;
  }

  Widget commentAndLikeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {
                  if (widget.model.isLikedByUser(profile!.userId!)) {
                    print('LikedCount - 1');
                    setState(() {
                      widget.model.likeCount = widget.model.likeCount! - 1;
                      currentLikes = currentLikes - 1;
                    });
                  } else {
                    print('LikedCount + 1');
                    setState(() {
                      widget.model.likeCount = widget.model.likeCount! + 1;
                      currentLikes = currentLikes + 1;
                    });
                  }
                  postCardController.likeUnlikePost(
                      post: widget.model,
                      isLike: isPostLiked,
                      userId: profile!.userId!,
                      context: context);
                  setState(() {
                    widget.model.likes = widget.model
                            .isLikedByUser(profile!.userId!)
                        ? widget.model.likes!
                            .where((element) => element.id != profile!.userId!)
                            .toList()
                        : [
                            ...widget.model.likes!,
                            PostUserModel(id: profile!.userId!)
                          ];
                  });
                },
                icon: Icon(
                  widget.model.isLikedByUser(profile!.userId!)
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: widget.model.isLikedByUser(profile!.userId!)
                      ? ColorResources.RED
                      : ColorResources.GRAY_TEXT_COLOR,
                )),
            Text(
              "Like",
              style: poppinsMedium.copyWith(
                color: widget.model.isLikedByUser(profile!.userId!)
                    ? ColorResources.RED
                    : ColorResources.GRAY_TEXT_COLOR,
                fontSize: 12,
              ),
            )
          ],
        ),
        GestureDetector(
          child: Row(
            children: [
              Image.asset(Images.icon_comment, height: 20, width: 20),
              const SizedBox(
                width: 8,
              ),
              Text(
                "Comments",
                style: poppinsMedium.copyWith(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              areCommentsVisible = !areCommentsVisible;
            });
          },
        ),
      ],
    );
  }

  Widget addPostUserInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
            onTap: () => openProfile(),
            child: widget.model.content != null &&
                    widget.model.content!.user != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      height: 35,
                      width: 35,
                      fit: BoxFit.cover,
                      alignment: Alignment.centerLeft,
                      image: widget.model.content!.user!.profilePic ?? "",
                      imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.instructor_placeholder,
                        height: 35,
                        width: 35,
                        fit: BoxFit.cover,
                      ),
                    ))
                : SizedBox.shrink()),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
                onTap: () => openProfile(),
                child: Text(widget.model.content?.user?.fullName ?? "",
                    style: poppinsBold.copyWith(
                        fontSize: 14, color: Colors.black))),
            Row(
              children: [
                Text(
                  widget.model.contentType ?? "",
                  style: poppinsMedium.copyWith(
                      fontSize: 11, color: ColorResources.GRAY_TEXT_COLOR),
                ),
                SizedBox(
                  width: 16,
                  child: Center(
                    child: Text("-",
                        style: poppinsMedium.copyWith(
                            fontSize: 11,
                            color: ColorResources.GRAY_TEXT_COLOR)),
                  ),
                ),
                Text(
                  calculateAgo(widget.model.createdOn!.toIso8601String()),
                  style: poppinsMedium.copyWith(
                      fontSize: 11, color: ColorResources.GRAY_TEXT_COLOR),
                )
              ],
            )
            // widget.model.user.city != null
            //     ? Text(
            //         '${widget.model.user.city!}, ${widget.model.user.country!}',
            //         style: Theme.of(context).textTheme.bodyLarge,
            //       )
            //     : Container()
            // Text(
            //   'Location to add',
            //   style: Theme.of(context).textTheme.bodyLarge,
            // )
          ],
        )),
      ],
    );
  }

  void openActionPopup() {}

  void openComments() {
    /*Get.to(() => CommentsScreen(
          model: widget.model,
        ));*/
  }

  void openProfile() async {
    //Get.to(OtherUserProfile(userId: widget.model.user.id));
  }

  double percentageValue() {
    double value = 0.0;
    widget.model.content!.answers!.forEach((element) {
      value += element.toDouble();
    });
    if (value > 0) {
      return value / widget.model.content!.answers!.length;
    }
    return widget.model.content!.myAnswer!.first.toDouble();
  }

  int countVotes(String val) {
    int count = 0;
    widget.model.content!.answers!.forEach((element) {
      if (element == val) {
        count++;
      }
    });
    return count;
  }

  getPercentageCallback(bool ans, dynamic errorResponse) {
    if (ans) {
      // homeController.clear();
      // homeController.clearPosts();
      // homeController.postSearchQuery.topic = null;
      // loadData(isRecent: false);

      setState(() {
        widget.model.content!.myAnswer!.add(_percentageValue.toString());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorResponse.toString()),
          backgroundColor: ColorResources.RED));
    }
  }

  getMultipleCallback(bool ans, dynamic errorResponse) {
    if (ans) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Technical error please try again later!"),
          backgroundColor: ColorResources.RED));
    }
  }

  getHotColdCallback(bool ans, dynamic errorResponse) {
    if (ans) {
      // homeController.clear();
      // homeController.clearPosts();
      // homeController.postSearchQuery.topic = null;
      // loadData(isRecent: false);

      setState(() {
        widget.model.content!.myAnswer!.add(_hotColdValue.toString());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorResponse.toString()),
          backgroundColor: ColorResources.RED));
    }
  }

  void loadData({required bool? isRecent}) {
    loadPosts(isRecent);
    //_homeController.getStories();
  }

  loadPosts(bool? isRecent) {
    // log(homeController.postSearchQuery.topic.toString());
    // log(x)
    homeController.getPosts(
        isRecent: isRecent,
        topic: homeController.postSearchQuery.topic,
        callback: () {
          _refreshController.refreshCompleted();
        });
  }
}

class CustomSliderThumbPainter extends SliderComponentShape {
  final double thumbRadius;

  CustomSliderThumbPainter({this.thumbRadius = 10.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbRadius * 2, thumbRadius * 2);
  }

  @override
  void paint(
    PaintingContext context,
    Offset thumbCenter, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    bool? isEnabled,
    bool? isOnTop,
    TextPainter? labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    double? textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()
      ..color = Colors.white // Triangle color
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(thumbCenter.dx - thumbRadius, thumbCenter.dy + thumbRadius)
      ..lineTo(thumbCenter.dx + thumbRadius, thumbCenter.dy + thumbRadius)
      ..lineTo(thumbCenter.dx, thumbCenter.dy - thumbRadius)
      ..close();

    canvas.drawPath(path, paint);
  }
}
