import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/provider/topic_provider.dart';
import 'package:provider/provider.dart';

import '../../../../localization/language_constants.dart';
import '../../../../provider/profile_provider.dart';
import '../../../../provider/splash_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/button/custom_button.dart';
import '../../../basewidget/textfield/custom_textfield.dart';

class EditTopicScreen extends StatefulWidget {
  final TopicModel? topicModel;
  const EditTopicScreen({Key? key, this.topicModel}) : super(key: key);

  @override
  State<EditTopicScreen> createState() => _EditTopicScreenState();
}

class _EditTopicScreenState extends State<EditTopicScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  String initValue = 'Questions';
  var itemList = ['Questions', 'Multi Choice', 'Hot Cold', 'Percentage'];
  File? file = null;
  final picker = ImagePicker();

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

  _updateTopicDetails() async {
    TopicModel? requestModel = getTopicDetails();
    if(requestModel != null) {
      await Provider.of<TopicProvider>(context, listen: false)
          .saveTopic(requestModel, updateForumCallback);
    }
  }

  TopicModel? getTopicDetails() {
    if(widget.topicModel?.id != null) {
      TopicModel topicModel = TopicModel(id: widget.topicModel?.id ?? 0,
          order: widget.topicModel?.order ?? 0, name: _topicNameController.text,
          /*contributor: initValue,*/ description : _topicDescController.text,
        color: _topicColorController.text, background_image: widget.topicModel?.background_image ?? ''
      );
      return topicModel;
    }
  }

  updateForumCallback(
      bool isStatusSuccess,
      TopicModel? topicModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Topic details updated successfully'),
          backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        if (errorDescription == null) {
          dynamic contributorError = errorResponse?.errorJson["contributor"];

          if (contributorError != null && contributorError.length > 0) {
            errorDescription = contributorError![0]!;
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
  void initState() {
    super.initState();
    if(widget.topicModel != null) {
      _topicNameController.text = widget.topicModel?.name ?? '';
      _topicDescController.text = widget.topicModel?.description ?? '';
      _topicColorController.text = widget.topicModel?.color ?? '';

      if(widget.topicModel?.contributor != null && widget.topicModel!.contributor!.isNotEmpty) {
        setState(() {
          initValue = widget.topicModel!.contributor!;
        });
      }

    }
  }

  final FocusNode _topicNameFocus = FocusNode();
  final FocusNode _topicDescFocus = FocusNode();
  final FocusNode _topicColorFocus = FocusNode();

  final TextEditingController _topicNameController = TextEditingController();
  final TextEditingController _topicDescController = TextEditingController();
  final TextEditingController _topicColorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          //  _emailController.text = profile.userPhoneEmailModel?.email ?? "";
          return Stack(
            clipBehavior: Clip.none,
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
                  Text(getTranslated('EDIT_TOPICS', context),
                      style: poppinsBold.copyWith(
                          fontSize: 20, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ]),
              ),
              Container(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    const SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorResources.getIconBg(context),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              topRight: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                            )),
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            // for topic name
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      getTranslated(
                                          'NAME_YOUR_TOPICS', context),
                                      style: customTextFieldTitle),
                                  SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType.emailAddress,
                                    focusNode: _topicNameFocus,
                                    nextNode: _topicDescFocus,
                                    /* hintText:
                                        getTranslated('hint_email', context),*/
                                    controller: _topicNameController,
                                  ),
                                ],
                              ),
                            ),
                            //for contribute
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      getTranslated(
                                          'CONTRIBUTE_YOUR_TOPICS', context),
                                      style: customTextFieldTitle),
                                  SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).highlightColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 1))
                                        // changes position of shadow
                                      ],
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          isExpanded: true,
                                          value: initValue,
                                          icon: const Icon(Icons
                                              .keyboard_arrow_down_outlined),
                                          items: itemList.map((String items) {
                                            return DropdownMenuItem(
                                                value: items,
                                                child: Text(items));
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              initValue = newValue!;
                                            });
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //for topic desc
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      getTranslated(
                                          'DESC_YOUR_TOPICS', context),
                                      style: customTextFieldTitle),
                                  SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    controller: _topicDescController,
                                    focusNode: _topicDescFocus,
                                    nextNode: _topicColorFocus,
                                    textInputAction: TextInputAction.next,
                                    hintText: getTranslated(
                                        'hint_current_password', context),
                                    maxLine: 4,
                                  ),
                                ],
                              ),
                            ),
                            // for topic color
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      getTranslated(
                                          'COLOR_YOUR_TOPICS', context),
                                      style: customTextFieldTitle),
                                  SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  Container(
                                      padding: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).highlightColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 1))
                                          // changes position of shadow
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated(
                                                'COLOR_YOUR_TOPICS_TITLE',
                                                context),
                                            style: poppinsRegular.copyWith(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                              height:
                                                  Dimensions.MARGIN_SIZE_SMALL),
                                          CustomTextField(
                                            controller: _topicColorController,
                                            focusNode: _topicColorFocus,
                                            //  nextNode: _topicColorFocus,
                                            textInputAction:
                                                TextInputAction.next,
                                            hintText: getTranslated(
                                                'COLOR_CODE_YOUR_TOPICS',
                                                context),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            //for topic image
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  Container(
                                      padding: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).highlightColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 1))
                                          // changes position of shadow
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                top: Dimensions
                                                    .MARGIN_SIZE_EXTRA_LARGE),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 3),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: file == null
                                                      ? FadeInImage
                                                          .assetNetwork(
                                                          placeholder: Images
                                                              .placeholder,
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit.cover,
                                                          image:
                                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls?.customerImageUrl}/${profile.profileModel?.profilePic}',
                                                          imageErrorBuilder: (c,
                                                                  o, s) =>
                                                              Image.asset(
                                                                  Images
                                                                      .placeholder,
                                                                  width: 100,
                                                                  height: 100,
                                                                  fit: BoxFit
                                                                      .cover),
                                                        )
                                                      : Image.file(file!,
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit.fill),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        ColorResources
                                                            .DARK_GREEN_COLOR,
                                                    radius: 14,
                                                    child: IconButton(
                                                      onPressed: _choose,
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      icon: Icon(Icons.edit,
                                                          color: ColorResources
                                                              .WHITE,
                                                          size: 18),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                              height:
                                                  Dimensions.MARGIN_SIZE_SMALL),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  getTranslated(
                                                      'IMAGE_YOUR_TOPICS',
                                                      context),
                                                  style: poppinsBold.copyWith(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                  maxLines: 1),
                                              Text(
                                                  getTranslated(
                                                      'IMAGE_SIZE_YOUR_TOPICS',
                                                      context),
                                                  style:
                                                      poppinsRegular.copyWith(
                                                          fontSize: 16,
                                                          color: Colors.black),
                                                  maxLines: 1),
                                            ],
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.MARGIN_SIZE_DEFAULT,
                                          vertical:
                                              Dimensions.MARGIN_SIZE_LARGE),
                                      child: !Provider.of<ProfileProvider>(
                                                  context)
                                              .isLoading
                                          ? CustomButton(
                                              onTap: () {},
                                              isCapital: false,
                                              buttonText: getTranslated(
                                                  'DELETE', context),)
                                          : Center(
                                              child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Theme.of(context)
                                                              .primaryColor))),
                                    ),
                                  ],
                                )),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.MARGIN_SIZE_DEFAULT,
                                          vertical:
                                              Dimensions.MARGIN_SIZE_LARGE),
                                      child: !Provider.of<ProfileProvider>(
                                                  context)
                                              .isLoading
                                          ? CustomButton(
                                              onTap: () {
                                                _updateTopicDetails();
                                              },
                                              buttonText: getTranslated(
                                                  'SAVE_CHANGES', context))
                                          : Center(
                                              child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Theme.of(context)
                                                              .primaryColor))),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
