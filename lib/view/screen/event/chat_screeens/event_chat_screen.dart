import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/workshop_chats/channel_info_model.dart';
import 'package:joy_society/provider/event_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/screen/event/chat_screeens/chat_main_screen.dart';
import 'package:provider/provider.dart';

import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/images.dart';
import '../../workshop/workshopDetail/chat_main_screen.dart';

class EventChatScreen extends StatefulWidget {
  const EventChatScreen(
      {super.key, required this.eventId, required this.isfromEvent});

  final int eventId;
  final bool isfromEvent;

  @override
  State<EventChatScreen> createState() => _EventChatScreenState();
}

class _EventChatScreenState extends State<EventChatScreen> {
  int id = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Image.asset(
                Images.logo_with_name_image,
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 10),
              Text(
                "Event Chat",
                style: poppinsBold.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          elevation: 0.5,
          backgroundColor: ColorResources.WHITE,
        ),
        body: FutureBuilder<ChannelInfoModel>(
          future: Provider.of<EventProvider>(context, listen: false)
              .fetchChannelInfo(widget.eventId),
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
        ),
      ),
    );
  }
}
