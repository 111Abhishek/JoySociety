import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/workshop_chats/workshop_chat_model.dart';
import 'package:joy_society/view/screen/workshop/workshopDetail/widget/chat_pill.dart';

class ChatPillRow extends StatelessWidget {
  const ChatPillRow({super.key, required this.chat});

  final ChatModel chat;

  String beautifyMessage(String message) {
    if (message != "") {
      return message.substring(5, chat.message.length - 6);
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment:
              !chat.author ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            ChatPill(sender: chat.sender!, author: chat.author, message: beautifyMessage(chat.message), time: chat.timestamp!)
          ],
        ));
  }
}
