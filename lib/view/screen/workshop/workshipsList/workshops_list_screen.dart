import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/member_model.dart';
import 'package:joy_society/data/model/response/workshop_list_response_model.dart';
import 'package:joy_society/view/screen/workshop/createWorkshop1/create_workshop1_screen.dart';
import 'package:joy_society/data/model/response/workshop_model.dart';
import 'package:joy_society/data/model/response/workshop_subscription_url_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/dialog/app_dialog.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/basewidget/show_custom_snakbar.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/basewidget/widgets.dart';
import 'package:joy_society/view/screen/workshop/workshipsList/widget/workshop_joining_bottom_screen.dart';
import 'package:joy_society/view/screen/workshop/workshipsList/widget/workshop_list_add_this_to_bottom_sheet_widget.dart';
import 'package:joy_society/view/screen/workshop/workshipsList/widget/workshop_list_menu_bottom_sheet_widget.dart';
import 'package:joy_society/view/screen/workshop/workshipsList/workshop_subscription_screen.dart';
import 'package:joy_society/view/screen/workshop/workshopDetail/workshop_detail_screen.dart';
import 'package:joy_society/view/screen/workshop/workshopManage/workshop_manage_screen.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as sp;

import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class WorkshopsListScreen extends StatefulWidget {
  final bool didComeFromHomeScreen;

  const WorkshopsListScreen({Key? key, required this.didComeFromHomeScreen})
      : super(key: key);

  @override
  State<WorkshopsListScreen> createState() => _WorkshopsListScreenState();
}

class _WorkshopsListScreenState extends State<WorkshopsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<WorkshopModel> data = [];

  bool isLoading = false;
  bool isLastPage = false;

  bool load = false;
  int page = 1;

  bool userJoining = false;

  Map<String, dynamic>? paymentIntent;

  int selectedIndex = -1;
  String searchText = '';
  var inputFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  var outputFormatter = DateFormat("EEE, MMM d, yyyy");

  String _shortenDescription(String? description) {
    String shortDescription =
        description?.substring(0, math.min(description.length, 100)) ?? "";
    var doc = parse(shortDescription);
    if (doc.documentElement != null) {
      return doc.documentElement!.text;
    }
    return "";
  }

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  FutureOr onGoBack(dynamic value) {
    load = true;
    isLoading = true;
    page = 1;
    isLastPage = false;
    data.clear();
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
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

  void setListener() {
    _searchController.addListener(() {
      String currentSearchText = _searchController.text;
      print("Current Search term: $searchText");
      if (currentSearchText.isNotEmpty) {
        page = 1;
        isLastPage = false;
        data.clear();
        load = true;
        isLoading = true;
        setState(() {
          searchText = currentSearchText;
        });
      }
      setState(() {
        searchText = currentSearchText;
      });
    });
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

  // Payment section starts

  // Payment section ends

  void _joinWorkshop(WorkshopModel workshop) async {
    await Provider.of<WorkshopProvider>(context, listen: false)
        .joinWorkshop(workshop.id,
            (bool isStatusSuccess, ErrorResponse? errorResponse) async {
      if (isStatusSuccess) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WorkshopDetailScreen(workshop: workshop))).then(onGoBack);
        _showToast(context, "Successfully joined the workshop");
      } else {
        Navigator.pop(context);
        _showToast(context, "Could not join the workshop.");
      }
    });
  }

  void _subscribeWorkshop(WorkshopModel workshop) async {
    await Provider.of<WorkshopProvider>(context, listen: false)
        .subscribeWorkshop(workshop.id, (bool isStatusSuccess,
            WorkshopSubscriptionUrlModel? response,
            ErrorResponse? errorResponse) {
      if (isStatusSuccess) {
        Navigator.pop(context);
        log(response?.checkoutSessionUrl ?? "");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WorkshopSubscriptionScreen(
                    url: response?.checkoutSessionUrl ?? ""))).then(onGoBack);
      } else {
        Navigator.pop(context);
        _showToast(context, "Was not able to subscribe at the moment.");
      }
    });
  }

  Widget generateWorkshopActionWidget(bool isSubscribed, bool isJoined,
      bool isPrivate, WorkshopModel workshop) {
    if (isPrivate) {
      if (!isSubscribed) {
        return Material(
            child: Ink(
                decoration: const BoxDecoration(
                    color: ColorResources.DARK_GREEN_COLOR,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: InkWell(
                    // here onTap we will be performing the task for joining the user
                    // to the current workshop
                    onTap: () async {
                      _showWorkshopActionBottomSheet(
                          "Subscribing to the workshop");

                      _subscribeWorkshop(workshop);
                    },
                    splashColor: Colors.teal.shade900,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text("Subscribe",
                            style: poppinsMedium.copyWith(
                                fontSize: 12, color: Colors.white))))));
      } else if (!isJoined) {
        return Material(
            child: Ink(
                decoration: const BoxDecoration(
                    color: ColorResources.DARK_GREEN_COLOR,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: InkWell(
                    // here onTap we will be performing the task for joining the user
                    // to the current workshop
                    onTap: () {
                      _showWorkshopActionBottomSheet("Joining the workshop!");

                      _joinWorkshop(workshop);
                    },
                    splashColor: Colors.teal.shade900,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: Text("Join",
                            style: poppinsMedium.copyWith(
                                fontSize: 12, color: Colors.white))))));
      } else {
        return Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(color: ColorResources.DIVIDER_COLOR_LIGHT),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Text("Joined",
                style: poppinsMedium.copyWith(
                    fontSize: 12, color: Colors.black54)));
      }
    } else {
      if (!isJoined) {
        return Material(
            child: Ink(
                decoration: const BoxDecoration(
                    color: ColorResources.DARK_GREEN_COLOR,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: InkWell(
                    // here onTap we will be performing the task for joining the user
                    // to the current workshop
                    onTap: () {
                      _showWorkshopActionBottomSheet("Joining the workshop!");

                      _joinWorkshop(workshop);
                    },
                    splashColor: Colors.teal.shade900,
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: Text("Join",
                            style: poppinsMedium.copyWith(
                                fontSize: 12, color: Colors.white))))));
      } else {
        return Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(color: ColorResources.DIVIDER_COLOR_LIGHT),
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Text("Joined",
                style: poppinsMedium.copyWith(
                    fontSize: 12, color: Colors.black54)));
      }
    }
  }

  Widget workshopCard(WorkshopModel workshop) {
    bool isJoined = workshop.joined!;
    bool isSubscribed = workshop.subscribed!;
    bool isPrivate = workshop.privacy!.toLowerCase() == "private";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          margin: const EdgeInsets.only(top: 0, left: 16, right: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Material(
                          child: Container(
                    height: 180,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                        FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          fit: BoxFit.cover,
                          alignment: Alignment.centerLeft,
                          image: workshop.workshopImageUrl!,
                          imageErrorBuilder: (c, o, s) => Image.asset(
                            Images.workshop_default_image,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ).onTap(() {
                    if (isJoined) {
                      // will open the contents of the workshop
                      // we are concerned with this section only
                      return Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkshopDetailScreen(
                                    workshop: workshop,
                                  ))).then(onGoBack);
                    } else {
                      if (isPrivate && !isSubscribed) {
                        _showToast(context, "Please subscribe to the workshop");
                      } else if (!isJoined) {
                        _showToast(context, "Please join the workshop!");
                      }
                    }
                  })))
                ],
              ),
              const Divider(
                  height: 30, color: ColorResources.NAVIGATION_DIVIDER_COLOR),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorResources.DIVIDER_COLOR_LIGHT),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: workshop.privacy!.toLowerCase() == "private"
                          ? Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.lock,
                                    color: ColorResources.DIVIDER_COLOR,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Private",
                                    style: poppinsMedium.copyWith(
                                        fontSize: 12, color: Colors.black54),
                                  )
                                ],
                              ),
                              if (isSubscribed)
                                Text("Subscribed",
                                    style: poppinsMedium.copyWith(
                                        fontSize: 10,
                                        color: ColorResources.DARK_GREEN_COLOR))
                            ])
                          : Text(
                              "Public",
                              style: poppinsMedium.copyWith(
                                  fontSize: 12, color: Colors.black54),
                            )),
                  generateWorkshopActionWidget(
                      isSubscribed, isJoined, isPrivate, workshop)
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              workshop.title!,
                              style: poppinsBold.copyWith(
                                  fontSize: 16, color: Colors.black),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          _shortenDescription(workshop.description),
                          style: poppinsRegular.copyWith(
                              fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(color: ColorResources.NAVIGATION_DIVIDER_COLOR),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Instructors",
                          style: poppinsRegular.copyWith(
                              fontSize: 12, color: Colors.black87)),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                              height: 30,
                              width: 30,
                              child: CircleAvatar(
                                backgroundImage:
                                    AssetImage(Images.invite_content),
                              )),
                          Container(
                            height: 30,
                            width: 30,
                            transform: Matrix4.translationValues(-10, 0, 0),
                            child: const CircleAvatar(
                              backgroundImage:
                                  AssetImage(Images.instructor_placeholder),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            transform: Matrix4.translationValues(-20, 0, 0),
                            child: const CircleAvatar(
                              backgroundImage: AssetImage(Images.icon_person),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          workshop.tagline ?? workshop.title!,
                          style: poppinsRegular.copyWith(
                              fontSize: 10, color: Colors.black87),
                          softWrap: true,
                          maxLines: 3,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(color: ColorResources.NAVIGATION_DIVIDER_COLOR),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // List<MemberModel> items = getPeopleData();

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
          child: FutureBuilder<WorkshopListResponseModel?>(
            future: Provider.of<WorkshopProvider>(context, listen: false)
                .getWorkshopList(page, searchText, AppConstants.WORKSHOP),
            builder: (_, snap) {
              switch (snap.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                // return Loader();
                default:
                  if (snap.hasData) {
                    if (snap.data!.data != null) {
                      isLastPage = snap.data!.data!.length != 20;
                    } else {
                      isLastPage = true;
                    }

                    if (page == 1) data.clear();

                    WorkshopModel? matchedDataInList;
                    if (data.isNotEmpty &&
                        snap.data != null &&
                        snap.data!.data != null) {
                      for (int i = 0; i < snap.data!.data!.length; i++) {
                        if (snap.data!.data![i].id ==
                            data[data.length - 1].id) {
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
                          padding: widget.didComeFromHomeScreen
                              ? const EdgeInsets.only(top: 24, left: 8)
                              : const EdgeInsets.only(top: 48, left: 8),
                          child: Row(children: [
                            !widget.didComeFromHomeScreen
                                ? CupertinoNavigationBarBackButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    color: Colors.black,
                                  )
                                : const SizedBox(
                                    width: 16,
                                  ),
                            Image.asset(Images.logo_with_name_image,
                                height: 40, width: 40),
                            const SizedBox(width: 10),
                            Text(getTranslated('WORKSHOPS', context),
                                style: poppinsBold.copyWith(
                                    fontSize: 20, color: Colors.black),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ]),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Row(children: [
                            Expanded(
                              child: CustomTextField(
                                textInputType: TextInputType.name,
                                hintText: 'Search...',
                                controller: _searchController,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                            const SizedBox(
                              height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                            ),
                            CustomButton(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              CreateWorkshop1Screen()));
                                },
                                buttonText: getTranslated(
                                    'CREATE_A_WORKSHOP', context)),
                          ]),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          itemCount: data.length,
                          padding: const EdgeInsets.only(bottom: 8, top: 8),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            var object = data[index];

                            return workshopCard(object);
                          },
                        ).expand(),
                        Loader().visible(load),
                      ],
                    );
                  }
                  return snapWidgetHelper(snap);
              }
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
}
