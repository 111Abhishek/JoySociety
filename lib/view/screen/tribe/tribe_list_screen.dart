import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/member_model.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/data/model/response/tribe_list_response_model.dart';
import 'package:joy_society/data/model/response/tribe_model.dart';
import 'package:joy_society/data/model/response/workshop_list_response_model.dart';
import 'package:joy_society/data/model/response/workshop_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/tribe_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/js_data_provider.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';
import 'package:joy_society/view/basewidget/dialog/app_dialog.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/basewidget/show_custom_snakbar.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/basewidget/widgets.dart';
import 'package:joy_society/view/screen/tribe/tribeDetailPage/tribe_detail_page.dart';
import 'package:joy_society/view/screen/tribe/tribeList/widget/tribe_list_add_this_to_bottom_sheet_widget.dart';
import 'package:joy_society/view/screen/workshop/workshipsList/widget/workshop_list_add_this_to_bottom_sheet_widget.dart';
import 'package:joy_society/view/screen/workshop/workshipsList/widget/workshop_list_menu_bottom_sheet_widget.dart';
import 'package:joy_society/view/screen/workshop/workshopManage/workshop_manage_screen.dart';
import 'package:provider/provider.dart';

import '../workshop/workshipsList/widget/workshop_joining_bottom_screen.dart';

class TribeListScreen extends StatefulWidget {
  ProfileModel? userProfile;

  TribeListScreen({Key? key, this.userProfile}) : super(key: key);

  @override
  State<TribeListScreen> createState() => _TribeListScreenState();
}

class _TribeListScreenState extends State<TribeListScreen> {
  TextEditingController _searchController = TextEditingController();
  List<TribeModel> data = [];

  bool isLoading = false;
  bool isLastPage = false;

  bool load = false;
  int page = 1;

  int selectedIndex = -1;
  String searchText = '';
  var inputFormatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  var outputFormatter = new DateFormat("EEE, MMM d, yyyy");

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

  void setListener() {
    _searchController.addListener(() {
      print(_searchController.text);
      searchText = _searchController.text;
      if (searchText.isNotEmpty) {
        page = 1;
        isLastPage = false;
        data.clear();
        load = true;
        isLoading = true;
        setState(() {});
      }
    });
  }

  FutureOr onGoBack(dynamic value) {
    load = true;
    isLoading = true;
    page = 1;
    isLastPage = false;
    data.clear();
    setState(() {});
  }

  void _bottomSheetAddThisTo() {
    showModalBottomSheet<int>(
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        //for bottom post
        return TribeListAddThisToBottomSheetWidget(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: _buildListItem(
                      context,
                      title: Row(children: [
                        Checkbox(
                          checkColor: ColorResources.WHITE,
                          activeColor: Theme.of(context).primaryColor,
                          value: Provider.of<WorkshopProvider>(context,
                                  listen: false)
                              .checkBoxFeatured,
                          onChanged: Provider.of<WorkshopProvider>(context,
                                  listen: false)
                              .updateCheckBoxFeatured,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text(getTranslated('FEATURED', context),
                            style: poppinsRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE)),
                      ]),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: _buildListItem(
                      context,
                      title: Row(children: [
                        Checkbox(
                          checkColor: ColorResources.WHITE,
                          activeColor: Theme.of(context).primaryColor,
                          value: Provider.of<WorkshopProvider>(context,
                                  listen: false)
                              .checkBoxFeatured,
                          onChanged: Provider.of<WorkshopProvider>(context,
                                  listen: false)
                              .updateCheckBoxFeatured,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        Text(getTranslated('WELCOME_CHECKLIST', context),
                            style: poppinsRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_LARGE)),
                      ]),
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

  void _bottomSheetForStatus(TribeModel tribeModel) {
    showModalBottomSheet<int>(
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        //for bottom post
        return WorkshopListMenuBottomSheetWidget(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      /*showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              showLeaveWorkshopDialog());*/
                    },
                    child: _buildListItem(
                      context,
                      title: Text(
                        getTranslated('LEAVE_TRIBE', context),
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: _buildListItem(
                      context,
                      title: Text(
                        getTranslated('CHARGES_FOR_ACCESS', context),
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: _buildListItem(
                      context,
                      title: Text(
                        getTranslated('EDIT', context),
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              showDeleteTribeDialog(tribeModel.id));
                    },
                    child: _buildListItem(
                      context,
                      title: Text(
                        getTranslated('DELETE', context),
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

  Widget showDeleteTribeDialog(int? tribeId) {
    return AppDialog(
        context: context,
        cancelOnPressed: cancelOnDeleteWorkshopPressed,
        submitOnPressed: submitOnDeleteWorkshopPressed(tribeId),
        title: getTranslated("tribe_delete_title", context),
        content: getTranslated("tribe_delete_desc", context),
        cancelButtonText: getTranslated('NO', context),
        submitButtonText: getTranslated('YES', context),
        isButtonLayoutVertical: false,
        dialogIconVisibility: true,
        dialogIcon: Images.icon_delete_dialog);
  }

  Widget showLeaveWorkshopDialog() {
    return AppDialog(
        context: context,
        cancelOnPressed: cancelOnLeaveWorkshopPressed,
        submitOnPressed: submitOnLeaveWorkshopPressed,
        title: getTranslated("workshop_leave_title", context),
        content: getTranslated("workshop_leave_desc", context),
        cancelButtonText: getTranslated('CANCEL', context),
        submitButtonText: getTranslated('LEAVE', context),
        dialogIconVisibility: true,
        dialogIcon: Images.icon_delete_dialog);
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

  void cancelOnLeaveWorkshopPressed() {
    Navigator.pop(context);
  }

  void submitOnLeaveWorkshopPressed() {
    Navigator.pop(context);
  }

  void cancelOnDeleteWorkshopPressed() {
    Navigator.pop(context);
  }

  submitOnDeleteWorkshopPressed(int? tribeId) {
    Navigator.pop(context);
    deleteTribe(tribeId);
  }

  void onItemClick(int index, MemberModel obj) {
    showCustomSnackBar(obj.name! ?? "", context);
  }

  void deleteTribe(int? tribeId) async {
    if (tribeId != null) {
      await Provider.of<TribeProvider>(context, listen: false)
          .deleteTribe(tribeId, _onDeleteResponse);
    }
  }

  _onDeleteResponse(bool isStatusSuccess, ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      _searchController.text = "";
      page = 1;
      isLastPage = false;
      data.clear();
      load = true;
      isLoading = true;
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    List<MemberModel> items = getPeopleData();

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
          child: FutureBuilder<TribeListResponseModel?>(
            future: Provider.of<TribeProvider>(context, listen: false)
                .getTribeList(page, searchText, AppConstants.TRIBE),
            builder: (_, snap) {
              if (snap.hasData) {
                if (snap.data!.data != null) {
                  isLastPage = snap.data!.data!.length != 20;
                } else {
                  isLastPage = true;
                }

                if (page == 1) data.clear();

                TribeModel? matchedDataInList;
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
                      padding: const EdgeInsets.only(top: 48, left: 20),
                      child: Row(children: [
                        Image.asset(Images.logo_with_name_image,
                            height: 40, width: 40),
                        const SizedBox(width: 10),
                        Text(getTranslated('TRIBES', context),
                            style: poppinsBold.copyWith(
                                fontSize: 20, color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]),
                    ),
                    const SizedBox(height: 6),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                    color: ColorResources.DARK_GREEN_COLOR)),
                            child: Text(
                              'All',
                              style: poppinsRegular.copyWith(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                    color: ColorResources.DARK_GREEN_COLOR)),
                            child: Text(
                              'Top',
                              style: poppinsRegular.copyWith(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                    color: ColorResources.DARK_GREEN_COLOR)),
                            child: Text(
                              'Yours',
                              style: poppinsRegular.copyWith(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                    color: ColorResources.DARK_GREEN_COLOR)),
                            child: Text(
                              'Newest',
                              style: poppinsRegular.copyWith(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                    color: ColorResources.DARK_GREEN_COLOR)),
                            child: Text(
                              'Inactive',
                              style: poppinsRegular.copyWith(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: Row(children: [
                        Expanded(
                          child: CustomTextField(
                            textInputType: TextInputType.name,
                            hintText: 'Search...',
                            controller: _searchController,
                          ),
                        ),
                        const SizedBox(
                          width: Dimensions.MARGIN_SIZE_DEFAULT,
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: ColorResources.DARK_GREEN_COLOR,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: const Offset(0, 1))
                              // changes position of shadow
                            ],
                          ),
                          child: IconButton(
                            onPressed: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const WorkshopManageScreen()))
                            },
                            padding: const EdgeInsets.all(0),
                            icon: const Icon(Icons.add,
                                color: ColorResources.WHITE, size: 18),
                            color: ColorResources.DARK_GREEN_COLOR,
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 6),
                    ListView.builder(
                      itemCount: data.length,
                      padding: const EdgeInsets.only(bottom: 8, top: 8),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var object = data[index];

                        return GestureDetector(
                            onTap: () {
                              if (object.privacy == "Private" &&
                                      object.joined == "Pending" ||
                                  object.joined == "Not Joined") {
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => TribeDetailPage(
                                              tribeObj: data[index],
                                            )));
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                      margin: const EdgeInsets.only(
                                          top: 0, left: 16, right: 16),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  border: Border.all(
                                                      color: ColorResources
                                                          .GRAY_BUTTON_BG_COLOR)),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 200,
                                              child: FadeInImage.assetNetwork(
                                                placeholder: Images.placeholder,
                                                fit: BoxFit.cover,
                                                image: object.tribe_url!,
                                                imageErrorBuilder: (c, o, s) =>
                                                    Image.asset(
                                                  Images.logo_with_name_image,
                                                  fit: BoxFit.cover,
                                                ),
                                              )),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          generateWorkshopActionWidget(
                                              object.joined!,
                                              object.privacy!,
                                              data[index]),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     Text(

                                          //           object.privacy!,
                                          //       style: poppinsRegular.copyWith(
                                          //           fontSize: 14,
                                          //           color: ColorResources
                                          //               .TEXT_BLACK_COLOR),
                                          //     ),
                                          //     CustomButtonSecondary(
                                          //       bgColor: ColorResources
                                          //           .DARK_GREEN_COLOR,
                                          //       textColor: ColorResources.WHITE,
                                          //       isCapital: false,
                                          //       height: 50,
                                          //       buttonText: "Join",
                                          //       onTap: () {
                                          //         // Navigator.push(
                                          //         //     context,
                                          //         //     MaterialPageRoute(
                                          //         //         builder: (_) =>
                                          //         //             WebViewScreen(
                                          //         //               url: object
                                          //         //                   .zoom_link,
                                          //         //             )));
                                          //       },
                                          //     )
                                          //   ],
                                          // ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      object.title!,
                                                      style:
                                                          poppinsBold.copyWith(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                    Text(
                                                      object.tagline ?? "",
                                                      style: poppinsRegular
                                                          .copyWith(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),

                                          Text(
                                            removeHtmlTags(object.description!),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: ColorResources
                                                  .TEXT_BLACK_COLOR,
                                            ),
                                          ),
                                          // const SizedBox(
                                          //   height: 10,
                                          // ),
                                          const Divider(),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${object.membercount} members",
                                                style: poppinsRegular.copyWith(
                                                    fontSize: 14,
                                                    color: ColorResources
                                                        .TEXT_BLACK_COLOR),
                                              ),
                                              // SizedBox(
                                              //   width: 48,
                                              //   height: 40,
                                              //   child: InkWell(
                                              //     onTap: () async {},
                                              //     child: CircleAvatar(
                                              //         backgroundColor:
                                              //             ColorResources.WHITE,
                                              //         radius: 15,
                                              //         child: Image.asset(
                                              //             Images.icon_share)),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "A ${object.privacy} Tribe in Joy Society",
                                            style: poppinsRegular.copyWith(
                                                fontSize: 14,
                                                color: ColorResources
                                                    .TEXT_BLACK_COLOR),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            ));
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

  Widget generateWorkshopActionWidget(
      String isJoined, String isPublic, TribeModel tribe) {
    if (isPublic == "Public" && isJoined == "Joined") {
      return Material(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorResources.DIVIDER_COLOR_LIGHT),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Text("Public",
                  style: poppinsMedium.copyWith(
                      fontSize: 12, color: Colors.black54))),

          Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorResources.DIVIDER_COLOR_LIGHT),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Text("Joined",
                  style: poppinsMedium.copyWith(
                      fontSize: 12, color: Colors.black54))),
          // Ink(
          //     decoration: const BoxDecoration(
          //         color: ColorResources.DARK_GREEN_COLOR,
          //         borderRadius: BorderRadius.all(Radius.circular(5))),
          //     child: InkWell(
          //         // here onTap we will be performing the task for joining the user
          //         // to the current workshop
          //         onTap: () {
          //           _showWorkshopActionBottomSheet("Joining the workshop!");

          //           //  _joinTribe(workshop);
          //         },
          //         splashColor: Colors.teal.shade900,
          //         borderRadius: const BorderRadius.all(Radius.circular(5)),
          //         child: Container(
          //             padding: const EdgeInsets.symmetric(
          //                 vertical: 5, horizontal: 20),
          //             child: Text("Join",
          //                 style: poppinsMedium.copyWith(
          //                     fontSize: 12, color: Colors.white))))),
        ],
      ));
    } else if (isPublic == "Public" && isJoined == "Not Joined") {
      return Material(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorResources.DIVIDER_COLOR_LIGHT),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Text("Public",
                  style: poppinsMedium.copyWith(
                      fontSize: 12, color: Colors.black54))),
          Ink(
              decoration: const BoxDecoration(
                  color: ColorResources.DARK_GREEN_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: InkWell(
                  // here onTap we will be performing the task for joining the user
                  // to the current workshop
                  onTap: () {
                    _showWorkshopActionBottomSheet("Joining the Tribe!");

                    _joinTribe(tribe, false);
                  },
                  splashColor: Colors.teal.shade900,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Text("Join",
                          style: poppinsMedium.copyWith(
                              fontSize: 12, color: Colors.white))))),
        ],
      ));
    } else if (isPublic == "Private" && isJoined == "Not Joined") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorResources.DIVIDER_COLOR_LIGHT),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock,
                    color: ColorResources.DIVIDER_COLOR,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text("Private",
                      style: poppinsMedium.copyWith(
                          fontSize: 12, color: Colors.black54)),
                ],
              )),
          Ink(
              decoration: const BoxDecoration(
                  color: ColorResources.DARK_GREEN_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: InkWell(
                  // here onTap we will be performing the task for joining the user
                  // to the current workshop
                  onTap: () {
                    _showWorkshopActionBottomSheet("Joining the Tribe!");

                    _joinTribe(tribe, true);
                  },
                  splashColor: Colors.teal.shade900,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Container(
                      decoration: const BoxDecoration(
                        color: ColorResources.DARK_GREEN_COLOR,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Text("Request Access",
                          style: poppinsMedium.copyWith(
                              fontSize: 12, color: Colors.white))))),
        ],
      );
    } else if (isPublic == "Private" && isJoined == "Pending") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorResources.DIVIDER_COLOR_LIGHT),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock,
                    color: ColorResources.DIVIDER_COLOR,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text("Private",
                      style: poppinsMedium.copyWith(
                          fontSize: 12, color: Colors.black54)),
                ],
              )),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorResources.DIVIDER_COLOR_LIGHT),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Text("Pending",
                  style: poppinsMedium.copyWith(
                      fontSize: 12, color: Colors.black54))),
        ],
      );
    } else if (isPublic == "Private" && isJoined == "Joined") {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorResources.DIVIDER_COLOR_LIGHT),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock,
                    color: ColorResources.DIVIDER_COLOR,
                    size: 15,
                  ),
                  const SizedBox(width: 5),
                  Text("Private",
                      style: poppinsMedium.copyWith(
                          fontSize: 12, color: Colors.black54)),
                ],
              )),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: ColorResources.DIVIDER_COLOR_LIGHT),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Text("Joined",
                  style: poppinsMedium.copyWith(
                      fontSize: 12, color: Colors.black54))),
        ],
      );
    }

    return const SizedBox();
  }

  void _showWorkshopActionBottomSheet(String? actionDescription) {
    showModalBottomSheet<int>(
        useRootNavigator: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: JoiningBottomList(
                  child: Column(
                children: [
                  const SpinKitDoubleBounce(
                    color: ColorResources.DARK_GREEN_COLOR,
                    size: 40.0,
                    duration: Duration(milliseconds: 1600),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(actionDescription ?? "",
                      style: poppinsSemiBold.copyWith(
                          fontSize: 16, color: Colors.grey.shade700)),
                  const SizedBox(
                    height: 32,
                  )
                ],
              )));
        });
  }

  void _joinTribe(TribeModel tribe, bool isPrivate) async {
    await Provider.of<TribeProvider>(context, listen: false).joinTribe(
        tribe.id!, (bool isStatusSuccess, ErrorResponse? errorResponse) async {
      if (isStatusSuccess) {
        if (isPrivate) {
          Navigator.pop(context);
          setState(() {});
          _showToast(context, "Requested Successfully");
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => TribeDetailPage(
                        tribeObj: tribe,
                      ))).then(onGoBack);
          _showToast(context, "Successfully joined the Tribe");
        }
      } else {
        Navigator.pop(context);
        _showToast(context, "Could not join the Tribe.");
      }
    });
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'CLOSE',
          onPressed: scaffold.hideCurrentSnackBar,
        )));
  }

  String removeHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
