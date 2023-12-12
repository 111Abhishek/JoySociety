import 'package:flutter/material.dart';
import 'package:joy_society/utill/color_resources.dart';


class InviteSentBottomSheetWidget extends StatelessWidget {
  const InviteSentBottomSheetWidget({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 70),
      clipBehavior: Clip.none,
      decoration: const BoxDecoration(
        color: ColorResources.WHITE,
        borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildHandle(context), if (child != null) child],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    return FractionallySizedBox(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Images.logo_with_name_image, height: 40, width: 40),
                const SizedBox(width: 16),
                Text(getTranslated('CREATE_POST', context),
                    style:
                        poppinsBold.copyWith(fontSize: 20, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
