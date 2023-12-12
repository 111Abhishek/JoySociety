import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/create_post_model.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/data/model/response/workshop_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/post_provider.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/provider/topic_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/app_bar.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/custom_decoration.dart';
import 'package:joy_society/view/screen/createPost/quickPost/widget/add_topic_widget.dart';
import 'package:joy_society/view/screen/createPost/quickPost/widget/post_to_bottom_sheet.dart';
import 'package:provider/provider.dart';

class QuickPostScreen extends StatefulWidget {
  final bool isFromTribe;
  final bool isFromWorkshop;
  final String? tribeId;
  final int? workshopId;

  QuickPostScreen(
      {Key? key,
      this.isFromTribe = false,
      this.isFromWorkshop = false,
      this.workshopId,
      this.tribeId})
      : super(key: key);

  @override
  State<QuickPostScreen> createState() => _QuickPostScreenState();
}

class _QuickPostScreenState extends State<QuickPostScreen> {
  ProfileModel? profile;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  String initValue = 'Questions';
  var itemList = ['Questions', 'Multi Choice', 'Hot Cold', 'Percentage'];
  File? file = null;
  final picker = ImagePicker();
  bool _isPollTypeVisible = false;
  TopicModel? selectedTopic;
  WorkshopModel? selectedWorkshop;
  String postingTo = "Joy Society";
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getTopicsList();
    profile = Provider.of<ProfileProvider>(context, listen: false).profileModel;
  }

  _getTopicsList() async {
    await Provider.of<TopicProvider>(context, listen: false)
        .getTopicsList()
        .then((value) {
      if (value != null) {}
    });
  }

  void _choose() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void showPollType() {
    setState(() {
      _isPollTypeVisible = !_isPollTypeVisible;
    });
  }

  void _addTopic() {
    showModalBottomSheet<int>(
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return AddTopicWidget(
            child: Consumer<TopicProvider>(builder: (context, topic, child) {
          return ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  topic.topicResponse.data!.length,
                  (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTopic = topic.topicResponse.data![index];
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 16.0, top: 16.0, right: 16.0, bottom: 0.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(color: ColorResources.GREEN)),
                        child: Text(
                          topic.topicResponse.data?[index].name ?? "",
                          style: poppinsRegular.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                        ),
                      )),
                ),
              ),
            ],
          );
        }));
      },
    );
  }

  void _postToBottomSheet() {
    Future<WorkshopModel?> future = showModalBottomSheet<WorkshopModel>(
      useRootNavigator: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return PostToBottomSheet();
      },
    );
    future.then((WorkshopModel? value) => _updatePostingTo(value));
  }

  void _updatePostingTo(WorkshopModel? value) {
    selectedWorkshop = value;
    setState(() {
      postingTo = selectedWorkshop?.title ?? "Joy Society";
    });
  }

  void _postQuickPost() async {
    CreatePostModel requestModel = CreatePostModel(
      post: _contentController.text.trim(),
      topic: selectedTopic?.id,
    );

    if (requestModel != null) {
      await Provider.of<PostProvider>(context, listen: false).createPost(
          requestModel, updateForumCallback, AppConstants.QUICK_POST);
    }
  }

  void _postTribeQuickPost() async {
    CreatePostModel requestModel = CreatePostModel(
        post: _contentController.text.trim(),
        workshop: null,
        topic: selectedTopic?.id,
        user: 1,
        tribe: widget.tribeId);

    if (requestModel != null) {
      await Provider.of<PostProvider>(context, listen: false).createPost(
          requestModel, updateForumCallback, AppConstants.QUICK_POST);
    }
  }

  void _postWorkshopQuickPost() async {
    CreatePostModel requestModel = CreatePostModel(
        post: _contentController.text.trim(),
        workshop: widget.workshopId,
        topic: selectedTopic?.id,
        user: 1);

    if (requestModel != null) {
      await Provider.of<PostProvider>(context, listen: false).createPost(
          requestModel, updateForumCallback, AppConstants.QUICK_POST);
    }
  }

  updateForumCallback(bool isStatusSuccess, CreatePostModel? createPostModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Quick Post created successfully'),
          backgroundColor: Colors.green));
      Navigator.of(context).pop();
      //Navigator.of(context).popUntil((_) => count++ >= 4);
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        if (errorDescription == null) {
          dynamic wrokshopError = errorResponse?.errorJson["workshop"];
          dynamic taglineError = errorResponse?.errorJson["tagline"];
          dynamic descriptionError = errorResponse?.errorJson["description"];
          dynamic privacyError = errorResponse?.errorJson["privacy"];

          if (wrokshopError != null && wrokshopError.length > 0) {
            //errorDescription = (wrokshopError![0]! as String).replaceAll("This field", "Title");
            errorDescription = "Workshop Does not exist.";
          } else if (taglineError != null && taglineError.length > 0) {
            errorDescription = (taglineError![0]! as String)
                .replaceAll("This field", "Tagline");
          } else if (descriptionError != null && descriptionError.length > 0) {
            errorDescription = (descriptionError![0]! as String)
                .replaceAll("This field", "Description");
          } else if (privacyError != null && privacyError.length > 0) {
            errorDescription = (privacyError![0]! as String)
                .replaceAll("This field", "Privacy");
          } else {
            errorDescription = 'Technical error, Please try again later!';
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorDescription!), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(context, getTranslated('QUICK_POST', context)),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          // _firstNameController.text = profile.userInfoModel?.fName ?? "";
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              //padding: const EdgeInsets.only(top: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16,),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Dimensions.MARGIN_SIZE_DEFAULT),
                    decoration: baseWhiteBoxDecoration(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: baseWhiteBoxDecoration(context),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.MARGIN_SIZE_SMALL,
                                  vertical: Dimensions.MARGIN_SIZE_SMALL),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                selectedTopic?.name ??
                                    getTranslated('ADD_TOPIC', context),
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL),
                              ).onTap(() {
                                _addTopic();
                              }),
                            )
                          ],
                        ),
                        Divider(color: ColorResources.DIVIDER_COLOR),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(
                                    left: 8, top: 5, bottom: 14),
                                width: 32,
                                height: 32,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(profile
                                      .profileModel?.profilePic ??
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRjLJbbPTTDQZxD4Mgl_iFBzlJ5kpBKXWg3g&usqp=CAU"),
                                  backgroundColor: Colors.transparent,
                                )),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: TextFormField(
                                cursorColor: Theme.of(context).primaryColor,
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_LARGE,
                                    color: ColorResources.TEXT_FORM_TEXT_COLOR),
                                maxLines: 4,
                                controller: _contentController,
                                decoration: InputDecoration(
                                  hintText: getTranslated(
                                      'hint_share_thought', context),
                                  contentPadding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  isDense: true,
                                  counterText: '',
                                  hintStyle: poppinsRegular.copyWith(
                                      color: Theme.of(context).hintColor,
                                      fontSize: Dimensions.FONT_SIZE_LARGE),
                                  errorStyle: TextStyle(height: 1.5),
                                  border: InputBorder.none,
                                ),
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Dimensions.MARGIN_SIZE_LARGE,
                        vertical: Dimensions.MARGIN_SIZE_LARGE),
                    child: !Provider.of<ProfileProvider>(context).isLoading
                        ? CustomButton(
                            onTap: () {
                              widget.isFromTribe
                                  ? _postTribeQuickPost()
                                  : (widget.isFromWorkshop
                                      ? _postWorkshopQuickPost()
                                      : _postQuickPost());
                            },
                            buttonText: getTranslated('POST', context))
                        : Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor))),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
