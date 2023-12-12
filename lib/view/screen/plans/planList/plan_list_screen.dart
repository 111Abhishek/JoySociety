import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/member_model.dart';
import 'package:joy_society/data/model/response/plan_list_response_model.dart';
import 'package:joy_society/data/model/response/plan_model.dart';
import 'package:joy_society/data/model/response/tribe_list_response_model.dart';
import 'package:joy_society/data/model/response/tribe_model.dart';
import 'package:joy_society/data/model/response/workshop_list_response_model.dart';
import 'package:joy_society/data/model/response/workshop_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/plan_provider.dart';
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
import 'package:joy_society/view/screen/plans/createPlan/create_plan1_screen.dart';
import 'package:joy_society/view/screen/tribe/tribeList/widget/tribe_list_add_this_to_bottom_sheet_widget.dart';
import 'package:joy_society/view/screen/workshop/workshipsList/widget/workshop_list_add_this_to_bottom_sheet_widget.dart';
import 'package:joy_society/view/screen/workshop/workshipsList/widget/workshop_list_menu_bottom_sheet_widget.dart';
import 'package:joy_society/view/screen/workshop/workshopManage/workshop_manage_screen.dart';
import 'package:provider/provider.dart';

class PlanListScreen extends StatefulWidget {
  const PlanListScreen({Key? key}) : super(key: key);

  @override
  State<PlanListScreen> createState() => _PlanListScreenState();
}

class _PlanListScreenState extends State<PlanListScreen> {
  TextEditingController _searchController = TextEditingController();
  List<PlanModel> data = [];

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
                      title: Row(
                          children: [
                            Checkbox(
                              checkColor: ColorResources.WHITE,
                              activeColor: Theme.of(context).primaryColor,
                              value: Provider.of<WorkshopProvider>(context, listen: false).checkBoxFeatured,
                              onChanged: Provider.of<WorkshopProvider>(context, listen: false).updateCheckBoxFeatured,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            Text(getTranslated('FEATURED', context),
                                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ]
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: _buildListItem(
                      context,
                      title: Row(
                          children: [
                            Checkbox(
                              checkColor: ColorResources.WHITE,
                              activeColor: Theme.of(context).primaryColor,
                              value: Provider.of<WorkshopProvider>(context, listen: false).checkBoxFeatured,
                              onChanged: Provider.of<WorkshopProvider>(context, listen: false).updateCheckBoxFeatured,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            Text(getTranslated('WELCOME_CHECKLIST', context),
                                style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                          ]
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

  void _bottomSheetForStatus(PlanModel tribeModel) {
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
      dialogIcon : Images.icon_delete_dialog
    );
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
      dialogIcon : Images.icon_delete_dialog
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
    if(tribeId != null) {
      await Provider.of<TribeProvider>(context, listen: false)
          .deleteTribe(tribeId, _onDeleteResponse);
    }
  }

  _onDeleteResponse(bool isStatusSuccess, ErrorResponse? errorResponse) async {
    if(isStatusSuccess) {
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
          child: FutureBuilder<PlanListResponseModel?>(
            future: Provider.of<PlanProvider>(context, listen: false)
                .getPlanList(page, searchText, AppConstants.PRODUCT),
            builder: (_, snap) {
              if (snap.hasData) {
                if (snap.data!.data != null) {
                  isLastPage = snap.data!.data!.length != 20;
                } else {
                  isLastPage = true;
                }

                if (page == 1) data.clear();

                PlanModel? matchedDataInList;
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
                        Text(getTranslated('PLANS', context),
                            style: poppinsBold.copyWith(
                                fontSize: 20, color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]),
                    ),
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
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
                                  offset: Offset(0, 1))
                              // changes position of shadow
                            ],
                          ),
                          child: IconButton(
                            onPressed: () => {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CreatePlan1Screen()))
                            },
                            padding: EdgeInsets.all(0),
                            icon: Icon(Icons.add,
                                color: ColorResources.WHITE, size: 18),
                            color: ColorResources.DARK_GREEN_COLOR,
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(height: 6),
                    ListView.builder(
                      itemCount: data.length,
                      padding: EdgeInsets.only(bottom: 8, top: 8),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var object = data[index];

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              border: Border.all(
                                                  color: ColorResources
                                                      .GRAY_BUTTON_BG_COLOR)),
                                          width: 65,
                                          height: 65,
                                          child: FadeInImage.assetNetwork(
                                            placeholder: Images.placeholder, fit: BoxFit.cover,
                                            image: object.image!,
                                            imageErrorBuilder: (c, o, s) => Image.asset(Images.logo_with_name_image,
                                                fit: BoxFit.cover,),
                                          )),
                                          SizedBox(height: 4,),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                color: ColorResources.GRAY_BUTTON_BG_COLOR,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                object.is_active!! == true ?
                                                Text(  "Active",
                                                  style:
                                                  poppinsRegular.copyWith(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ) : Text(  "Disable",
                                                  style:
                                                  poppinsRegular.copyWith(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ]
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  object.name!,
                                                  style: poppinsBold.copyWith(
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    _bottomSheetForStatus(object);
                                                  },
                                                  child: Image.asset(
                                                    Images.icon_menu,
                                                    height: 17,
                                                    width: 17,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              object.description ?? "",
                                              style: poppinsRegular.copyWith(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Divider(
                                      color: ColorResources
                                          .NAVIGATION_DIVIDER_COLOR),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Offer Price \$' + object.offer_price.toString(),
                                              style:
                                              poppinsRegular.copyWith(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
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
}
