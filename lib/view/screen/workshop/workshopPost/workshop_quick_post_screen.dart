import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/custom_decoration.dart';
import 'package:joy_society/view/screen/createPost/quickPost/quick_post_screen.dart';
import 'package:joy_society/view/screen/createPost/quickPost/widget/add_topic_widget.dart';
import 'package:joy_society/view/screen/schedulePost/widgets/emoji_selector.dart';
import 'package:provider/provider.dart';

class WorkshopQuickPostScreen extends StatefulWidget {
  int workshopId;

  WorkshopQuickPostScreen({super.key, required this.workshopId});

  @override
  State<WorkshopQuickPostScreen> createState() =>
      _WorkshopQuickPostScreenState();
}

class _WorkshopQuickPostScreenState extends State<WorkshopQuickPostScreen> {
  _getTopicsList() async {
    await Provider.of<TopicProvider>(context, listen: false).getTopicsList();
  }

  _getProfile() async {
    await Provider.of<ProfileProvider>(context, listen: false).getProfileData();
  }

  TopicModel? selectedTopic;

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

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'CLOSE',
          onPressed: scaffold.hideCurrentSnackBar,
        )));
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

  Future _performWorkshopQuickPost() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Post content cannot be empty',
          style:
              poppinsMedium.copyWith(fontSize: 12, color: ColorResources.WHITE),
        ),
        backgroundColor: Colors.pinkAccent.shade700,
      ));
    } else {
      // creating the request model here
      QuickPostRequestModel model = QuickPostRequestModel(
          post: _contentController.text,
          topic: selectedTopic?.id,
          workshop: widget.workshopId);
      await Provider.of<PostProvider>(context, listen: false)
          .createScheduledQuickPost(model, AppConstants.QUICK_POST,
              (bool isSuccess, ErrorResponse? error) {
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Posted to workshop successfully!',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          children: [
            CupertinoNavigationBarBackButton(
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.black,
            ),
            const SizedBox(width: 10),
            Image.asset(
              Images.logo_with_name_image,
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 16),
            Text(
              "Quick Post",
              style: poppinsBold.copyWith(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Consumer<ProfileProvider>(
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
                                      color:
                                          ColorResources.TEXT_FORM_TEXT_COLOR),
                                  maxLines: 4,
                                  controller: _contentController,
                                  focusNode: contentFocusNode,
                                  decoration: InputDecoration(
                                    hintText: getTranslated(
                                        'hint_share_thought', context),
                                    contentPadding: const EdgeInsets.only(
                                        left: 8, right: 8),
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: Dimensions.MARGIN_SIZE_LARGE,
                          vertical: Dimensions.MARGIN_SIZE_LARGE),
                      child: !Provider.of<ProfileProvider>(context).isLoading &&
                              !Provider.of<PostProvider>(context, listen: false)
                                  .isLoading
                          ? CustomButton(
                              onTap: () async {
                                _performWorkshopQuickPost();
                              },
                              buttonText: 'Post')
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
      ),
    );
  }
}
