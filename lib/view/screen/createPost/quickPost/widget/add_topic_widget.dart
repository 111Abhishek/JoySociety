import 'package:flutter/material.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';

class AddTopicWidget extends StatelessWidget {
  const AddTopicWidget({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 30.0),
      clipBehavior: Clip.none,
      decoration: const BoxDecoration(
        color: Colors.white,
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
        margin: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(Images.logo_with_name_image, height: 40, width: 40),
                const SizedBox(width: 16),
                Text(getTranslated('ADD_TOPIC', context),
                    style:
                        poppinsBold.copyWith(fontSize: 20, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            /*Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              width: MediaQuery.of(context).size.width,
              child: TextField(
                style: const TextStyle(),
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_outlined),
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    focusColor: ColorResources.GREEN,
                    hintText: getTranslated('HINT_SEARCH', context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
