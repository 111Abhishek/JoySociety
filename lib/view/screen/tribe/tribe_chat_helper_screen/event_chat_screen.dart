

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/workshop_chats/channel_info_model.dart';
import 'package:joy_society/provider/event_provider.dart';
import 'package:joy_society/provider/tribe_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/screen/event/chat_screeens/chat_main_screen.dart';
import 'package:provider/provider.dart';

import '../../workshop/workshopDetail/chat_main_screen.dart';

class TribeChatScreen extends StatefulWidget {
  const TribeChatScreen({super.key, required this.id ,required this.isfromEvent});

  final int id;
  final bool isfromEvent;

  @override
  State<TribeChatScreen> createState() => _TribeChatScreenState();
}

class _TribeChatScreenState extends State<TribeChatScreen> {
  int id = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChannelInfoModel>(
        future: Provider.of<TribeProvider>(context, listen: false)
            .fetchChannelInfo(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            id = snapshot.data!.id;
            return EventChatScreenWidget(
              isfromEvent: widget.isfromEvent,
              channelId: id,
            );
          }
          return Loader();
        },
      );
  }
}
