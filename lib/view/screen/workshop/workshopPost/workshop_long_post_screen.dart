import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:joy_society/data/model/posts/CreateScheduledQuickPostModel.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/topic_model.dart';
import 'package:joy_society/data/model/response/user_profile/profile_upload_image_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/post_provider.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/provider/topic_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/custom_decoration.dart';
import 'package:joy_society/view/screen/createPost/quickPost/widget/add_topic_widget.dart';
import 'package:provider/provider.dart';

class WorkshopLongPostScreen extends StatefulWidget {
  final int workshopId;

  const WorkshopLongPostScreen({super.key, required this.workshopId});

  @override
  State<WorkshopLongPostScreen> createState() => _WorkshopLongPostScreenState();
}

class _WorkshopLongPostScreenState extends State<WorkshopLongPostScreen> {
  final HtmlEditorController _htmlController = HtmlEditorController();

  DateTime? scheduledDateTime;
  bool scheduleWidgetSelected = false;

  _getTopicsList() async {
    await Provider.of<TopicProvider>(context, listen: false).getTopicsList();
  }

  _getProfile() async {
    await Provider.of<ProfileProvider>(context, listen: false).getProfileData();
  }

  TopicModel? selectedTopic;

  @override
  void initState() {
    super.initState();
    _getTopicsList();
    _getProfile();
  }

  @override
  void dispose() {
    super.dispose();
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

  Future _performLongPost(String text) async {
    if (text.isEmpty) {
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
          post: text, topic: selectedTopic?.id, workshop: widget.workshopId);
      await Provider.of<PostProvider>(context, listen: false)
          .createScheduledQuickPost(model, AppConstants.LONG_POST,
              (bool isSuccess, ErrorResponse? error) {
        if (isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Posted to Workshop successfully!',
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
              "Long Post",
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
                            ],
                          ),
                          const Divider(color: ColorResources.DIVIDER_COLOR),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: HtmlEditor(
                                controller: _htmlController,
                                htmlToolbarOptions: HtmlToolbarOptions(
                                    toolbarType: ToolbarType.nativeScrollable,
                                    mediaUploadInterceptor: (PlatformFile file,
                                        InsertFileType type) async {
                                      if (file.bytes != null) {
                                        if (type == InsertFileType.image) {
                                          await Provider.of<PostProvider>(
                                                  context,
                                                  listen: false)
                                              .uploadImage(file, "Post",
                                                  (bool isSuccess,
                                                      ProfileUploadImageModel?
                                                          response,
                                                      ErrorResponse?
                                                          errorResponse) {
                                            if (isSuccess) {
                                              print(
                                                  'Success url: ${response!.fileUrl}');
                                              _htmlController
                                                  .insertNetworkImage(
                                                      response.fileUrl!);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Error uploading image',
                                                    style:
                                                        poppinsMedium.copyWith(
                                                            fontSize: 12,
                                                            color:
                                                                ColorResources
                                                                    .WHITE)),
                                                backgroundColor:
                                                    Colors.pinkAccent.shade700,
                                              ));
                                            }
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Please upload an image!',
                                                style: poppinsMedium.copyWith(
                                                    fontSize: 12,
                                                    color:
                                                        ColorResources.WHITE)),
                                            backgroundColor:
                                                Colors.pinkAccent.shade700,
                                          ));
                                        }
                                      }
                                      return false;
                                    }),
                                htmlEditorOptions: const HtmlEditorOptions(
                                  hint: "Your text here...",
                                  darkMode: false,
                                  //initalText: "text content initial, if any",
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
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
                              onTap: () {
                                _htmlController
                                    .getText()
                                    .then((value) => {_performLongPost(value)});
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
