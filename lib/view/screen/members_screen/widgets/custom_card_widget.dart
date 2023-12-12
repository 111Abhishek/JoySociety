import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/members_followers.dart';
import '../../../../data/model/response/members_followers_model.dart';
import '../../../../provider/members_follwers_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';

class CustomCardWidget extends StatefulWidget {
  final Result? memberResp;
  final FollowingModel? followersResponse;

  const CustomCardWidget({this.memberResp, this.followersResponse});

  @override
  State<CustomCardWidget> createState() => _CustomCardWidgetState();
}

class _CustomCardWidgetState extends State<CustomCardWidget> {
  final String lastOnline = "Last active 3d ago";
  String? localFollow;

  @override
  void initState() {
    super.initState();
    localFollow = widget.followersResponse!.results!
            .any((element) => element.id == widget.memberResp!.userId)
        ? "Unfollow"
        : "Follow";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: SizedBox(
        height: 100,
        child: Align(
          alignment: Alignment.center,
          child: ListTile(
            leading: const CircleAvatar(
              child: Icon(
                Icons.account_circle,
                size: 40,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    widget.memberResp!.fullName!,
                    style: poppinsSemiBold.copyWith(
                      color: ColorResources.BLACK,
                      //fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        if (localFollow == "Follow") {
                          localFollow = "Unfollow";
                          // Perform the follow action here, and you can update the followersResponse accordingly
                          Provider.of<MemberFollowerProvider>(context,
                                  listen: false)
                              .follow(widget.memberResp!.userId!, true);
                        } else {
                          localFollow = "Follow";
                          // Perform the unfollow action here, and you can update the followersResponse accordingly
                          Provider.of<MemberFollowerProvider>(context,
                                  listen: false)
                              .follow(widget.memberResp!.userId!, false);
                        }
                      });
                    },
                    child: Text(
                      localFollow!,
                      style: poppinsRegular.copyWith(
                        color: ColorResources.DARK_GREEN_COLOR,
                        //fontSize: 20,
                      ),
                    ),
                  ),
                  // const Icon(Icons.more_vert),
                ],
              ),
            ),
            subtitle: Row(
              children: [
                Text(
                  "  Member",
                  style: poppinsRegular.copyWith(
                    color: ColorResources.DARK_GREEN_COLOR,
                    //fontSize: 20,
                  ),
                ),
                Text(" - $lastOnline"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
