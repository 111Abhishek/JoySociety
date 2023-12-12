import 'package:flutter/material.dart';

import '../../../../../utill/color_resources.dart';

class JoiningBottomList extends StatelessWidget {
  const JoiningBottomList({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 70),
      clipBehavior: Clip.none,
      decoration: const BoxDecoration(
        color: ColorResources.WHITE,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(50), topLeft: Radius.circular(50)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_buildHandle(context), child],
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
          children: const [
            SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
