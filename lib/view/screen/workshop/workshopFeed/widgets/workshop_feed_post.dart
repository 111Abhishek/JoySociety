import 'dart:developer';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/create_post_model.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/data/model/response/workshop_feed_response_model.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/extensions/string_extensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/screen/workshop/workshopFeed/widgets/workshop_feed_comments_list.dart';
import 'package:provider/provider.dart';
import 'package:simple_polls/models/poll_models.dart';
import 'package:simple_polls/widgets/polls_widget.dart';

import 'dart:math' as math;

import 'package:transparent_image/transparent_image.dart';

import '../../../../../provider/home_provider.dart';
import '../../../home/widget/post_card.dart';

// ignore: must_be_mutable, must_be_immutable
class WorkshopFeedPost extends StatefulWidget {
  final Result workshopPost;
  ProfileModel? userProfile;
  final Function effect;

  WorkshopFeedPost({
    super.key,
    required this.workshopPost,
    required this.effect,
    this.userProfile,
  });

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

  @override
  State<WorkshopFeedPost> createState() => _WorkshopFeedPostState();
}

class _WorkshopFeedPostState extends State<WorkshopFeedPost> {
  List<PollOptions> pollOptions = [];
  int? isCommetWidgetId;

  late bool isPostLiked;
  late int likesCount;
  late List<Comment> postComments;
  bool areCommentsVisible = false;

  late FocusNode chatMessageFocusNode;
  final messageController = TextEditingController();
  final commentController = TextEditingController();
  String message = "";
  String userFirstName = "";
  String userLastName = "";

  bool emojiShowing = false;
  double _hotColdValue = 50.0;
  double _percentageValue = 0.0;
  

  @override
  void initState() {
    super.initState();

    chatMessageFocusNode = FocusNode();
    isPostLiked = widget.workshopPost.like!
        .any((element) => element.id == widget.userProfile?.userId);
    likesCount = widget.workshopPost.likeCount ?? 0;
    postComments = widget.workshopPost.comments!;
    userFirstName = widget.userProfile!.fullName!.split(" ").first;
    userLastName = widget.userProfile!.fullName!.split(" ").last;

    for (int i = 0;
        i < widget.workshopPost.content!.answer_choice!.length;
        i++) {
      pollOptions.add(
        PollOptions(
            label: widget.workshopPost.content!.answer_choice![i],
            pollsCount: widget.workshopPost.content!.myAnswer!.isEmpty
                ? countVotes(widget.workshopPost.content!.answer_choice![i])
                : widget.workshopPost.content!.myAnswer!.first ==
                        widget.workshopPost.content!.answer_choice![i]
                    ? countVotes(
                            widget.workshopPost.content!.answer_choice![i]) +
                        1
                    : countVotes(
                        widget.workshopPost.content!.answer_choice![i]),
            isSelected: false,
            id: i),
      );
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  int countVotes(String val) {
    int count = 0;
    for (var element in widget.workshopPost.content!.answers!) {
      if (element == val) {
        count++;
      }
    }
    return count;
  }

  @override
  void dispose() {
    setState(() {
      message = "";
    });
    chatMessageFocusNode.dispose();
    messageController.dispose();
    super.dispose();
  }

  

  _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  String removeHtmlTags(String input) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return input.replaceAll(exp, '');
  }

  String calculateAgo(String dateTimeString) {
    DateTime now = DateTime.now();
    DateTime postedTime = DateTime.parse(dateTimeString);
    Duration difference = now.difference(postedTime);
    int daysAgo = difference.inDays;
    if (daysAgo > 0) {
      return "Quick Post - Posted $daysAgo ${daysAgo == 1 ? 'day' : 'days'} ago";
    }
    int hoursAgo = difference.inHours;
    if (hoursAgo > 0) {
      return "Quick Post - Posted $hoursAgo ${hoursAgo == 1 ? 'hour' : 'hours'} ago";
    }
    int minutesAgo = difference.inMinutes;
    if (minutesAgo > 0) {
      return "Quick Post - Posted $minutesAgo ${minutesAgo == 1 ? 'minute' : 'minutes'} ago";
    }
    int secondsAgo = difference.inSeconds;
    return "Quick Post - Posted $secondsAgo ${secondsAgo == 1 ? 'second' : 'seconds'} ago";
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
              ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    height: 35,
                    width: 35,
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                    image: widget.userProfile!.profilePic!,
                    imageErrorBuilder: (c, o, s) => Image.asset(
                      Images.instructor_placeholder,
                      fit: BoxFit.cover,
                      height: 35,
                      width: 35,
                    ),
                  )),
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
                          log(requestModel.toString());

                          Provider.of<WorkshopProvider>(context, listen: false)
                              .createComment(requestModel, AppConstants.ADD_CMT,
                                  (bool isSuccess, Comment? response,
                                      ErrorResponse? error) {
                            if (isSuccess) {
                              response!.createdBy = User(
                                  firstName: userFirstName,
                                  lastName: userLastName,
                                  id: widget.userProfile!.userId);
                              setState(() {
                                widget.workshopPost.comments = [
                                  ...widget.workshopPost.comments!,
                                  response
                                ];
                                // postComments = [...postComments, response];
                                areCommentsVisible = true;
                              });
                              widget.effect();
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
    return Card(
        elevation: 0.5,
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        alignment: Alignment.centerLeft,
                        image: widget.workshopPost.content!.user!.profilePic!,
                        imageErrorBuilder: (c, o, s) => Image.asset(
                          Images.instructor_placeholder,
                          fit: BoxFit.cover,
                          height: 35,
                          width: 35,
                        ),
                      )),
                  title: Text(
                      "${widget.workshopPost.content!.user!.firstName!} ${widget.workshopPost.content!.user!.lastName!}",
                      style: poppinsBold.copyWith(
                        color: Colors.black,
                        fontSize: 14,
                      )),
                  subtitle: Text(
                    calculateAgo(
                        widget.workshopPost.createdOn!.toIso8601String()),
                    style: poppinsMedium.copyWith(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.workshopPost.content!.type == "QUESTION"
                    ? SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(removeHtmlTags(widget.workshopPost.content!.question!)),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                decoration: const BoxDecoration(
                                  color: ColorResources.DARK_GREEN_COLOR,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text("Share your answer",
                                    style: poppinsMedium.copyWith(
                                        fontSize: 12, color: Colors.white)))
                          ],
                        ),
                      )
                    : widget.workshopPost.content!.type == "MULTIPLE CHOICE"
                        ? AbsorbPointer(
                            absorbing: false,
                            // absorbing: widget.model.content!.myAnswer!.isNotEmpty,
                            child: SimplePollsWidget(
                              onSelection: (PollFrameModel model,
                                  PollOptions selectedOptionModel) async {
                                await Provider.of<HomeProvider>(context,
                                        listen: false)
                                    .answerPollValue(
                                        widget.workshopPost.content!.id!,
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
                                  child: HtmlWidget(
                                    widget.workshopPost.content!.question!,
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                totalPolls: widget
                                        .workshopPost.content!.myAnswer!.isEmpty
                                    ? widget
                                        .workshopPost.content!.answers!.length
                                    : widget.workshopPost.content!.answers!
                                            .length +
                                        1,
                                endTime: DateTime.now()
                                    .toUtc()
                                    .add(const Duration(days: 30)),
                                // DateTime.now().toUtc().add(const Duration(days: 10)),
                                hasVoted: widget
                                    .workshopPost.content!.myAnswer!.isNotEmpty,
                                editablePoll: !widget
                                    .workshopPost.content!.myAnswer!.isNotEmpty,
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
                        : widget.workshopPost.content!.type == "HOT COLD"
                            ? widget.workshopPost.content!.myAnswer!.isEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      HtmlWidget(
                                          widget
                                              .workshopPost.content!.question!,
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
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                                              value: _hotColdValue,
                                              onChangeEnd: (value) async {
                                                await Provider.of<HomeProvider>(
                                                        context,
                                                        listen: false)
                                                    .answerPollValue(
                                                        widget.workshopPost
                                                            .content!.id!,
                                                        _hotColdValue
                                                            .toString(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        HtmlWidget(
                                            widget.workshopPost.content!
                                                .question!,
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
                                                Color.fromARGB(
                                                    255, 255, 160, 17),
                                                Colors.deepOrange,
                                              ],
                                              stops: [0.0, 0.5, 0.5, 1.0],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                                          content: Text(
                                                              "test complete"),
                                                          backgroundColor:
                                                              ColorResources
                                                                  .RED));
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
                                                Color.fromARGB(
                                                    255, 255, 160, 17),
                                                Colors.deepOrange,
                                              ],
                                              stops: [0.0, 0.5, 0.5, 1.0],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
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
                                                value: widget
                                                        .workshopPost
                                                        .content!
                                                        .myAnswer!
                                                        .isEmpty
                                                    ? 0
                                                    : widget
                                                        .workshopPost
                                                        .content!
                                                        .myAnswer!
                                                        .first
                                                        .toDouble(),
                                                onChangeEnd: (value) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "test complete"),
                                                          backgroundColor:
                                                              ColorResources
                                                                  .RED));
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
                            : widget.workshopPost.content!.type == "PERCENTAGE"
                                ? widget.workshopPost.content!.myAnswer!.isEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                            HtmlWidget(
                                                widget.workshopPost.content!
                                                    .question!,
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
                                                    Color.fromARGB(
                                                        255, 6, 238, 14)
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
                                                          _percentageValue =
                                                              newValue;
                                                        });
                                                      },
                                                      onChangeEnd:
                                                          (value) async {
                                                        await Provider.of<
                                                                    HomeProvider>(
                                                                context,
                                                                listen: false)
                                                            .answerPollValue(
                                                                widget
                                                                    .workshopPost
                                                                    .content!
                                                                    .id!,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                widget.workshopPost.content!
                                                    .question!,
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
                                                    Color.fromARGB(
                                                        255, 6, 238, 14)
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
                                                      value: widget
                                                              .workshopPost
                                                              .content!
                                                              .answers!
                                                              .isEmpty
                                                          ? widget
                                                              .workshopPost
                                                              .content!
                                                              .myAnswer!
                                                              .first
                                                              .toDouble()
                                                          : widget
                                                              .workshopPost
                                                              .content!
                                                              .answers!
                                                              .first
                                                              .toDouble(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          _percentageValue =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Text(
                                                    "${percentageValue().toStringAsFixed(0)}%",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                    Color.fromARGB(
                                                        255, 6, 238, 14)
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
                                                      value: widget
                                                          .workshopPost
                                                          .content!
                                                          .myAnswer!
                                                          .first
                                                          .toDouble(),
                                                      onChanged: (newValue) {},
                                                    ),
                                                  ),
                                                  Text(
                                                    "${widget.workshopPost.content!.myAnswer!.first.toDouble().toStringAsFixed(0)}%",
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                : HtmlWidget(
                                    widget.workshopPost.content?.post ?? ""),
                HtmlWidget(
                  widget.workshopPost.content!.post ?? "",
                  textStyle: const TextStyle(fontFamily: 'poppins'),
                  enableCaching: true,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              isPostLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: isPostLiked
                                  ? ColorResources.RED
                                  : ColorResources.GRAY_TEXT_COLOR,
                            )),
                        Text(
                          "$likesCount",
                          style: poppinsMedium.copyWith(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    widget.workshopPost.topic != null
                        ? Text(
                            "#${widget.workshopPost.topic!.name}",
                            style: poppinsMedium.copyWith(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          )
                        : const SizedBox(),
                    Text(
                      "${widget.workshopPost.comments!.length} comments",
                      style: poppinsMedium.copyWith(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              if (isPostLiked) {
                                // here the likes count will be reduced by 1
                                setState(() {
                                  likesCount = math.max(likesCount - 1, 0);
                                });
                              } else {
                                setState(() {
                                  likesCount = likesCount + 1;
                                });
                              }
                              setState(() {
                                isPostLiked = !isPostLiked;
                              });

                              widget.workshopPost.like!.any((element) =>
                                      element.id == widget.userProfile?.userId)
                                  ? await Provider.of<WorkshopProvider>(context,
                                          listen: false)
                                      .likePost(
                                          widget.workshopPost.id!,
                                          widget.userProfile!.userId!,
                                          false,
                                          false)
                                  : await Provider.of<WorkshopProvider>(context,
                                          listen: false)
                                      .likePost(
                                          widget.workshopPost.id!,
                                          widget.userProfile!.userId!,
                                          true,
                                          false);

                              // log(widget.workshop.id.toString());
                            },
                            icon: Icon(
                              isPostLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: isPostLiked
                                  ? ColorResources.RED
                                  : ColorResources.GRAY_TEXT_COLOR,
                            )),
                        Text(
                          "Like",
                          style: poppinsMedium.copyWith(
                            color: isPostLiked
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
                          Image.asset(Images.icon_comment,
                              height: 20, width: 20),
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
                ),
                const Divider(
                  thickness: 2,
                ),
                if (areCommentsVisible)
                  WorkshopFeedCommentListWidget(
                      workshopPost: widget.workshopPost,
                      comments: widget.workshopPost.comments!,
                      userProfile: widget.userProfile,
                      canReply: true,
                      effect: widget.effect),
                const SizedBox(
                  height: 10,
                ),
                feedTextWidget(false, commentController, widget.workshopPost),
              ],
            )));
  }

  double percentageValue() {
    double value = 0.0;
    widget.workshopPost.content!.answers!.forEach((element) {
      value += element.toDouble();
    });
    if (value > 0) {
      return value / widget.workshopPost.content!.answers!.length;
    }
    return widget.workshopPost.content!.myAnswer!.first.toDouble();
  }

  getPercentageCallback(bool ans, dynamic errorResponse) {
    if (ans) {
      // homeController.clear();
      // homeController.clearPosts();
      // homeController.postSearchQuery.topic = null;
      // loadData(isRecent: false);

      setState(() {
        widget.workshopPost.content!.myAnswer!.add(_percentageValue.toString());
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
        widget.workshopPost.content!.myAnswer!.add(_hotColdValue.toString());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorResponse.toString()),
          backgroundColor: ColorResources.RED));
    }
  }
}
