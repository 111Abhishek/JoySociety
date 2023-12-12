import 'package:flutter/material.dart';
import 'package:joy_society/utill/color_resources.dart';

class SenderMessageWidget extends StatelessWidget {
  final String senderMessage;
 SenderMessageWidget({Key? key, required this.senderMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: AlignmentDirectional.topEnd,
        child: Container(
          decoration: const BoxDecoration(
              color: ColorResources.CHAT_ICON_COLOR,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          margin: const EdgeInsets.only(top: 25, left: 10),
          padding: const EdgeInsets.all(15),
          child: Text(
            senderMessage,
            style:const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ColorResources.BLACK),
          ),
        ));
  }
}
