import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/comment_model.dart';
import 'package:joy_society/data/model/response/create_post_model.dart';
import 'package:joy_society/data/model/response/post_model.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../utill/custom_themes.dart';

class PostCardComment extends StatefulWidget {
  final PostModel post;
  ProfileModel? userProfile;
  String profilePic;
  final PostCommentModel comment;
  final bool replyingCapability;

  PostCardComment(
      {super.key,
      required this.post,
      required this.profilePic,
      this.userProfile,
      required this.comment,
      required this.replyingCapability});

  @override
  State<PostCardComment> createState() => _PostCardCommentState();
}

class _PostCardCommentState extends State<PostCardComment> {
  late bool isCommentLiked;
  late int likeCount;
  late FocusNode chatMessageFocusNode;
  late List<PostCommentModel> children;
  bool showReplies = false;
  final messageController = TextEditingController();
  String userFirstName = "";
  String userLastName = "";
  bool isReplyToBeAdded = false;
  String message = "";
  bool emojiShowing = false;

  ProfileModel? profile;

  @override
  void initState() {
    super.initState();
    chatMessageFocusNode = FocusNode();
    likeCount = widget.comment.likeCount ?? 0;
    children = widget.comment.children ?? [];
    isCommentLiked = widget.comment.likes!
        .any((element) => element.id == widget.userProfile?.userId);
    profile = Provider.of<ProfileProvider>(context, listen: false).profileModel;
    // userFirstName = profile!.fullName!.split(" ").first;
    // userLastName = profile!.fullName!.split(" ").last;
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   setState(() {
  //     message = "";
  //   });
  //   chatMessageFocusNode.dispose();
  //   messageController.dispose();
  //   super.dispose();
  // }

  String removeHtmlTags(String input) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return input.replaceAll(exp, '');
  }

  int calculateDaysAgo(String dateTimeString) {
    DateTime now = DateTime.now();
    DateTime postedTime = DateTime.parse(dateTimeString);
    Duration difference = now.difference(postedTime);
    int daysAgo = difference.inDays;
    return daysAgo;
  }

  _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
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

  Widget commentTextWidget() {
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
                  height: 35,
                  width: 35,
                  placeholder: kTransparentImage,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                  image: profile!.profilePic!,
                  imageErrorBuilder: (c, o, s) => Image.asset(
                    height: 35,
                    width: 35,
                    Images.instructor_placeholder,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: TextField(
                focusNode: chatMessageFocusNode,
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
                    chatMessageFocusNode.unfocus();
                    messageController.clear();
                    setState(() {
                      message = "";
                      emojiShowing = false;
                      isReplyToBeAdded = false;
                    });

                    CreatePostModel requestModel = CreatePostModel(
                        commnet: sendMessage,
                        image: null,
                        parent: widget.comment.id,
                        timeline: widget.post.id);

                    Provider.of<WorkshopProvider>(context, listen: false)
                        .createCommentForPost(
                            requestModel, AppConstants.ADD_CMT, (bool isSuccess,
                                PostCommentModel? response,
                                ErrorResponse? error) {
                      if (isSuccess) {
                        response!.createdBy = PostUserModel(
                            firstName: userFirstName,
                            lastName: userLastName,
                            profilePic: widget.profilePic,
                            id: profile!.userId!);
                        setState(() {
                          widget.comment.children = [
                            ...widget.comment.children!,
                            response
                          ];
                          showReplies = true;
                        });
                      } else {
                        _showToast(context,
                            error!.errorDescription ?? "Error Occurred");
                      }
                    });
                    // widget.effect();
                    // setState(() {});
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
    return Column(
      children: [
        Row(
          children: [
            if (!widget.replyingCapability)
              const SizedBox(
                width: 50,
              ),
            (widget.comment.createdBy!.id == profile!.userId)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: FadeInImage.memoryNetwork(
                      height: 35,
                      width: 35,
                      placeholder: kTransparentImage,
                      fit: BoxFit.cover,
                      alignment: Alignment.centerLeft,
                      image: widget.profilePic ?? "",
                      imageErrorBuilder: (c, o, s) => Image.asset(
                        height: 35,
                        width: 35,
                        Images.instructor_placeholder,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: FadeInImage.memoryNetwork(
                      height: 35,
                      width: 35,
                      placeholder: kTransparentImage,
                      fit: BoxFit.cover,
                      alignment: Alignment.centerLeft,
                      image: widget.comment.createdBy!.profilePic ?? "",
                      imageErrorBuilder: (c, o, s) => Image.asset(
                        height: 35,
                        width: 35,
                        Images.instructor_placeholder,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: ColorResources.APP_BACKGROUND_COLOR,
                    borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 15, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${profile!.fullName}",
                              style: poppinsBold.copyWith(
                                color: Colors.black,
                                fontSize: 13,
                              )),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            removeHtmlTags(widget.comment.comment),
                            // overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 500,
                            style: poppinsMedium.copyWith(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                    // Positioned widget at the bottom right corner
                    Visibility(
                      visible: widget.comment.likeCount != 0,
                      child: Positioned(
                        bottom: -8,
                        right: -8,
                        child: Card(
                          shape: const CircleBorder(),
                          elevation: 1,
                          child: Container(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    color: ColorResources.RED,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    widget.comment.likeCount.toString(),
                                    style: poppinsBold.copyWith(
                                        color: ColorResources.GRAY_TEXT_COLOR,
                                        fontSize: 10),
                                  ),
                                ],
                              )),
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
        Stack(
          children: [
            Row(
              children: [
                widget.replyingCapability
                    ? const SizedBox(
                        width: 55,
                      )
                    : const SizedBox(
                        width: 105,
                      ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      isCommentLiked = !isCommentLiked;
                      widget.comment.likeCount = widget.comment.likes!
                              .any((element) => element.id == profile!.userId)
                          ? widget.comment.likeCount! - 1
                          : widget.comment.likeCount! + 1;
                    });
                    widget.comment.likes!
                            .any((element) => element.id == profile!.userId)
                        ? await Provider.of<WorkshopProvider>(context,
                                listen: false)
                            .likePost(widget.comment.id, profile!.userId!,
                                false, true)
                        : await Provider.of<WorkshopProvider>(context,
                                listen: false)
                            .likePost(widget.comment.id, profile!.userId!, true,
                                true);
                    setState(() {
                      widget.comment.likes = widget.comment.likes!
                              .any((element) => element.id == profile!.userId)
                          ? widget.comment.likes!
                              .where(
                                  (element) => element.id != profile!.userId!)
                              .toList()
                          : [
                              ...widget.comment.likes!,
                              PostUserModel(
                                  id: profile!.userId!,
                                  firstName: userFirstName,
                                  lastName: userLastName)
                            ];
                    });
                  },
                  child: Text(
                    "Like",
                    style: poppinsMedium.copyWith(
                      color: widget.comment.likes!
                              .any((element) => element.id == profile!.userId)
                          ? ColorResources.RED
                          : Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                    visible: widget.replyingCapability,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isReplyToBeAdded = !isReplyToBeAdded;
                        });
                      },
                      child: Text(
                        "Reply",
                        style: poppinsMedium.copyWith(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Visibility(
                  visible: children.isNotEmpty,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        showReplies = !showReplies;
                      });
                    },
                    child: !showReplies
                        ? Text(
                            "Show Replies (${children.length})",
                            style: poppinsMedium.copyWith(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          )
                        : Text(
                            "Hide Replies",
                            style: poppinsMedium.copyWith(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                  ),
                )
              ],
            ),
          ],
        ),
        Visibility(
          visible: isReplyToBeAdded && widget.replyingCapability,
          child: commentTextWidget(),
        ),
        showReplies
            ? ListView.builder(
                itemCount: widget.comment.children?.length ?? 0,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var commentObj = widget.comment.children![index];
                  return PostCardComment(
                      post: widget.post,
                      profilePic: widget.profilePic,
                      userProfile: profile,
                      replyingCapability: false,
                      comment: commentObj);
                })
            : const SizedBox(height: 16),
      ],
    );
    ;
  }
}
