import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:joy_society/data/model/posts/CreateScheduledQuickPostModel.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/post_provider.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/provider/topic_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/custom_decoration.dart';
import 'package:joy_society/view/screen/createPost/quickPost/widget/add_topic_widget.dart';
import 'package:joy_society/view/screen/schedulePost/widgets/emoji_selector.dart';
import 'package:provider/provider.dart';

class ScheduleQuickPost extends StatefulWidget {
  const ScheduleQuickPost({super.key});

  @override
  State<ScheduleQuickPost> createState() => _ScheduleQuickPostState();
}

class _ScheduleQuickPostState extends State<ScheduleQuickPost> {
  _getTopicsList() async {
    await Provider.of<TopicProvider>(context, listen: false).getTopicsList();
  }

  _getProfile() async {
    await Provider.of<ProfileProvider>(context, listen: false).getProfileData();
  }

  TopicModel? selectedTopic;

  DateTime? scheduledDateTime;
  bool scheduleWidgetSelected = false;

  bool emojiSelected = false;

  final TextEditingController _contentController = TextEditingController();

  final FocusNode contentFocusNode = FocusNode();

  @override
  void dispose() {
    contentFocusNode.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getTopicsList();
    _getProfile();
  }

  Future _performSchedulePost() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Post content cannot be null',
          style:
              poppinsMedium.copyWith(fontSize: 12, color: ColorResources.WHITE),
        ),
        backgroundColor: Colors.pinkAccent.shade700,
      ));
    } else if (scheduledDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Scheduled time cannot be empty',
            style: poppinsMedium.copyWith(
                fontSize: 12, color: ColorResources.WHITE)),
        backgroundColor: Colors.pinkAccent.shade700,
      ));
    } else {
      // creating the request model here
      QuickPostRequestModel model = QuickPostRequestModel(
          post: _contentController.text,
          topic: selectedTopic?.id,
          schedule: scheduledDateTime);
      await Provider.of<PostProvider>(context, listen: false)
          .createScheduledQuickPost(model, AppConstants.QUICK_POST,
              (bool isSuccess, ErrorResponse? error) {
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Post scheduled successfully!',
                style: poppinsMedium.copyWith(
                    fontSize: 12, color: ColorResources.WHITE)),
            backgroundColor: ColorResources.DARK_GREEN_COLOR,
          ));
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Technical error happened! Try again later!',
                style: poppinsMedium.copyWith(
                    fontSize: 12, color: ColorResources.WHITE)),
            backgroundColor: Colors.pinkAccent.shade700,
          ));
        }
      });
    }
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
                                const BorderRadius.all(Radius.circular(10.0)),
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

  dateTimePickerWidget(BuildContext context) {
    return DatePicker.showDatePicker(context,
        dateFormat: 'dd MMMM yyyy HH:mm',
        initialDateTime: DateTime.now(),
        minDateTime: DateTime.now(),
        maxDateTime: DateTime(3000),
        onMonthChangeStartWithFirstDate: true, onCancel: () {
      setState(() {
        scheduleWidgetSelected = !scheduleWidgetSelected;
      });
    }, onConfirm: (dateTime, List<int> index) {
      DateTime selectedDate = dateTime;
      setState(() {
        scheduleWidgetSelected = !scheduleWidgetSelected;
        scheduledDateTime = selectedDate;
      });
      // removing the focus from the keyboard
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profile, child) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(
                vertical: Dimensions.MARGIN_SIZE_LARGE),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: Dimensions.MARGIN_SIZE_DEFAULT),
                  decoration: baseWhiteBoxDecoration(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: baseWhiteBoxDecoration(context),
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.MARGIN_SIZE_SMALL,
                                vertical: Dimensions.MARGIN_SIZE_SMALL),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              selectedTopic?.name != null
                                  ? '#${selectedTopic!.name}'
                                  : getTranslated('ADD_TOPIC', context),
                              style: poppinsMedium.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_SMALL),
                            ).onTap(() {
                              _addTopic();
                            }),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                emojiSelected = !emojiSelected;
                              });
                            },
                            icon: emojiSelected
                                ? const Icon(Icons.emoji_emotions)
                                : const Icon(Icons.emoji_emotions_outlined),
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
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: TextFormField(
                              cursorColor: Theme.of(context).primaryColor,
                              style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                  color: ColorResources.TEXT_FORM_TEXT_COLOR),
                              maxLines: 4,
                              controller: _contentController,
                              focusNode: contentFocusNode,
                              decoration: InputDecoration(
                                hintText: getTranslated(
                                    'hint_share_thought', context),
                                contentPadding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                isDense: true,
                                counterText: '',
                                hintStyle: poppinsRegular.copyWith(
                                    color: Theme.of(context).hintColor,
                                    fontSize: Dimensions.FONT_SIZE_DEFAULT),
                                errorStyle: const TextStyle(height: 1.5),
                                border: InputBorder.none,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
                Offstage(
                    offstage: !emojiSelected,
                    child: EmojiSelector(
                      controller: _contentController,
                    )),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Schedule a time',
                        style: poppinsSemiBold.copyWith(
                            fontSize: 12, color: Colors.black),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      scheduleWidgetSelected =
                                          !scheduleWidgetSelected;
                                    });
                                    dateTimePickerWidget(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    decoration: baseWhiteBoxDecoration(context),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        scheduledDateTime != null
                                            ? Text(
                                                DateFormat(
                                                        'dd-MMM-yyyy - HH:mm')
                                                    .format(scheduledDateTime!),
                                                style: poppinsRegular.copyWith(
                                                    fontSize: 12,
                                                    color:
                                                        ColorResources.BLACK),
                                              )
                                            : Text(
                                                'Please select a data and time',
                                                style: poppinsRegular.copyWith(
                                                    fontSize: 12,
                                                    color: ColorResources
                                                        .GRAY_TEXT_COLOR)),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              scheduleWidgetSelected =
                                                  !scheduleWidgetSelected;
                                            });
                                            dateTimePickerWidget(context);
                                          },
                                          icon: scheduleWidgetSelected
                                              ? const Icon(Icons.calendar_today,
                                                  size: 24,
                                                  color: Colors.black54)
                                              : const Icon(
                                                  Icons.calendar_today_outlined,
                                                  size: 24,
                                                  color: Colors.black54),
                                        )
                                      ],
                                    ),
                                  )))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: Dimensions.MARGIN_SIZE_LARGE,
                      vertical: Dimensions.MARGIN_SIZE_LARGE),
                  child: !Provider.of<ProfileProvider>(context).isLoading
                      ? CustomButton(
                          onTap: () async {
                            _performSchedulePost();
                          },
                          buttonText: 'Schedule Post')
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
    );
  }
}
