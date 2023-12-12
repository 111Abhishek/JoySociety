import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/notification/notification_response_list_model.dart';
import 'package:joy_society/data/model/response/notification/notification_response_model.dart';
import 'package:joy_society/provider/notification_provider.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class NotificationScreen extends StatefulWidget {
  NotificationResponseListModel notifications;
  List<NotificationResponseModel> unreadNotifications;
  List<NotificationResponseModel> readNotifications;

  NotificationScreen(
      {super.key,
      required this.notifications,
      required this.unreadNotifications,
      required this.readNotifications});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool? readStatus;

  ScrollController scrollController = new ScrollController();

  BoxDecoration activeBoxDecoration() {
    return BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: Colors.greenAccent.withOpacity(0.3));
  }

  BoxDecoration inactiveBoxDecoration() {
    return BoxDecoration();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget buildNotificationList(
      NotificationResponseListModel notifications, bool? readStatus) {
    List<NotificationResponseModel> notificationResponses;
    if (readStatus == null) {
      notificationResponses = notifications.results;
    } else {
      if (readStatus) {
        notificationResponses = notifications.results
            .where((element) => element.readStatus == true)
            .toList();
      } else {
        notificationResponses = notifications.results
            .where((element) => element.readStatus == false)
            .toList();
      }
    }

    return notifications.results.isNotEmpty
        ? Expanded(
            child: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: min(notificationResponses.length, 25),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                NotificationResponseModel currentNotification =
                    notificationResponses[index];
                return Column(
                  children: [
                    Card(
                        color: Colors.white.withOpacity(0.9),
                        elevation: 0.5,
                        child: ListTile(
                            onTap: () async {
                              if (currentNotification.readStatus == false) {
                                await Provider.of<NotificationProvider>(context,
                                        listen: false)
                                    .readNotification(currentNotification.id,
                                        (bool isSuccess, ErrorResponse? error) {
                                  if (isSuccess) {
                                    currentNotification.readStatus = true;
                                    List<NotificationResponseModel>
                                        updatedNotifications =
                                        notifications.results;
                                    int id = updatedNotifications.indexWhere(
                                        (element) =>
                                            element.id ==
                                            currentNotification.id);
                                    updatedNotifications[id].readStatus = true;
                                    setState(() {
                                      widget.notifications.results =
                                          updatedNotifications;
                                    });
                                  } else {
                                    print('Issue happened!');
                                  }
                                });
                              }
                            },
                            leading: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder,
                                  width: 42,
                                  height: 42,
                                  fit: BoxFit.cover,
                                  image:
                                      notificationResponses[index].profilePic ??
                                          "",
                                  imageErrorBuilder: (c, o, s) => Image.asset(
                                      Images.instructor_placeholder,
                                      width: 42,
                                      height: 42,
                                      fit: BoxFit.cover),
                                )),
                            trailing:
                                notificationResponses[index].readStatus == false
                                    ? const Icon(
                                        Icons.circle,
                                        size: 12,
                                        color: Colors.greenAccent,
                                      )
                                    : const SizedBox(),
                            title: Html(
                              data: notificationResponses[index].notify!,
                              style: {
                                "body": Style(
                                    fontSize: FontSize(12),
                                    fontFamily: 'poppins')
                              },
                              // softWrap: true,),
                              // minVerticalPadding: 20.0,
                            ))),
                    const SizedBox(
                      height: 1,
                    ),
                  ],
                );
              },
            ),
          ))
        : Center(
            child: Text(
              'No notifications are there!',
              style:
                  poppinsSemiBold.copyWith(color: Colors.black, fontSize: 12),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 8.0,
        right: 8.0,
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                constraints: BoxConstraints(
                    minHeight: 100.0,
                    maxHeight: MediaQuery.of(context).size.height - 300.0,
                    minWidth: MediaQuery.of(context).size.width - 50.0,
                    maxWidth: MediaQuery.of(context).size.width - 50.0),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Text("Notifications",
                            style: poppinsBold.copyWith(
                                fontSize: 16, color: ColorResources.BLACK)),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          decoration: readStatus != null
                              ? (readStatus!
                                  ? activeBoxDecoration()
                                  : inactiveBoxDecoration())
                              : inactiveBoxDecoration(),
                          child: Text('Read',
                              style: poppinsMedium.copyWith(
                                  fontSize: 12,
                                  color:
                                      (readStatus != null && readStatus == true)
                                          ? Colors.green.shade900
                                          : Colors.black)),
                        ).onTap(() {
                          setState(() {
                            readStatus = true;
                          });
                        }),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          decoration: readStatus != null
                              ? (!readStatus!
                                  ? activeBoxDecoration()
                                  : inactiveBoxDecoration())
                              : inactiveBoxDecoration(),
                          child: Text('Unread',
                              style: poppinsMedium.copyWith(
                                  fontSize: 12,
                                  color: (readStatus != null &&
                                          readStatus == false)
                                      ? Colors.green.shade900
                                      : Colors.black)),
                        ).onTap(() {
                          setState(() {
                            readStatus = false;
                          });
                        }),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          decoration: readStatus == null
                              ? activeBoxDecoration()
                              : inactiveBoxDecoration(),
                          child: Text('All',
                              style: poppinsMedium.copyWith(
                                  fontSize: 12,
                                  color: (readStatus == null)
                                      ? Colors.green.shade900
                                      : Colors.black)),
                        ).onTap(() {
                          setState(() {
                            readStatus = null;
                          });
                        }),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    buildNotificationList(widget.notifications, readStatus),
                    // if (unread)
                    //   buildNotificationList(widget.unreadNotifications, true),
                    // if (read)
                    //   buildNotificationList(widget.readNotifications, false)
                  ],
                ),
              ),
            )));
  }
}
