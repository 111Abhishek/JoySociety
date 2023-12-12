import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/utill/color_resources.dart';

class EmojiSelector extends StatefulWidget {
  final TextEditingController controller;

  const EmojiSelector({super.key, required this.controller});

  @override
  State<EmojiSelector> createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector> {
  _onBackspacePressed() {
    widget.controller
      ..text = widget.controller.text.characters.toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
          onEmojiSelected: (category, emoji) {},
          textEditingController: widget.controller,
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
    );
  }
}
