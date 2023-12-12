import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/workshop_member_model.dart';
import 'package:joy_society/data/model/response/workshop_members_list_model.dart';
import 'package:joy_society/provider/tribe_provider.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:provider/provider.dart';

import '../../../basewidget/widgets.dart';

class TribeMembersScreen extends StatefulWidget {
  const TribeMembersScreen({super.key, required this.tribeId});

  final int tribeId;

  @override
  State<TribeMembersScreen> createState() => _TribeMembersScreenState();
}

class _TribeMembersScreenState extends State<TribeMembersScreen> {
  List<WorkshopMemberModel> data = [];

  bool isLoading = false;
  bool isLastPage = false;

  bool load = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
    // setListener();
  }

  init() async {
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String getFullName(String? firstName, String? lastName) {
    String first = firstName ?? "";
    String last = lastName ?? "";

    return "$first $last";
  }

  Widget buildProfileCard(int id, String name) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(Images.instructor_placeholder))),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(name,
                  style: poppinsMedium.copyWith(
                      fontSize: 14, color: Colors.grey.shade800))
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
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
          child: FutureBuilder<MembersListModel?>(
            future: Provider.of<TribeProvider>(context, listen: false)
                .getTribeMembersList(
                    page, widget.tribeId, AppConstants.TRIBE_MEMBER_URL),
            builder: (_, snap) {
              if (snap.hasData) {
                if (snap.data!.members != null) {
                  isLastPage = snap.data!.members!.length != 20;
                } else {
                  isLastPage = true;
                }

                if (page == 1) data.clear();

                WorkshopMemberModel? matchedDataInList;
                if (data.isNotEmpty &&
                    snap.data != null &&
                    snap.data!.members != null) {
                  for (int i = 0; i < snap.data!.members!.length; i++) {
                    if (snap.data!.members![i].user!.id ==
                        data[data.length - 1].id) {
                      matchedDataInList = data[data.length - 1];
                    }
                  }
                }
                if (matchedDataInList == null &&
                    snap.data != null &&
                    snap.data!.members != null) {
                  data.addAll(snap.data!.members!);
                }
                load = false;

                return Container(
                    padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        itemCount: data.length,
                        shrinkWrap: true,
                        physics:const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          WorkshopMemberModel object = data[index];
                          return buildProfileCard(
                              object.id,
                              getFullName(object.user?.firstName,
                                  object.user?.lastName));
                        }));
              }
              return Center(child: snapWidgetHelper(snap));
            },
          ),
        ));
  }
}
