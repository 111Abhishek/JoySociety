import 'package:flutter/cupertino.dart';
import 'package:joy_society/utill/color_resources.dart';

class ReceiverMessageWidget extends StatelessWidget {
  final String receiverMessage;
   ReceiverMessageWidget({Key? key, required this.receiverMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: AlignmentDirectional.topStart,
        child: Container(
          decoration: const BoxDecoration(
              color: ColorResources.WHITE,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          margin: const EdgeInsets.only(top: 25, right: 10),
          padding: const EdgeInsets.all(15),
          child:  Text(
            receiverMessage,
            style:const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ColorResources.BLACK),
          ),
        ));
  }
}
