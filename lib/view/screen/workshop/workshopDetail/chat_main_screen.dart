import 'dart:async';

import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/workshop_chats/workshop_chat_model.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/system_utils.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/screen/workshop/workshopDetail/widget/chat_input_widget.dart';
import 'package:joy_society/view/screen/workshop/workshopDetail/widget/chat_section_widget.dart';
import 'package:provider/provider.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({super.key, required this.channelId});

  final int channelId;

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  StreamController<List<ChatModel>> _chatStreamController = StreamController();

  @override
  void dispose() {
    super.dispose();
    log("Stream closed");
    _chatStreamController.close();
  }

  @override
  void initState() {
    super.initState();
    _chatStreamController = StreamController<List<ChatModel>>();

    fetchChatForWorkshopChannel();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchChatForWorkshopChannel();
    });
  }

  Future<void> fetchChatForWorkshopChannel() async {
    List<ChatModel> chats = await Provider.of<WorkshopProvider>(context,
            listen: false)
        .getWorkshopChats(AppConstants.WorkshopMessageUrl, widget.channelId);
    _chatStreamController.sink.add(chats);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
            child: StreamBuilder<List<ChatModel>>(
          stream: _chatStreamController.stream,
          builder: (context, snapdata) {
            switch (snapdata.connectionState) {
              case ConnectionState.waiting:
                return Loader();
              default:
                if (snapdata.hasError) {
                  return const Center(child: Text('Please wait...'));
                } else {
                  return ChatSection(chats: snapdata.data!);
                }
            }
          },
        )),
        ChatInputWidget(channelId: widget.channelId),
      ],
    ));
  }
}
