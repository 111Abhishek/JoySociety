import 'dart:async';

import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/workshop_chats/workshop_chat_model.dart';
import 'package:joy_society/provider/event_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/screen/workshop/workshopDetail/widget/chat_input_widget.dart';
import 'package:joy_society/view/screen/workshop/workshopDetail/widget/chat_section_widget.dart';
import 'package:provider/provider.dart';

class EventChatScreenWidget extends StatefulWidget {
  const EventChatScreenWidget(
      {super.key, required this.channelId, required this.isfromEvent});

  final int channelId;
  final bool isfromEvent;
  @override
  State<EventChatScreenWidget> createState() => _EventChatScreenWidgetState();
}

class _EventChatScreenWidgetState extends State<EventChatScreenWidget> {
  final StreamController<List<ChatModel>> _chatStreamController =
      StreamController();

  @override
  void dispose() {
    super.dispose();
    _chatStreamController.onCancel;
  }

  @override
  void initState() {
    super.initState();

    fetchChatForEventChannel();

    Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchChatForEventChannel();
    });
  }

  Future<void> fetchChatForEventChannel() async {
    List<ChatModel> chats =
        await Provider.of<EventProvider>(context, listen: false)
            .getPreviousChats(AppConstants.EventMessageUrl, widget.channelId);
    _chatStreamController.sink.add(chats);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex: 8,
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
        Flexible(
            flex: widget.isfromEvent ? 0 : 2,
            child: ChatInputWidget(channelId: widget.channelId)),
      ],
    );
  }
}
