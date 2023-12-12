import 'package:joy_society/utill/images.dart';

enum MembershipBadgeEnum {
  membership(Images.membershipBadgeImage),
  goal(Images.goalBadgeImage),
  engagement(Images.engagementBadgeImage),
  tribe(Images.tribeBadgeImage);

  const MembershipBadgeEnum(this.value);

  final String value;

  factory MembershipBadgeEnum.fromType(String type) {
    switch (type.toLowerCase()) {
      case "membership":
        {
          return MembershipBadgeEnum.membership;
        }
      case "goal":
        {
          return MembershipBadgeEnum.goal;
        }
      case "engagement":
        {
          return MembershipBadgeEnum.engagement;
        }
      case "tribe":
        {
          return MembershipBadgeEnum.tribe;
        }
      default:
        {
          return MembershipBadgeEnum.membership;
        }
    }
  }
}
