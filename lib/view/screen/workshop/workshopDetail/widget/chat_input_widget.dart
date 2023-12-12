import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatInputWidget extends StatefulWidget {
  const ChatInputWidget({super.key, required this.channelId});

  final int channelId;

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  late FocusNode chatMessageFocusNode;

  final messageController = TextEditingController();

  String message = "";
  bool emojiShowing = false;

  @override
  void initState() {
    super.initState();
    setState(() {});
    chatMessageFocusNode = FocusNode();
  }

  _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  @override
  void dispose() {
    setState(() {
      message = "";
    });
    chatMessageFocusNode.dispose();
    super.dispose();
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
  void onSend() async {
    if (messageController.text.isNotEmpty) {
      String sendMessage = messageController.text;
      chatMessageFocusNode.unfocus();
      messageController.clear();
      setState(() {
        message = "";
        emojiShowing = false;
      });
      await Provider.of<WorkshopProvider>(context, listen: false)
          .sendChat(widget.channelId, sendMessage,
              (bool isStatusSuccess, ErrorResponse? errorResponse) {
        if (isStatusSuccess) {
        } else {
          _showToast(context, "Cannot send message at the moment");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    hintText: 'Enter Message',
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
                onPressed: onSend,
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
                      ), // Needs to be const Widget
                      loadingIndicator:
                          SizedBox.shrink(), // Needs to be const Widget
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                    )),
              ))
        ]));
  }
}
