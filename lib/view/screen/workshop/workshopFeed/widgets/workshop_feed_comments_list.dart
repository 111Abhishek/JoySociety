import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/data/model/response/workshop_feed_response_model.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/screen/workshop/workshopFeed/widgets/workshop_feed_comment_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class WorkshopFeedCommentListWidget extends StatefulWidget {
  final Result workshopPost;
  ProfileModel? userProfile;
  final List<Comment> comments;
  final Function effect;
  final bool canReply;

  WorkshopFeedCommentListWidget(
      {super.key,
      required this.workshopPost,
      required this.comments,
      this.userProfile,
      required this.canReply,
      required this.effect});

  @override
  State<WorkshopFeedCommentListWidget> createState() =>
      _WorkshopFeedCommentListWidgetState();
}

class _WorkshopFeedCommentListWidgetState
    extends State<WorkshopFeedCommentListWidget> {
  // late List<Comment> postComments;

  @override
  void initState() {
    super.initState();
    // postComments = widget.comments;
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.comments.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var commentObj = widget.comments[index];
          return WorkshopFeedCommentWidget(
              effect: widget.effect,
              workshopPost: widget.workshopPost,
              userProfile: widget.userProfile,
              replyingCapability: widget.canReply,
              comment: commentObj);
        });
    ;
  }
}
