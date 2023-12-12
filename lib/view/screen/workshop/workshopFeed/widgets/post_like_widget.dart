import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/data/model/response/workshop_feed_response_model.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/workshop_provider.dart';

class PostLikeWidget extends StatefulWidget {
  final Result result;
  ProfileModel? userProfile;
  final Function effect;
  // final Function effect;


  PostLikeWidget({super.key, required this.result, this.userProfile, required this.effect});

  @override
  State<PostLikeWidget> createState() => _PostLikeWidgetState();
}

class _PostLikeWidgetState extends State<PostLikeWidget> {

  bool isLike = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLike = widget.result.like!.any((element) => element.id == widget.userProfile?.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          setState(() {
            isLike = !isLike;
          });
          widget.result.like!.any((element) => element.id == widget.userProfile?.userId)
              ? await Provider.of<WorkshopProvider>(context, listen: false)
                  .likePost(widget.result.id!, widget.result.content!.user!.id!,
                      false, false)
              : await Provider.of<WorkshopProvider>(context, listen: false)
                  .likePost(widget.result.id!, widget.result.content!.user!.id!,
                      true, false);

          // log(widget.workshop.id.toString());
          widget.effect();
        },
        icon: Icon(
          isLike
              ? Icons.favorite
              : Icons.favorite_border_outlined,
          color: isLike
              ? ColorResources.RED
              : ColorResources.GRAY_TEXT_COLOR,
        ));
  }
}
