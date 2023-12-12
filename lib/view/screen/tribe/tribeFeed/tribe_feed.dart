import 'dart:developer';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/provider/tribe_provider.dart';
import 'package:joy_society/utill/extensions/string_extensions.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/web_view_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_polls/models/poll_models.dart';
import 'package:simple_polls/widgets/polls_widget.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../data/model/response/create_post_model.dart';
import '../../../../data/model/response/tribe_model.dart';
import '../../../../data/model/tribe_response_model.dart';
import '../../../../localization/language_constants.dart';
import '../../../../provider/home_provider.dart';
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
import '../../home/widget/post_card.dart';

class FeedScreen extends StatefulWidget {
  final TribeModel? tribeObj;
  ProfileModel? userProfile;

  FeedScreen({super.key, this.tribeObj, this.userProfile});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Result> data = [];
  List<TextEditingController> Cmtctrl = [];
  List<PollOptions> pollOptions = [];
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

    // chatMessageFocusNode = FocusNode();
  }

  _getId() {
    // userId = sharedPreferences?.getString(AppConstants.USER_ID);
    // log(userId!);
  }

  _getFeed() async {
    TribeFeedResponse fulldata =
        await Provider.of<TribeProvider>(context, listen: false)
            .fetchTribalFeedList(page, widget.tribeObj!.id!);
    setState(() {
      data = fulldata.results!;
    });
  }

  //late FocusNode chatMessageFocusNode;

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
    setState(() {
      message = "";
    });
    // chatMessageFocusNode.dispose();
    super.dispose();
  }

    String removeHtmlTags(String input) {
                        RegExp exp = RegExp(r"<[^>]*>",
                            multiLine: true, caseSensitive: true);
                        return input.replaceAll(exp, '');
                      }

  double _hotColdValue = 50.0;
  double _percentageValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              primary: true,
              physics: BouncingScrollPhysics(),
              child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(color: Colors.white),
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
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.poll_rounded),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => QuestionsAndPollsScreen(
                                        tribe: widget.tribeObj,
                                      )));
                        },
                        child: const Text(
                          'Activity/Poll',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     const Icon(Icons.videocam),
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //                 builder: (_) => WebViewScreen(
                      //                     url: widget
                      //                         .tribeObj!.tribe_url!)));
                      //       },
                      //       child: const Text(
                      //         'Go Live',
                      //         style:
                      //             TextStyle(fontWeight: FontWeight.normal),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ]),
                    const SizedBox(height: 40),
                    postFeedWidget()
                  ])),
            )));
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

  // creating the onSend method to send the text when the user presses the button
  // void onSend() async {
  //   if (messageController.text.isNotEmpty) {
  //     String sendMessage = messageController.text;
  //     chatMessageFocusNode.unfocus();
  //     messageController.clear();
  //     setState(() {
  //       message = "";
  //       emojiShowing = false;
  //     });
  //     // await Provider.of<WorkshopProvider>(context, listen: false)
  //     //     .sendChat(widget.channelId, sendMessage,
  //     //         (bool isStatusSuccess, ErrorResponse? errorResponse) {
  //     //   if (isStatusSuccess) {
  //     //   } else {
  //     //     _showToast(context, "Cannot send message at the moment");
  //     //   }
  //     // });
  //   }
  // }

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
                // focusNode: chatMessageFocusNode,
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
                          //  chatMessageFocusNode.unfocus();
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
                          if (requestModel != null) {
                            await Provider.of<TribeProvider>(context,
                                    listen: false)
                                .createPost(requestModel, AppConstants.ADD_CMT);
                            await _getFeed();
                            setState(() {});
                          }
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
          if (scrollInfo is ScrollEndNotification) {
            if (!isLastPage &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                !load) {
              page++;
              load = true;
              isLoading = true;
              setState(() {});
            }
          }
          return isLastPage;
        },
        child: FutureBuilder<TribeFeedResponse?>(
            future: Provider.of<TribeProvider>(context, listen: false)
                .fetchTribalFeedList(page, widget.tribeObj!.id!),
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

                    

                      double percentageValue() {
                        double value = 0.0;
                        object.content!.answers!.forEach((element) {
                          value += element.toDouble();
                        });
                        if (value > 0) {
                          return value / object.content!.answers!.length;
                        }
                        return object.content!.myAnswer!.first.toDouble();
                      }

                      int countVotes(String val) {
                        int count = 0;
                        object.content!.answers!.forEach((element) {
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
                            object.content!.myAnswer!
                                .add(_percentageValue.toString());
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
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Technical error please try again later!"),
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
                            object.content!.myAnswer!
                                .add(_hotColdValue.toString());
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(errorResponse.toString()),
                              backgroundColor: ColorResources.RED));
                        }
                      }

                      for (int i = 0;
                          i < object.content!.answerChoice!.length;
                          i++) {
                        pollOptions.add(
                          PollOptions(
                              label: object.content!.answerChoice![i],
                              pollsCount: object.content!.myAnswer!.isEmpty
                                  ? countVotes(object.content!.answerChoice![i])
                                  : object.content!.myAnswer!.first ==
                                          object.content!.answerChoice![i]
                                      ? countVotes(object
                                              .content!.answerChoice![i]) +
                                          1
                                      : countVotes(
                                          object.content!.answerChoice![i]),
                              isSelected: false,
                              id: i),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  height: 35,
                                  width: 35,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.centerLeft,
                                  image: object.content!.user!.profilePic ?? "",
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                    Images.instructor_placeholder,
                                    fit: BoxFit.cover,
                                    height: 35,
                                    width: 35,
                                  ),
                                )),
                            title: Text(
                                "${object.content!.user!.firstName!} ${object.content!.user!.lastName!}",
                                style: poppinsBold.copyWith(
                                  color: Colors.black,
                                  fontSize: 14,
                                )),
                            subtitle: Text(
                              "Quick Post - Posted ${calculateDaysAgo(object.createdOn.toString())} days ago",
                              style: poppinsMedium.copyWith(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          object.content!.type == "QUESTION"
                              ? SizedBox(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(removeHtmlTags(object.content!.question!)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          decoration: const BoxDecoration(
                                            color:
                                                ColorResources.DARK_GREEN_COLOR,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          child: Text("Share your answer",
                                              style: poppinsMedium.copyWith(
                                                  fontSize: 12,
                                                  color: Colors.white)))
                                    ],
                                  ),
                                )
                              : object.content!.type == "MULTIPLE CHOICE"
                                  ? AbsorbPointer(
                                      absorbing: false,
                                      // absorbing: widget.model.content!.myAnswer!.isNotEmpty,
                                      child: SimplePollsWidget(
                                        onSelection: (PollFrameModel model,
                                            PollOptions
                                                selectedOptionModel) async {
                                          await Provider.of<HomeProvider>(
                                                  context,
                                                  listen: false)
                                              .answerPollValue(
                                                  object.content!.id!,
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
                                              object.content!.question!,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          totalPolls: object
                                                  .content!.myAnswer!.isEmpty
                                              ? object.content!.answers!.length
                                              : object.content!.answers!
                                                      .length +
                                                  1,
                                          endTime: DateTime.now()
                                              .toUtc()
                                              .add(const Duration(days: 30)),
                                          // DateTime.now().toUtc().add(const Duration(days: 10)),
                                          hasVoted: object
                                              .content!.myAnswer!.isNotEmpty,
                                          editablePoll: !object
                                              .content!.myAnswer!.isNotEmpty,
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
                                  : object.content!.type == "HOT COLD"
                                      ? object.content!.myAnswer!.isEmpty
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                HtmlWidget(
                                                    object.content!.question!,
                                                    textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    )),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  height: 50.0,
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        const LinearGradient(
                                                      colors: [
                                                        Colors.blue,
                                                        Colors.white,
                                                        Color.fromARGB(
                                                            255, 255, 160, 17),
                                                        Colors.deepOrange,
                                                      ],
                                                      stops: [
                                                        0.0,
                                                        0.5,
                                                        0.5,
                                                        1.0
                                                      ],
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
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
                                                        onChangeEnd:
                                                            (value) async {
                                                          await Provider.of<
                                                                      HomeProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .answerPollValue(
                                                                  object
                                                                      .content!
                                                                      .id!,
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
                                                            _hotColdValue =
                                                                newValue;
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("Negitive",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        )),
                                                    Text("Positive",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w800,
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
                                                      object.content!.question!,
                                                      textStyle:
                                                          const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      )),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      "Community Average",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          Colors.blue,
                                                          Colors.white,
                                                          Color.fromARGB(255,
                                                              255, 160, 17),
                                                          Colors.deepOrange,
                                                        ],
                                                        stops: [
                                                          0.0,
                                                          0.5,
                                                          0.5,
                                                          1.0
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
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
                                                          value:
                                                              percentageValue(),
                                                          onChangeEnd: (value) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(const SnackBar(
                                                                    content: Text(
                                                                        "test complete"),
                                                                    backgroundColor:
                                                                        ColorResources
                                                                            .RED));
                                                            // setState(() {});
                                                          },
                                                          onChanged:
                                                              (newValue) {
                                                            setState(() {
                                                              _hotColdValue =
                                                                  newValue;
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Negitive",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          )),
                                                      Text("Positive",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          )),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 25,
                                                  ),
                                                  const Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      "Your Vote",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    height: 50.0,
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          Colors.blue,
                                                          Colors.white,
                                                          Color.fromARGB(255,
                                                              255, 160, 17),
                                                          Colors.deepOrange,
                                                        ],
                                                        stops: [
                                                          0.0,
                                                          0.5,
                                                          0.5,
                                                          1.0
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
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
                                                          value: object
                                                                  .content!
                                                                  .myAnswer!
                                                                  .isEmpty
                                                              ? 0
                                                              : object
                                                                  .content!
                                                                  .myAnswer!
                                                                  .first
                                                                  .toDouble(),
                                                          onChangeEnd: (value) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(const SnackBar(
                                                                    content: Text(
                                                                        "test complete"),
                                                                    backgroundColor:
                                                                        ColorResources
                                                                            .RED));
                                                            // setState(() {});
                                                          },
                                                          onChanged:
                                                              (newValue) {
                                                            setState(() {
                                                              _hotColdValue =
                                                                  newValue;
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Negitive",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          )),
                                                      Text("Positive",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                      : object.content!.type == "PERCENTAGE"
                                          ? object.content!.myAnswer!.isEmpty
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                      HtmlWidget(
                                                          object.content!
                                                              .question!,
                                                          textStyle:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        height: 120.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  227,
                                                                  255,
                                                                  228),
                                                              Color.fromARGB(
                                                                  255,
                                                                  6,
                                                                  238,
                                                                  14)
                                                            ],
                                                            stops: [0.0, 1.0],
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(15),
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
                                                              data:
                                                                  SliderThemeData(
                                                                thumbShape:
                                                                    CustomSliderThumbPainter(),
                                                                // Other slider theme properties...
                                                              ),
                                                              child: Slider(
                                                                min: 0,
                                                                max: 100,
                                                                value:
                                                                    _percentageValue,
                                                                onChanged:
                                                                    (newValue) {
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
                                                                          listen:
                                                                              false)
                                                                      .answerPollValue(
                                                                          object
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
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      HtmlWidget(
                                                          object.content!
                                                              .question!,
                                                          textStyle:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          )),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      const Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          "Community Average",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        height: 120.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  227,
                                                                  255,
                                                                  228),
                                                              Color.fromARGB(
                                                                  255,
                                                                  6,
                                                                  238,
                                                                  14)
                                                            ],
                                                            stops: [0.0, 1.0],
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(15),
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
                                                              data:
                                                                  SliderThemeData(
                                                                thumbShape:
                                                                    CustomSliderThumbPainter(),
                                                                // Other slider theme properties...
                                                              ),
                                                              child: Slider(
                                                                min: 0,
                                                                max: 100,
                                                                value: object
                                                                        .content!
                                                                        .answers!
                                                                        .isEmpty
                                                                    ? object
                                                                        .content!
                                                                        .myAnswer!
                                                                        .first
                                                                        .toDouble()
                                                                    : object
                                                                        .content!
                                                                        .answers!
                                                                        .first
                                                                        .toDouble(),
                                                                onChanged:
                                                                    (newValue) {
                                                                  setState(() {
                                                                    _percentageValue =
                                                                        newValue;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                            Text(
                                                              "${percentageValue().toStringAsFixed(0)}%",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      const Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          "Your Vote",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        height: 120.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            colors: [
                                                              Color.fromARGB(
                                                                  255,
                                                                  227,
                                                                  255,
                                                                  228),
                                                              Color.fromARGB(
                                                                  255,
                                                                  6,
                                                                  238,
                                                                  14)
                                                            ],
                                                            stops: [0.0, 1.0],
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(15),
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
                                                              data:
                                                                  SliderThemeData(
                                                                thumbShape:
                                                                    CustomSliderThumbPainter(),
                                                                // Other slider theme properties...
                                                              ),
                                                              child: Slider(
                                                                min: 0,
                                                                max: 100,
                                                                value: object
                                                                    .content!
                                                                    .myAnswer!
                                                                    .first
                                                                    .toDouble(),
                                                                onChanged:
                                                                    (newValue) {},
                                                              ),
                                                            ),
                                                            Text(
                                                              "${object.content!.myAnswer!.first.toDouble().toStringAsFixed(0)}%",
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                                              object.content?.post ?? ""),
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
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        object.like!.any((element) =>
                                                element.id ==
                                                widget.userProfile!.userId)
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined,
                                        color: object.like!.any((element) =>
                                                element.id ==
                                                widget.userProfile!.userId)
                                            ? ColorResources.RED
                                            : ColorResources.GRAY_TEXT_COLOR,
                                      )),
                                  Text(
                                    "${object.likeCount}",
                                    style: poppinsMedium.copyWith(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              object.topic != null
                                  ? Text(
                                      "#${object.topic!.name}",
                                      style: poppinsMedium.copyWith(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    )
                                  : const SizedBox(),
                              Text(
                                "${object.comments!.length} comments",
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
                                        object.like!.any((element) =>
                                                element.id ==
                                                widget.userProfile!.userId)
                                            ? await Provider.of<TribeProvider>(
                                                    context,
                                                    listen: false)
                                                .likePost(
                                                    object.id!,
                                                    widget.userProfile!.userId!,
                                                    false,
                                                    false)
                                            : await Provider.of<TribeProvider>(
                                                    context,
                                                    listen: false)
                                                .likePost(
                                                    object.id!,
                                                    widget.userProfile!.userId!,
                                                    true,
                                                    false);
                                        await _getFeed();

                                        log(widget.tribeObj!.id!.toString());
                                      },
                                      icon: Icon(
                                        object.like!.any((element) =>
                                                element.id ==
                                                widget.userProfile!.userId)
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined,
                                        color: object.like!.any((element) =>
                                                element.id ==
                                                widget.userProfile!.userId)
                                            ? ColorResources.RED
                                            : ColorResources.GRAY_TEXT_COLOR,
                                      )),
                                  Text(
                                    " Like",
                                    style: poppinsMedium.copyWith(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(Images.icon_comment,
                                      height: 20, width: 20),
                                  Text(
                                    " Comment",
                                    style: poppinsMedium.copyWith(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Image.asset(Images.icon_post_share,
                              //         height: 20, width: 20),
                              //     Text(
                              //       " Share",
                              //       style: poppinsMedium.copyWith(
                              //         color: Colors.grey,
                              //         fontSize: 12,
                              //       ),
                              //     )
                              //   ],
                              // )
                            ],
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          recentCommentWidget(object),
                          const SizedBox(
                            height: 10,
                          ),
                          feedTextWidget(false, Cmtctrl[index], object),
                          Container(
                            height: 25,
                            width: MediaQuery.of(context).size.width,
                            color: ColorResources.SCREEN_BACKGROUND_COLOR,
                          )
                        ],
                      );
                    });
              }
              return snapWidgetHelper(snap);
            }));
  }

  Widget recentCommentWidget(Result object) {
    return ListView.builder(
        itemCount: object.comments!.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var commentObj = object.comments![index];
          return Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        height: 35,
                        width: 35,
                        fit: BoxFit.cover,
                        alignment: Alignment.centerLeft,
                        image: commentObj.createdBy!.profilePic ?? "",
                        imageErrorBuilder: (c, o, s) => Image.asset(
                          Images.instructor_placeholder,
                          fit: BoxFit.cover,
                          height: 35,
                          width: 35,
                        ),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorResources.APP_BACKGROUND_COLOR,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.only(top: 15, left: 15),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${commentObj.createdBy!.firstName} ${commentObj.createdBy!.lastName!}",
                                  style: poppinsBold.copyWith(
                                    color: Colors.black,
                                    fontSize: 14,
                                  )),
                              Text(
                                removeHtmlTags(commentObj.comment!),
                                // overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 500,
                                style: poppinsMedium.copyWith(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          // Positioned widget at the bottom right corner

                          Visibility(
                            visible: commentObj.likeCount != 0,
                            child: Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: ColorResources.APP_BACKGROUND_COLOR,
                                    borderRadius: BorderRadius.circular(2)),
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.favorite,
                                      color: ColorResources.RED,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      commentObj.likeCount.toString(),
                                      style: const TextStyle(
                                          color: ColorResources.GRAY_TEXT_COLOR,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 55,
                  ),
                  InkWell(
                    onTap: () async {
                      commentObj.like!.any((element) =>
                              element.id == widget.userProfile!.userId)
                          ? await Provider.of<TribeProvider>(context,
                                  listen: false)
                              .likePost(commentObj.id!,
                                  widget.userProfile!.userId!, false, true)
                          : await Provider.of<TribeProvider>(context,
                                  listen: false)
                              .likePost(commentObj.id!,
                                  widget.userProfile!.userId!, true, true);
                      await _getFeed();
                    },
                    child: Text(
                      "Like",
                      style: poppinsMedium.copyWith(
                        color: commentObj.like!.any((element) =>
                                element.id == widget.userProfile!.userId)
                            ? ColorResources.RED
                            : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isCommetWidgetId = commentObj.id;
                      });
                    },
                    child: Text(
                      "Reply",
                      style: poppinsMedium.copyWith(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: isCommetWidgetId == commentObj.id,
                child: commentTextWidget(object, commentObj),
              ),
              ListView.builder(
                  itemCount: commentObj.child!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 8, top: 8),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var commentReplyObj = commentObj.child![index];

                    return Column(children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 55,
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        Images.instructor_placeholder))),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: ColorResources.APP_BACKGROUND_COLOR,
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.only(top: 15, left: 15),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${commentReplyObj.createdBy!.firstName} ${commentObj.createdBy!.lastName!}",
                                        style: poppinsBold.copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                        )),
                                    Text(
                                      removeHtmlTags(commentReplyObj.comment!),
                                      style: poppinsMedium.copyWith(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                                Visibility(
                                  visible: commentReplyObj.likeCount != 0,
                                  child: Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: ColorResources
                                              .APP_BACKGROUND_COLOR,
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 5, right: 5),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            size: 15,
                                            Icons.favorite,
                                            color: ColorResources.RED,
                                          ),
                                          SizedBox(width: 2),
                                          Text(
                                            commentReplyObj.likeCount
                                                .toString(),
                                            style: const TextStyle(
                                                color: ColorResources
                                                    .GRAY_TEXT_COLOR,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 110,
                          ),
                          InkWell(
                            onTap: () async {
                              commentReplyObj.like!.any((element) =>
                                      element.id == widget.userProfile!.userId)
                                  ? await Provider.of<TribeProvider>(context,
                                          listen: false)
                                      .likePost(
                                          commentReplyObj.id!,
                                          widget.userProfile!.userId!,
                                          false,
                                          true)
                                  : await Provider.of<TribeProvider>(context,
                                          listen: false)
                                      .likePost(
                                          commentReplyObj.id!,
                                          widget.userProfile!.userId!,
                                          true,
                                          true);
                              await _getFeed();
                            },
                            child: Text(
                              "Like",
                              style: poppinsMedium.copyWith(
                                color: commentReplyObj.like!
                                        .any((element) => element.id == 89)
                                    ? ColorResources.RED
                                    : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ]);
                  })
            ],
          );
        });
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
              // _buildListItem(
              //   context,
              //   title: Text(
              //     getTranslated('GO_LIVE', context),
              //     style: poppinsRegular.copyWith(
              //         fontSize: Dimensions.FONT_SIZE_LARGE,
              //         color: Colors.black),
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuickPostScreen(
                              isFromTribe: true,
                              tribeId: widget.tribeObj!.id!.toString(),
                            )),
                  ).then((value) => _getFeed());
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
                      builder: (context) => LongPostScreen(
                            tribeId: widget.tribeObj!.id,
                          )),
                ).then((value) => _getFeed());
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

  int calculateDaysAgo(String dateTimeString) {
    DateTime now = DateTime.now();
    DateTime postedTime = DateTime.parse(dateTimeString);
    Duration difference = now.difference(postedTime);
    int daysAgo = difference.inDays;
    return daysAgo;
  }

 

  Widget commentTextWidget(Result object, Comment cmt) {
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
                //  focusNode: chatMessageFocusNode,
                keyboardType: TextInputType.multiline,
                controller: messageController,
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
                    hintText: 'Write a Reply',
                    suffixIconColor: MaterialStateColor.resolveWith((states) =>
                        states.contains(MaterialState.focused)
                            ? Colors.grey.shade700
                            : Colors.grey.shade500),
                    suffixIcon: IconButton(
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
              IconButton(
                onPressed: () async {
                  if (messageController.text.isNotEmpty) {
                    String sendMessage = messageController.text;
                    //  chatMessageFocusNode.unfocus();
                    messageController.clear();
                    setState(() {
                      message = "";
                      emojiShowing = false;
                    });

                    CreatePostModel requestModel = CreatePostModel(
                        commnet: sendMessage,
                        image: null,
                        parent: cmt.id,
                        timeline: object.id);
                    isCommetWidgetId = -1;

                    await Provider.of<TribeProvider>(context, listen: false)
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
}
