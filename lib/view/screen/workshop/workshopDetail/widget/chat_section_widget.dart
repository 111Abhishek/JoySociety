import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/workshop_chats/workshop_chat_model.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/view/screen/workshop/workshopDetail/widget/chat_pill_row.dart';

class ChatSection extends StatefulWidget {
  const ChatSection({super.key, required this.chats});

  final List<ChatModel> chats;

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: widget.chats.isNotEmpty
            ? ListView.builder(
                reverse: true,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.chats.length,
                itemBuilder: (context, index) {
                  return ChatPillRow(chat: widget.chats[index]);
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("👋"),
                  const SizedBox(height: 8),
                  Text("Say hello and share a little about yourself", style: poppinsSemiBold.copyWith(fontSize: 12, color: Colors.black54))
                ],
              )));
  }
}
