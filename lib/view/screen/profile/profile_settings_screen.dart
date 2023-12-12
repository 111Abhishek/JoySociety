import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/data/model/response/user_profile/profile_upload_image_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/provider/splash_provider.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/system_utils.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/show_custom_snakbar.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/screen/locations/locations_screen.dart';
import 'package:joy_society/view/screen/profile/widgets/personal_link_fields.dart';
import 'package:joy_society/view/screen/timezone/timezone_screen.dart';
import 'package:provider/provider.dart';
import 'package:quiver/collection.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  ProfileSettingsScreenState createState() => ProfileSettingsScreenState();
}

class ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  // creating a formkey
  final _formkey = GlobalKey<ProfileSettingsScreenState>();

  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _miniBioFocus = FocusNode();
  final FocusNode _aboutMeFocus = FocusNode();
  final FocusNode _personalLinkFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _miniBioController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

  // personal link controller
  final TextEditingController _personalLinkController = TextEditingController();

  // getting the list of personalLinks
  static List<String?> personalLinksList = [null];

  @override
  void dispose() {
    // disposing the focusnodes
    _fNameFocus.dispose();
    _emailFocus.dispose();
    _addressFocus.dispose();
    _miniBioFocus.dispose();
    _aboutMeFocus.dispose();
    _personalLinkFocus.dispose();

    // disposing the controllers
    _firstNameController.dispose();
    _miniBioController.dispose();
    _aboutMeController.dispose();
    _personalLinkController.dispose();

    super.dispose();
  }

  File? file;
  String? imageUrl;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  CommonListData? locationData = CommonListData(name: "-- Location --");
  CommonListData? timezoneData = CommonListData(name: "-- Timezone --");

  Future _uploadImage(File currentFile) async {
    await Provider.of<ProfileProvider>(context, listen: false)
        .uploadImage(currentFile, 'Profile', (bool isSuccess,
            ProfileUploadImageModel? result, ErrorResponse? error) async {
      if (isSuccess) {
        if (result != null) {
          setState(() {
            file = currentFile;
            imageUrl = result.fileUrl;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Unable to upload image"),
            backgroundColor: Colors.red));
      }
    });
  }

  void _choose() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    if (pickedFile != null) {
      File currentFile = File(pickedFile.path);
      await _uploadImage(currentFile);
    } else {
      log('No image selected');
    }
    // setState(() {
    //   if (pickedFile != null) {
    //     file = File(pickedFile.path);
    //     // here call the upload endpoint
    //   } else {
    //     log('No image selected.');
    //   }
    // });
  }

  void _removePersonalLink(int index) {
    personalLinksList.removeAt(index);
    setState(() {});
  }

  void _addPersonalLink() {
    String? lastLink = personalLinksList[personalLinksList.length - 1];
    if (lastLink != null && lastLink.isNotEmpty) {
      personalLinksList.insert(personalLinksList.length, "");
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please enter a bio link to add another one"),
          backgroundColor: ColorResources.RED));
    }
  }

  _updateUserAccount() async {
    String fullName = _firstNameController.text.trim();
    String miniBio = _miniBioController.text.trim();
    String personalLink = _personalLinkController.text.trim();

    ProfileModel? profileModel =
        Provider.of<ProfileProvider>(context, listen: false).profileModel;

    List<String> personalLinks = personalLinksList
        .whereType<String>()
        .where((element) => element.isNotEmpty)
        .toList();

    if (profileModel?.fullName == _firstNameController.text &&
        profileModel?.miniBio == _miniBioController.text &&
        profileModel?.location == locationData &&
        profileModel?.timezone == timezoneData &&
        profileModel?.profilePic == imageUrl &&
        listsEqual(profileModel?.personalLinks, personalLinks)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Change something to update'),
          backgroundColor: ColorResources.RED));
    } else if (fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('NAME_FIELD_MUST_BE_REQUIRED', context)),
          backgroundColor: ColorResources.RED));
    } else {
      ProfileModel profileModel = ProfileModel(
          fullName: fullName,
          profilePic: imageUrl,
          miniBio: miniBio,
          personalLinks: personalLinks,
          location: locationData,
          timezone: timezoneData);

      await Provider.of<ProfileProvider>(context, listen: false)
          .updateProfile(profileModel, route);
    }
  }

  route(bool isRoute, ProfileModel? responseModel,
      ErrorResponse? errorResponse) async {
    if (isRoute) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Profile Updated Successfully"),
          backgroundColor: Theme.of(context).primaryColor));
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        if (errorDescription == null) {
          dynamic fullNameError = errorResponse?.errorJson["full_name"];
          dynamic locationError = errorResponse?.errorJson["location"];

          if (fullNameError != null && fullNameError.length > 0) {
            errorDescription = fullNameError![0]!;
          } else if (locationError != null && locationError.length > 0) {
            errorDescription = locationError![0]!;
          } else {
            errorDescription = 'Technical error, Please try again later!';
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorDescription!), backgroundColor: Colors.red));
    }
  }

  _getProfileData() async {
    await Provider.of<ProfileProvider>(context, listen: false)
        .getProfileData()
        .then((value) {
      if (value != null) {
        log(value);
        _firstNameController.text = value.fullName ?? "";
        _miniBioController.text = value.miniBio ?? "";
        _personalLinkController.text = value.personalLinks?[0] ?? "";
        imageUrl = value.profilePic;
        if (value.personalLinks != null) {
          personalLinksList = value.personalLinks!.isEmpty
              ? [null]
              : List.of(value.personalLinks!);
        } else {
          personalLinksList = [null];
        }
        if (value.location != null) {
          locationData = value.location;
        }
        if (value.timezone != null) {
          timezoneData = value.timezone;
        }
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      personalLinksList = [null];
    });
    _getProfileData();
  }

  List<Widget> _getPersonalLinks() {
    List<Widget> personalLinksWidgetList = [];
    for (int i = 0; i < personalLinksList.length; i++) {
      personalLinksWidgetList.add(
        Column(children: [
          Row(
            children: [
              Expanded(
                child: PersonalLinkFields(index: i),
              ),
              const SizedBox(
                width: Dimensions.MARGIN_SIZE_DEFAULT,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: i == (personalLinksList.length - 1)
                      ? ColorResources.DARK_GREEN_COLOR
                      : Colors.pink.shade800,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 1)) // changes position of shadow
                  ],
                ),
                child: (i == personalLinksList.length - 1)
                    ? IconButton(
                        onPressed: () {
                          _addPersonalLink();
                        },
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(Icons.add,
                            color: ColorResources.WHITE, size: 18),
                        color: ColorResources.DARK_GREEN_COLOR,
                      )
                    : IconButton(
                        onPressed: () {
                          _removePersonalLink(i);
                        },
                        padding: const EdgeInsets.all(0),
                        icon: const Icon(Icons.remove,
                            color: ColorResources.WHITE, size: 18),
                        color: ColorResources.DARK_GREEN_COLOR,
                      ),
              ),
            ],
          ),
          const SizedBox(
            height: Dimensions.MARGIN_SIZE_SMALL,
          )
        ]),
      );
    }
    return personalLinksWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.black,
              ),
              Image.asset(Images.logo_with_name_image, height: 40, width: 40),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Profile Settings",
                      style: poppinsBold.copyWith(
                          fontSize: 16, color: Colors.black)),
                  Text(
                    "Update your Profile",
                    style: poppinsSemiBold.copyWith(
                        fontSize: 12, color: Colors.black54),
                  )
                ],
              )
            ],
          )),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          //_firstNameController.text = profile.profileModel?.fullName ?? "";

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Colors.white, width: 3),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: file == null
                                  ? FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      image:
                                          '${profile.profileModel?.profilePic}',
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(Images.placeholder,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover),
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
                                    ColorResources.DARK_GREEN_COLOR,
                                radius: 14,
                                child: IconButton(
                                  onPressed: _choose,
                                  padding: const EdgeInsets.all(0),
                                  icon: const Icon(Icons.edit,
                                      color: ColorResources.WHITE, size: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: ColorResources.getIconBg(context),
                          borderRadius: const BorderRadius.only(
                            topLeft:
                                Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                            topRight:
                                Radius.circular(Dimensions.MARGIN_SIZE_DEFAULT),
                          )),
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            getTranslated('FULL_NAME', context),
                                            style: customTextFieldTitle),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: Dimensions.MARGIN_SIZE_SMALL),
                                    CustomTextField(
                                      textInputType: TextInputType.name,
                                      focusNode: _fNameFocus,
                                      nextNode: _emailFocus,
                                      hintText:
                                          getTranslated('FULL_NAME', context),
                                      controller: _firstNameController,
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),

                          // for Mini Bio
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Text('Title', style: customTextFieldTitle),
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                                CustomTextField(
                                  textInputType: TextInputType.text,
                                  focusNode: _miniBioFocus,
                                  nextNode: _aboutMeFocus,
                                  hintText:
                                      getTranslated('hint_mini_bio', context),
                                  controller: _miniBioController,
                                  maxLine: 4,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Text('About me',
                                        style: customTextFieldTitle),
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                                CustomTextField(
                                  textInputType: TextInputType.text,
                                  focusNode: _aboutMeFocus,
                                  nextNode: _personalLinkFocus,
                                  hintText: 'About Me',
                                  controller: _aboutMeController,
                                  maxLine: 4,
                                ),
                              ],
                            ),
                          ),

                          // for Phone No
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        getTranslated('PERSONAL_LINK', context),
                                        style: customTextFieldTitle),
                                    Text(
                                      getTranslated(
                                          'PERSONAL_LINK_SUB_TITLE', context),
                                      style: poppinsRegular.copyWith(
                                        fontSize:
                                            Dimensions.FONT_SIZE_EXTRA_SMALL,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL,
                                    ),
                                    ..._getPersonalLinks()
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                              ],
                            ),
                          ),

                          // for Location
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        getTranslated('LOCATION', context),
                                        style: customTextFieldTitle,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).highlightColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: const Offset(0,
                                              1)) // changes position of shadow
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          locationData!.name!,
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_DEFAULT,
                                              color: ColorResources.BLACK),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).onTap(() async {
                            CommonListData? result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LocationsScreen()));
                            if (result != null) {
                              setState(() {
                                locationData = result;
                              });
                            }
                          }),

                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(getTranslated('TIMEZONE', context),
                                        style: customTextFieldTitle),
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).highlightColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.1),
                                          spreadRadius: 1,
                                          blurRadius: 3,
                                          offset: const Offset(0,
                                              1)) // changes position of shadow
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          timezoneData!.name!,
                                          style: poppinsRegular.copyWith(
                                              fontSize:
                                                  Dimensions.FONT_SIZE_DEFAULT,
                                              color: ColorResources.BLACK),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Icon(
                                          Icons.keyboard_arrow_down_outlined),
                                    ],
                                  ),
                                ).onTap(() async {
                                  CommonListData? result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const TimezoneScreen()));
                                  if (result != null) {
                                    setState(() {
                                      timezoneData = result;
                                    });
                                  }
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Dimensions.MARGIN_SIZE_LARGE,
                        vertical: Dimensions.MARGIN_SIZE_SMALL),
                    child: !Provider.of<ProfileProvider>(context).isLoading
                        ? CustomButton(
                            onTap: _updateUserAccount,
                            buttonText: getTranslated('SAVE', context))
                        : Center(
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor))),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
