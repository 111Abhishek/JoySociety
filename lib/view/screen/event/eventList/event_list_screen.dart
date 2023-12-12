import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/event_list_response_model.dart';
import 'package:joy_society/data/model/response/event_model.dart';
import 'package:joy_society/data/model/response/member_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/event_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/js_data_provider.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/dialog/app_dialog.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/basewidget/show_custom_snakbar.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/basewidget/widgets.dart';
import 'package:joy_society/view/screen/event/createEvent1/create_event1_screen.dart';
import 'package:joy_society/view/screen/event/event_detail_page.dart/event_detail_page.dart';
import 'package:joy_society/view/screen/workshop/workshipsList/widget/workshop_list_menu_bottom_sheet_widget.dart';
import 'package:provider/provider.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../basewidget/button/custom_button_secondary.dart';
import '../../../basewidget/web_view_screen.dart';
import 'package:flutter/services.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  TextEditingController _searchController = TextEditingController();
  List<EventModel> data = [];

  bool isLoading = false;
  bool isLastPage = false;

  bool load = false;
  int page = 1;

  int selectedIndex = -1;
  String searchText = '';
  var inputFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  var outputFormatter = DateFormat("EEE, MMM d, yyyy");

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

  void _bottomSheetForStatus(EventModel event) {
    showModalBottomSheet<int>(
        useRootNavigator: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          //for bottom post
          return WorkshopListMenuBottomSheetWidget(
              child: ListView(shrinkWrap: true, children: [
            Column(children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EventDetailPage(
                                eventObj: event,
                              )));

                  /*Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              showLeaveWorkshopDialog());*/
                },
                child: _buildListItem(
                  context,
                  title: Text(
                    'View Event',
                    style: poppinsRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                        color: Colors.black),
                  ),
                ),
              ),
            ])
          ]));
        });
  }

  // void _bottomSheetForStatus(EventModel event) {
  //   showModalBottomSheet<int>(
  //     useRootNavigator: false,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     builder: (context) {
  //       //for bottom post
  //       return WorkshopListMenuBottomSheetWidget(
  //         child: ListView(
  //           shrinkWrap: true,
  //           children: [
  //             Column(
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     /*Navigator.pop(context);
  //                     showDialog(
  //                         context: context,
  //                         builder: (BuildContext context) =>
  //                             showLeaveWorkshopDialog());*/
  //                   },
  //                   child: _buildListItem(
  //                     context,
  //                     title: Text(
  //                       getTranslated('ADD_TO_CALENDAR', context),
  //                       style: poppinsRegular.copyWith(
  //                           fontSize: Dimensions.FONT_SIZE_LARGE,
  //                           color: Colors.black),
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {},
  //                   child: _buildListItem(
  //                     context,
  //                     title: Text(
  //                       getTranslated('MUTE_EVENT', context),
  //                       style: poppinsRegular.copyWith(
  //                           fontSize: Dimensions.FONT_SIZE_LARGE,
  //                           color: Colors.black),
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {},
  //                   child: _buildListItem(
  //                     context,
  //                     title: Text(
  //                       getTranslated('HIDE_FROM_ACTIVITY_FEED', context),
  //                       style: poppinsRegular.copyWith(
  //                           fontSize: Dimensions.FONT_SIZE_LARGE,
  //                           color: Colors.black),
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {},
  //                   child: _buildListItem(
  //                     context,
  //                     title: Text(
  //                       getTranslated('RECOMMEND', context),
  //                       style: poppinsRegular.copyWith(
  //                           fontSize: Dimensions.FONT_SIZE_LARGE,
  //                           color: Colors.black),
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {},
  //                   child: _buildListItem(
  //                     context,
  //                     title: Text(
  //                       getTranslated('SEND_MESSAGE', context),
  //                       style: poppinsRegular.copyWith(
  //                           fontSize: Dimensions.FONT_SIZE_LARGE,
  //                           color: Colors.black),
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {},
  //                   child: _buildListItem(
  //                     context,
  //                     title: Text(
  //                       getTranslated('DOWNLOAD_RSVPS', context),
  //                       style: poppinsRegular.copyWith(
  //                           fontSize: Dimensions.FONT_SIZE_LARGE,
  //                           color: Colors.black),
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {},
  //                   child: _buildListItem(
  //                     context,
  //                     title: Text(
  //                       getTranslated('DUPLICATE_EVENT', context),
  //                       style: poppinsRegular.copyWith(
  //                           fontSize: Dimensions.FONT_SIZE_LARGE,
  //                           color: Colors.black),
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {},
  //                   child: _buildListItem(
  //                     context,
  //                     title: Text(
  //                       getTranslated('EVENT_SETTINGS', context),
  //                       style: poppinsRegular.copyWith(
  //                           fontSize: Dimensions.FONT_SIZE_LARGE,
  //                           color: Colors.black),
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {},
  //                   child: _buildListItem(
  //                     context,
  //                     title: Text(
  //                       getTranslated('EDIT', context),
  //                       style: poppinsRegular.copyWith(
  //                           fontSize: Dimensions.FONT_SIZE_LARGE,
  //                           color: Colors.black),
  //                     ),
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     showDialog(
  //                         context: context,
  //                         builder: (BuildContext context) =>
  //                             showDeleteWorkshopDialog(event));
  //                   },
  //                   child: _buildListItem(
  //                     context,
  //                     title: Text(
  //                       getTranslated('DELETE', context),
  //                       style: poppinsRegular.copyWith(
  //                           fontSize: Dimensions.FONT_SIZE_LARGE,
  //                           color: Colors.black),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget showDeleteWorkshopDialog(EventModel event) {
    return AppDialog(
        context: context,
        cancelOnPressed: cancelOnDeleteWorkshopPressed,
        submitOnPressed: submitOnDeleteWorkshopPressed(event.id),
        title: getTranslated("workshop_delete_title", context),
        content: getTranslated("workshop_delete_desc", context),
        errorMessage: getTranslated("event_delete_warning_message", context),
        //cancelButtonText: getTranslated('NO', context),
        submitButtonText: getTranslated('CONTINUE', context),
        isButtonLayoutVertical: false,
        dialogIconVisibility: false
        //dialogIcon : Images.icon_delete_dialog
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

  submitOnDeleteWorkshopPressed(int eventId) {
    Provider.of<EventProvider>(context, listen: false)
        .deleteEvent(eventId, deleteEventCallback);
    Navigator.pop(context);
  }

  deleteEventCallback(
      bool isStatusSuccess, ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Event Deleted successfully'),
          backgroundColor: Colors.green));
      int count = 0;
      page = 1;
      isLastPage = false;
      data.clear();
      load = true;
      isLoading = true;
      setState(() {});
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        if (errorDescription == null) {
          dynamic titleError = errorResponse?.errorJson["title"];

          if (titleError != null && titleError.length > 0) {
            errorDescription =
                (titleError![0]! as String).replaceAll("This field", "Title");
          } else {
            errorDescription = 'Technical error, Please try again later!';
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorDescription!), backgroundColor: Colors.red));
    }
  }

  void onItemClick(int index, MemberModel obj) {
    showCustomSnackBar(obj.name ?? "", context);
  }

  Widget build(BuildContext context) {
    List<MemberModel> items = getPeopleData();

    return SafeArea(
      child: Scaffold(
        body: NotificationListener(
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
          child: FutureBuilder<EventListResponseModel?>(
            future: Provider.of<EventProvider>(context, listen: false)
                .getEventList(page, searchText, AppConstants.EVENT),
            builder: (_, snap) {
              if (snap.hasData) {
                if (snap.data!.data != null) {
                  isLastPage = snap.data!.data!.length != 20;
                } else {
                  isLastPage = true;
                }

                if (page == 1) data.clear();

                EventModel? matchedDataInList;
                if (data.length > 0 &&
                    snap.data != null &&
                    snap.data!.data != null) {
                  for (int i = 0; i < snap.data!.data!.length; i++) {
                    /*if (snap.data!.data![i].id == data[data.length - 1].id) {
                      matchedDataInList = data[data.length - 1];
                    }*/
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
                      padding: const EdgeInsets.only(top: 20, left: 8),
                      child: Row(children: [
                        Image.asset(Images.logo_with_name_image,
                            height: 40, width: 40),
                        const SizedBox(width: 10),
                        Text(getTranslated('EVENTS', context),
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
                              'Upcoming',
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
                              'Past',
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
                                      const CreateEvent1Screen()))
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EventDetailPage(
                                          eventObj: data[index],
                                        ))).then((value) => setState(() {}));
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 200,
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholder,
                                          fit: BoxFit.cover,
                                          image: object.event_image!,
                                          imageErrorBuilder: (c, o, s) =>
                                              Image.asset(
                                            Images.logo_with_name_image,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          getDateTime(object.start_datetime),
                                          style: poppinsRegular.copyWith(
                                              fontSize: 14,
                                              color: ColorResources
                                                  .TEXT_BLACK_COLOR),
                                        ),
                                        CustomButtonSecondary(
                                          bgColor:
                                              ColorResources.DARK_GREEN_COLOR,
                                          textColor: ColorResources.WHITE,
                                          isCapital: false,
                                          height: 50,
                                          buttonText: "Join",
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        WebViewScreen(
                                                          url: object.zoom_link,
                                                        )));
                                          },
                                        )
                                      ],
                                    ),
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
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      object.title!,
                                                      style:
                                                          poppinsBold.copyWith(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _bottomSheetForStatus(
                                                          object);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          Images.icon_menu,
                                                          height: 17,
                                                          width: 17,
                                                        ),
                                                        const SizedBox(
                                                          width: 15,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Text(
                                              //   object.description ?? "",
                                              //   style: poppinsRegular.copyWith(
                                              //       fontSize: 12,
                                              //       color: Colors.black),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${object.going} Members are going",
                                          style: poppinsRegular.copyWith(
                                              fontSize: 14,
                                              color: ColorResources
                                                  .TEXT_BLACK_COLOR),
                                        ),
                                        // const SizedBox(
                                        //   width: 25,
                                        // ),
                                        SizedBox(
                                          width: 48,
                                          height: 48,
                                          child: InkWell(
                                            onTap: () async {
                                              await Clipboard.setData(
                                                  ClipboardData(
                                                      text: object.zoom_link!));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                  "Link Copied",
                                                ),
                                                backgroundColor: Colors.green,
                                              ));
                                            },
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    ColorResources.WHITE,
                                                radius: 15,
                                                child: Image.asset(
                                                    Images.icon_share)),
                                          ),
                                        ),
                                      ],
                                    ),
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

  getDate(String? createdOn) {
    if (createdOn != null) {
      DateTime parseDate = inputFormatter.parse(createdOn);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputDate = outputFormatter.format(inputDate);
      return outputDate;
    } else {
      return "";
    }
  }

  String getDateTime(inputDateTime) {
    tz.initializeTimeZones();

    DateTime dateTime = DateTime.parse(inputDateTime);

    // Convert to Eastern Standard Time (EST)
    var estLocation = tz.getLocation('US/Eastern');
    var estDateTime = tz.TZDateTime.from(dateTime, estLocation);

    // Format the date and time
    DateFormat dateFormat = DateFormat.MMMd().addPattern(" • hh:mm a");
    String formattedDateTime = dateFormat.format(estDateTime);

    // Combine the formatted date and time with the time zone
    String finalDateTime = '$formattedDateTime EST';

    return finalDateTime;
  }
}
