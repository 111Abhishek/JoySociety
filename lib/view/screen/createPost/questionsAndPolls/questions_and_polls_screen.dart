import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/create_post_model.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/data/model/response/tribe_model.dart';
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
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/screen/createPost/quickPost/widget/add_topic_widget.dart';
import 'package:joy_society/view/screen/createPost/quickPost/widget/post_to_bottom_sheet.dart';
import 'package:provider/provider.dart';

class QuestionsAndPollsScreen extends StatefulWidget {
  WorkshopModel? workshop;
  TribeModel? tribe;

  QuestionsAndPollsScreen({Key? key, this.workshop, this.tribe})
      : super(key: key);

  @override
  State<QuestionsAndPollsScreen> createState() =>
      _QuestionsAndPollsScreenState();
}

class _QuestionsAndPollsScreenState extends State<QuestionsAndPollsScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  String initValue = 'Question';
  var itemList = ['Question', 'Multiple Choice', 'Hot Cold', 'Percentage'];
  File? file = null;
  final picker = ImagePicker();
  bool _isPollTypeVisible = false;
  TopicModel? selectedTopic;
  WorkshopModel? selectedWorkshop;
  TribeModel? selectedTribe;
  String postingTo = "Joy Society";
  final TextEditingController _contentController = TextEditingController();
  static List<String?> choiceList = [null];
  bool choicesVisibility = false;

  @override
  void initState() {
    super.initState();
    _getTopicsList();
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

  void _postQuestionsAndPolls() async {
    CreatePostModel requestModel = CreatePostModel(
        question: _contentController.text.trim(),
        type: initValue.toUpperCase(),
        workshop: widget.workshop?.id,
        topic: selectedTopic?.id,
        tribe: widget.tribe?.id?.toString());

    if (initValue == "Multiple Choice") {
      if (requestModel != null) {
        requestModel =
            CreatePostModel.addAnswerChoices(requestModel, choiceList);
      }
    }

    if (requestModel != null) {
      await Provider.of<PostProvider>(context, listen: false).createPost(
          requestModel,
          updateForumCallback,
          AppConstants.QUESTION_AND_POLL_POST);
    }
  }

  updateForumCallback(bool isStatusSuccess, CreatePostModel? createPostModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      int count = 0;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Questions & Polls created successfully'),
            backgroundColor: Colors.green));
        Navigator.of(context).pop();
      }
      //Navigator.of(context).popUntil((_) => count++ >= 4);
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        if (errorDescription == null) {
          dynamic titleError = errorResponse?.errorJson["title"];
          dynamic taglineError = errorResponse?.errorJson["tagline"];
          dynamic descriptionError = errorResponse?.errorJson["description"];
          dynamic privacyError = errorResponse?.errorJson["privacy"];

          if (titleError != null && titleError.length > 0) {
            errorDescription =
                (titleError![0]! as String).replaceAll("This field", "Title");
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

  _onPollTypeChange(String? newValue) {
    setState(() {
      initValue = newValue!;
      if (initValue == "Multiple Choice") {
        choicesVisibility = true;
      } else {
        choicesVisibility = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar(context, getTranslated('QUESTION_AND_POLL', context)),
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
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Dimensions.MARGIN_SIZE_DEFAULT),
                    decoration: baseWhiteBoxDecoration(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const Divider(color: ColorResources.DIVIDER_COLOR),
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
                                      'what_would_you_like_to_ask', context),
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
                  // poll type
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: Dimensions.MARGIN_SIZE_DEFAULT,
                            left: Dimensions.MARGIN_SIZE_DEFAULT,
                            right: Dimensions.MARGIN_SIZE_DEFAULT),
                        child: Text(
                          getTranslated('POLL_TYPE', context),
                          style: poppinsBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_SMALL),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(
                            top: Dimensions.MARGIN_SIZE_SMALL,
                            left: Dimensions.MARGIN_SIZE_DEFAULT,
                            right: Dimensions.MARGIN_SIZE_DEFAULT),
                        decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 1))
                            // changes position of shadow
                          ],
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              isExpanded: true,
                              value: initValue,
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined),
                              items: itemList.map((String items) {
                                return DropdownMenuItem(
                                    value: items, child: Text(items));
                              }).toList(),
                              onChanged: (String? newValue) {
                                initValue = newValue!;
                                _onPollTypeChange(newValue);
                              }),
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      ..._getChoices(),
                    ],
                  ).visible(choicesVisibility),

                  Container(
                    margin: const EdgeInsets.only(
                        top: Dimensions.MARGIN_SIZE_DEFAULT,
                        left: Dimensions.MARGIN_SIZE_DEFAULT,
                        right: Dimensions.MARGIN_SIZE_DEFAULT),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: InkWell(
                            onTap: _choose,
                            child: Tooltip(
                              message: 'Add photo,video,and file',
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: CircleAvatar(
                                  backgroundColor: ColorResources.WHITE,
                                  radius: 15,
                                  child: Image.asset(Images.gallary_icon)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          child: Tooltip(
                            message: 'Create Pol',
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: CircleAvatar(
                                backgroundColor: ColorResources.WHITE,
                                radius: 15,
                                child: Image.asset(Images.icon_pie)),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          child: Tooltip(
                            message: 'Upload GIF',
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: CircleAvatar(
                                backgroundColor: ColorResources.WHITE,
                                radius: 15,
                                child: Image.asset(Images.icon_gif)),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          child: Tooltip(
                            message: 'Insert emoji',
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: CircleAvatar(
                                backgroundColor: ColorResources.WHITE,
                                radius: 15,
                                child: Image.asset(Images.icon_emoji)),
                          ),
                        ),
                        const SizedBox(
                          width: 65,
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          child: Tooltip(
                            message: 'Schedule post',
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: CircleAvatar(
                                backgroundColor: ColorResources.WHITE,
                                radius: 30,
                                child: IconButton(
                                  highlightColor: ColorResources.GREEN,
                                  onPressed: () {},
                                  icon: Image.asset(Images.icon_calendar),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ).visible(false),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Dimensions.MARGIN_SIZE_LARGE,
                        vertical: Dimensions.MARGIN_SIZE_LARGE),
                    child: !Provider.of<ProfileProvider>(context).isLoading
                        ? CustomButton(
                            onTap: () {
                              _postQuestionsAndPolls();
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

  List<Widget> _getChoices() {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < choiceList.length; i++) {
      friendsTextFields.add(
        Row(
          children: [
            Expanded(child: ChoicesTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == choiceList.length - 1, i),
          ],
        ).marginSymmetric(horizontal: 16, vertical: 10),
      );
    }
    return friendsTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          choiceList.insert(0, null);
        } else
          choiceList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ChoicesTextFields extends StatefulWidget {
  final int index;

  ChoicesTextFields(this.index);

  @override
  _ChoicesTextFieldsState createState() => _ChoicesTextFieldsState();
}

class _ChoicesTextFieldsState extends State<ChoicesTextFields> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text =
          _QuestionsAndPollsScreenState.choiceList[widget.index] ?? '';
    });

    return CustomTextField(
      controller: _nameController,
      /*focusNode: _workshopTitleFocus,
      nextNode: _workshopTaglineFocus,*/
      textInputAction: TextInputAction.next,
      onChanged: (v) =>
          _QuestionsAndPollsScreenState.choiceList[widget.index] = v,
      /*hintText: getTranslated('hint_workshop_title', context),*/
      hintText: 'Add a Choice',
    );
  }
}
