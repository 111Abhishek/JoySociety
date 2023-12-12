import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/workshop_chats/channel_info_model.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:provider/provider.dart';

import 'chat_main_screen.dart';

class WorkshopChatScreen extends StatefulWidget {
  const WorkshopChatScreen({super.key, required this.workshopId});

  final int workshopId;

  @override
  State<WorkshopChatScreen> createState() => _WorkshopChatScreenState();
}

class _WorkshopChatScreenState extends State<WorkshopChatScreen> {
  int id = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChannelInfoModel>(
        future: Provider.of<WorkshopProvider>(context, listen: false)
            .fetchChannelInformation(widget.workshopId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            id = snapshot.data!.id;
            return ChatMainScreen(
              channelId: id,
            );
          }
          return Loader();
        },
      );
  }
}
