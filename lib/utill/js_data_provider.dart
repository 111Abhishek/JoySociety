import 'dart:ffi';

import 'package:joy_society/data/model/js_model.dart';
import 'package:joy_society/data/model/response/member_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/view/screen/billingDetail/billing_details_screen.dart';
import 'package:joy_society/view/screen/home/home_screen.dart';
import 'package:joy_society/view/screen/invoices/invoices_screen.dart';
import 'package:joy_society/view/screen/members/sentInvites/widget/top_data_send_invites_model.dart';
import 'package:joy_society/view/screen/members_screen/widgets/members_screeen.dart';
import 'package:joy_society/view/screen/needHelp/NeedHelpScreen.dart';
import 'package:joy_society/view/screen/profile/badges/profile_badges_screen.dart';
import 'package:joy_society/view/screen/profile/profile_settings_screen.dart';
import 'package:joy_society/view/screen/schedulePost/schedule_post_screen.dart';
import 'package:joy_society/view/screen/sound/sound_screen.dart';
import 'package:joy_society/view/screen/textMeTheApp/text_me_the_app_screen.dart';
import 'package:joy_society/view/screen/topic/topicList/select_topic.dart';
import 'package:joy_society/view/screen/topic/topicList/topics_list_screen.dart';
import 'package:joy_society/view/screen/true_success_evaluation/true_success_evaluation.dart';
import 'package:joy_society/view/screen/updateEmailAndPassword/update_email_and_password_screen.dart';

import '../view/screen/networkSetting/network_setting_screen.dart';

List<DrawerItemModel> getDrawerItems() {
  List<DrawerItemModel> drawerItems = [];
  drawerItems.add(DrawerItemModel(title: 'Home'));
  drawerItems
      .add(DrawerItemModel(title: 'Members', widget: const MembersScreen()));
  // drawerItems.add(DrawerItemModel(title: 'About', widget: HomeScreen()));
  drawerItems.add(DrawerItemModel(title: 'Topic', widget: SelectTopic()));
  drawerItems.add(DrawerItemModel(title: 'Events', widget: HomeScreen()));
  drawerItems.add(DrawerItemModel(title: 'Tribes', widget: HomeScreen()));
  drawerItems.add(DrawerItemModel(title: 'Workshops', widget: HomeScreen()));
  drawerItems.add(DrawerItemModel(
      title: 'Tru Success Evaluation', widget: const TrueSuccessEvaluation()));
  drawerItems
      .add(DrawerItemModel(title: 'Goal Setting', widget: HomeScreen()));
  // drawerItems.add(DrawerItemModel(title: 'Settings', widget: HomeScreen()));
  drawerItems
      .add(DrawerItemModel(title: 'Need Help?', widget: NeedHelpScreen()));
  return drawerItems;
}

List<DrawerItemModel> getProfileMenuSettingItems() {
  List<DrawerItemModel> drawerItems = [];
  drawerItems.add(
      DrawerItemModel(title: 'Profile Edit', widget: ProfileSettingsScreen()));
  drawerItems.add(DrawerItemModel(
      title: 'Update email and password',
      widget: UpdateEmailAndPasswordScreen()));
  // drawerItems
  //     .add(DrawerItemModel(title: 'Billing', widget: BillingDetailsScreen()));
  // drawerItems.add(DrawerItemModel(title: 'Invoices', widget: InvoiceScreen()));
  drawerItems.add(
      DrawerItemModel(title: 'Badges', widget: const ProfileBadgeScreen()));
  // drawerItems.add(
  //     DrawerItemModel(title: 'Notification Settings', widget: HomeScreen()));
  // drawerItems
  //     .add(DrawerItemModel(title: 'Sound Settings', widget: SoundScreen()));
  drawerItems.add(
      DrawerItemModel(title: 'Schedule a Post', widget: SchedulePostScreen()));
  // drawerItems.add(DrawerItemModel(title: 'Zoom', widget: HomeScreen()));
  // drawerItems.add(DrawerItemModel(title: 'Saved Drafts', widget: HomeScreen()));
  // drawerItems.add(
  //     DrawerItemModel(title: 'Livestream Recordings', widget: HomeScreen()));
  // drawerItems.add(DrawerItemModel(title: 'Get Started', widget: HomeScreen()));
  // drawerItems.add(DrawerItemModel(
  //     title: 'Network Settings', widget: NetworkSettingScreen()));
  return drawerItems;
}

List<MemberModel> getPeopleData() {
  List<MemberModel> items = [];

  for (int i = 0; i < peopleNames.length; i++) {
    MemberModel obj = MemberModel(
        id: 1,
        name: peopleNames[i],
        description: title_header_auto[i],
        order: i);
    items.add(obj);
  }
  items.shuffle();
  return items;
}

const List<String> peopleNames = [
  "Anderson Thomas",
  "Adams Green",
  "Laura Michelle",
  "Betty L",
  "Miller Wilson",
  "Anderson Thomas",
  "Anderson Thomas"
];

const List<String> title_header_auto = [
  "Dui fringilla ornare finibus, orci odio",
  "Mauris sagittis non elit quis fermentum",
  "Mauris ultricies augue sit amet est sollicitudin",
  "Suspendisse ornare est ac auctor pulvinar",
  "Vivamus laoreet aliquam ipsum eget pretium",
  "Suspendisse ornare est ac auctor pulvinar",
  "Vivamus laoreet aliquam ipsum eget pretium",
];

List<TopDataSendInvitesModel> getSentInvitesTopData() {
  List<TopDataSendInvitesModel> items = [];

  for (int i = 0; i < 4; i++) {
    TopDataSendInvitesModel obj =
        TopDataSendInvitesModel(title: "Sent", data: "50");
    items.add(obj);
  }
  items.shuffle();
  return items;
}

const List<String> sphere_emotional_goals = [
  "Seek out knowledge/activities that further my personal growth",
  "Improve my self-esteem",
  "Learn how to recognize, express, and process my emotions effectively",
  "Address negative impacts of past traumatic/impactful life experiences",
  "Seek support from friends & family",
  "Learn & implement the skills to manage burnout, stress, and anxiety"
];

const List<String> sphere_spiritual_goals = [
  "Gain clarity about my life purpose",
  "Align my daily decisions and behaviors with what I know to be my life purpose",
  "Explore a connection to a higher power",
  "Begin or deepen a spiritual practice",
  "Seek out/engage in activities that contribute to my spiritual health",
  "Seek out knowledge that furthers my spiritual growth"
];

const List<String> sphere_careeer_goals = [
  "Explore/learn about an alternate career or industry",
  "Begin (or continue) working toward a new certification, license, or skill",
  "Gain clarity on my career aspirations",
  "Seek a promotion (or new role) that aligns with my skillsets & passion",
  "Learn time management skills for improved outcomes",
  "Seek support/guidance from supervisor(s) or career mentor"
];

const List<String> sphere_financial_goals = [
  "Increase my savings",
  "Invest money for retirement or other long-term plans",
  "Seek a position with a higher salary",
  "Create or enhance my budget plan",
  "Improve my financial literacy",
  "Spend less money eating out"
];

const List<String> sphere_physical_goals = [
  "Increase my water intake",
  "Adjust my diet to better support my overall physical health",
  "Begin or enhance a physical exercise plan",
  "Improve my sleep hygiene",
  "Seek medical attention to address or monitor current health concern(s)",
  "Begin a vitamin regimen"
];

const List<String> sphere_social_goals = [
  "Seek out new opportunities to connect with my community",
  "Improve my communication skills",
  "Engage in a new social or recreational activity",
  "Seek out new, healthy social connection(s)/friends",
  "Gain clarity on what I value in friends and social connections",
  "Spend more time with my friends"
];

const List<String> sphere_romantic_goals = [
  "Seek a relationship that honors my value",
  "End a relationship that no longer serves me",
  "Improve my ability to enjoy healthy physical and/or emotional intimacy",
  "Gain clarity on what I value in a romantic/intimate partner",
  "Improve my communication skills",
  "Define and implement healthier boundaries with my intimate partner(s)"
];

const List<String> sphere_family_goals = [
  "Spend more quality time with my family",
  "Create a more peaceful home environment",
  "Improve my communication skills",
  "Define and implement healthier boundaries with my family",
  "Discontinue family relationships that are toxic",
  "Balance my caregiving committments with time for myself"
];
