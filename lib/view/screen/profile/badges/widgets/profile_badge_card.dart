import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/user_profile/badges/user_profile_badge_model.dart';
import 'package:joy_society/utill/badges/membership_badge_enum.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';

class ProfileBadgeCard extends StatelessWidget {
  const ProfileBadgeCard({super.key, required this.badgeModel});

  final UserProfileBadgeModel badgeModel;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
        decoration: const BoxDecoration(
            color: ColorResources.WHITE,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            MembershipBadgeEnum.fromType(badgeModel.type!)
                                .value))),
              ),

                  Center(child: Text(badgeModel.title!,
                      softWrap: true,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: poppinsSemiBold.copyWith(
                          fontSize: 12, color: Colors.grey.shade800)))
            ]));
  }
}
