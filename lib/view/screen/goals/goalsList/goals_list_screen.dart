import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joy_society/data/model/response/goal_list_response_model.dart';
import 'package:joy_society/data/model/response/goal_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/dialog/app_dialog.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/basewidget/widgets.dart';
import 'package:joy_society/view/screen/members/sentInvites/widget/invite_sent_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

import '../progressCompletePage.dart/progress_complete_page.dart';
import '../reflection3/goal_reflection3_screen.dart';
import '../reflection4/goal_reflection4_screen.dart';

class GoalsListScreen extends StatefulWidget {
  final String? status;
  const GoalsListScreen({Key? key, required this.status}) : super(key: key);

  @override
  State<GoalsListScreen> createState() => _GoalsListScreenState();
}

class _GoalsListScreenState extends State<GoalsListScreen> {
  List<GoalModel> data = [];

  bool isLoading = false;
  bool isLastPage = false;

  bool load = false;
  int page = 1;

  int selectedIndex = -1;
  String searchText = '';
  var inputFormatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  var outputFormatter = new DateFormat("d, MMM yyyy");

  @override
  void initState() {
    super.initState();
    init();
    setListener();
  }

  init() async {
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void setListener() {}

  void _bottomSheetForStatus() {
    showModalBottomSheet<int>(
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        //for bottom post
        return InviteSentBottomSheetWidget(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              showReminderDialog());
                    },
                    child: _buildListItem(
                      context,
                      title: Text(
                        getTranslated('ACHIEVED_GOALS', context),
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              showRevokeDialog());
                    },
                    child: _buildListItem(
                      context,
                      title: Text(
                        getTranslated('REVOKE', context),
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget showReminderDialog() {
    return AppDialog(
      context: context,
      cancelOnPressed: cancelOnPressed,
      submitOnPressed: submitOnPressed,
      title: getTranslated("reminder_dialog_title", context),
      content: getTranslated("reminder_dialog_desc", context),
      cancelButtonText: getTranslated('SEND_AN_EXTRA_REMINDER', context),
      submitButtonText: getTranslated('STICK_TO_THIS_SCHEDULE', context),
      isButtonLayoutVertical: true,
    );
  }

  Widget showRevokeDialog() {
    return AppDialog(
      context: context,
      cancelOnPressed: cancelOnPressed,
      submitOnPressed: submitOnPressed,
      title: getTranslated("reminder_dialog_title", context),
      content: getTranslated("reminder_dialog_desc", context),
      cancelButtonText: getTranslated('CANCEL', context),
      submitButtonText: getTranslated('REVOKE', context),
    );
  }

  Widget _buildListItem(
    BuildContext context, {
    Widget? title,
    Widget? leading,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 0.0,
        vertical: 10.0,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorResources.NAVIGATION_DIVIDER_COLOR,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (leading != null) leading,
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: DefaultTextStyle(
                style: poppinsRegular.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.black),
                child: title,
              ),
            ),
          const Spacer(),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  void cancelOnPressed() {
    Navigator.pop(context);
  }

  void submitOnPressed() {
    Navigator.pop(context);
  }

  String getTitle() {
    String title = "Achieved Goals";
    if (widget.status == "Achieved") {
      title = getTranslated('ACHIEVED_GOALS', context);
    } else if (widget.status == "In Progress") {
      title = getTranslated('PENDING_GOALS', context);
    }
    return title;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: NotificationListener(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo is ScrollEndNotification) {
              if (!isLastPage &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent &&
                  !load) {
                page++;
                load = true;
                isLoading = true;
                setState(() {});
              }
            }
            return isLastPage;
          },
          child: FutureBuilder<GoalListResponseModel?>(
            future: Provider.of<GoalProvider>(context, listen: false)
                .getGoalsList(
                    page, searchText, widget.status, AppConstants.GOAL),
            builder: (_, snap) {
              if (snap.hasData) {
                if (snap.data!.data != null) {
                  isLastPage = snap.data!.data!.length != 20;
                } else {
                  isLastPage = true;
                }

                if (page == 1) data.clear();

                GoalModel? matchedDataInList;
                if (data.length > 0 &&
                    snap.data != null &&
                    snap.data!.data != null) {
                  for (int i = 0; i < snap.data!.data!.length; i++) {
                    if (snap.data!.data![i].id == data[data.length - 1].id) {
                      matchedDataInList = data[data.length - 1];
                    }
                  }
                }
                if (matchedDataInList == null &&
                    snap.data != null &&
                    snap.data!.data != null) {
                  data.addAll(snap.data!.data!);
                }
                load = false;

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 48, left: 8),
                      child: Row(children: [
                        CupertinoNavigationBarBackButton(
                          onPressed: () => Navigator.of(context).pop(),
                          color: Colors.black,
                        ),
                        Image.asset(Images.logo_with_name_image,
                            height: 40, width: 40),
                        const SizedBox(width: 10),
                        Text(getTitle(),
                            style: poppinsBold.copyWith(
                                fontSize: 20, color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      itemCount: data.length,
                      padding: const EdgeInsets.only(bottom: 8, top: 8),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var object = data[index];

                        return GestureDetector(
                          onTap: () {
                            if (widget.status == "In Progress") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ProgressCompletePage(
                                            goalMOdel: data[index],
                                          )));
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 20),
                                margin: const EdgeInsets.only(
                                    top: 0, left: 16, right: 16),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(object.sphere?.name ?? "",
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontSize: 15,
                                                          color: Colors.black)),
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 16,
                                          ),
                                          Text(
                                              parseDateWithMicroseconds(
                                                      object.created_on!)
                                                  .toString(),
                                              style: poppinsRegular.copyWith(
                                                  fontSize: 12,
                                                  color: ColorResources
                                                      .CUSTOM_TEXT_BORDER_COLOR)),
                                        ]),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        );
                      },
                    ).expand(),
                    Loader().visible(load),
                  ],
                );
              }
              return snapWidgetHelper(snap);
            },
          ),
        ),
      ),
    );
  }

  getDate(String? created_on) {
    if (created_on != null) {
      DateTime parseDate = inputFormatter.parse(created_on);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputDate = outputFormatter.format(inputDate);
      return outputDate;
    } else {
      return "";
    }
  }

  DateTime parseDateWithMicroseconds(String dateString) {
    final formatter = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ");
    return formatter.parseUtc(dateString);
  }
}
