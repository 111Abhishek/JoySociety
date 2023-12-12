import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joy_society/data/model/response/workshop_profile_model.dart';
import 'package:joy_society/utill/custom_themes.dart';

import '../../../../../utill/images.dart';

class ChatPill extends StatelessWidget {
  const ChatPill(
      {super.key,
      required this.sender,
      required this.author,
      required this.message,
      required this.time});

  final WorkshopProfileModel sender;
  final bool author;
  final String message;
  final String time;

  String convertTime(String time) {
    return DateFormat.jm().format(DateTime.parse(time).toLocal()).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          !author
              ? Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(Images.instructor_placeholder))),
                )
              : const SizedBox(),
          !author
              ? const SizedBox(
                  width: 8,
                )
              : const SizedBox(),
          Container(
            constraints: const BoxConstraints(minWidth: 180),
            decoration: author
                ? const BoxDecoration(
                    color: Color(0xFFd7f7d3),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)))
                : const BoxDecoration(
                    color: Color(0xFFF4F6FA),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(sender.fullName,
                        style: poppinsSemiBold.copyWith(
                            fontSize: 12, color: Colors.black)),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(convertTime(time),
                        style: poppinsRegular.copyWith(
                            fontSize: 11, color: Colors.black45))
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(message,
                    softWrap: true,
                    style: poppinsRegular.copyWith(
                        fontSize: 12, color: Colors.black87))
              ],
            ),
          )
        ]));
  }
}
