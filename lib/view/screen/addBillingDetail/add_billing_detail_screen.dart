import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/data/model/response/user_billing_detail_model.dart';
import 'package:joy_society/data/model/response/user_info_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/auth_provider.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/show_custom_snakbar.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/screen/cityListScreen/city_list_screen.dart';
import 'package:joy_society/view/screen/countryListScreen/country_list_screen.dart';
import 'package:joy_society/view/screen/stateListScreen/state_list_screen.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/base/error_response.dart';

class AddBillingDetailScreen extends StatefulWidget {
  @override
  _AddBillingDetailScreenState createState() => _AddBillingDetailScreenState();
}

class _AddBillingDetailScreenState extends State<AddBillingDetailScreen> {
  final FocusNode _addressLine1 = FocusNode();
  final FocusNode _addressLine2 = FocusNode();
  final FocusNode _zipcode = FocusNode();

  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();

  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  CommonListData? countryData = CommonListData(name: "- Select Country -");
  CommonListData? stateData =
      CommonListData(name: "- Select State or Province-");
  CommonListData? cityData = CommonListData(name: "- Select City -");




  _updateUserAccount() async {
    String _addressLine1 = _addressLine1Controller.text.trim();
    String _addressLine2 = _addressLine2Controller.text.trim();
    String _zipCode = _zipcodeController.text.trim();

    if (_addressLine1.isEmpty && _addressLine2.isEmpty && _zipCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Change something to update'),
          backgroundColor: ColorResources.RED));
    } else {
      if (_addressLine1Controller.text.isEmpty &&
          _addressLine2Controller.text.isEmpty &&
          _zipcodeController.text.isEmpty) {
        // update phone and email
        _updateUserDetails();
      } else {
        // update all values
        _updateUserDetails();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getBillingDetails();
  }

  UserBillingDetailModel getUserDetails() {
    UserBillingDetailModel userBillingDetailModel = UserBillingDetailModel();
    userBillingDetailModel.addressLine1 = _addressLine1Controller.text.trim();
    userBillingDetailModel.addressLine2 = _addressLine2Controller.text.trim();
    userBillingDetailModel.country = countryData!;
    userBillingDetailModel.state = stateData!;
    userBillingDetailModel.city = cityData!;
    userBillingDetailModel.postCode = _zipcodeController.text.trim();
    return userBillingDetailModel;
  }

  _updateUserDetails() async {
    await Provider.of<ProfileProvider>(context, listen: false)
        .saveBillingDetail(getUserDetails(), updateForumCallback);
  }

  updateForumCallback(
      bool isStatusSuccess,
      UserBillingDetailModel? userBillingDetailModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User details updated successfully'),
          backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        if (errorDescription == null) {
          dynamic addressLine1lError =
              errorResponse?.errorJson["address_line_1"];
          dynamic countryError = errorResponse?.errorJson["country"];
          dynamic stateError = errorResponse?.errorJson["state"];
          dynamic cityError = errorResponse?.errorJson["city"];
          dynamic postalCodeError = errorResponse?.errorJson["postal_code"];

          if (addressLine1lError != null && addressLine1lError.length > 0) {
            errorDescription = addressLine1lError![0]!;
          } else if (countryError != null && countryError.length > 0) {
            errorDescription = countryError![0]!;
          } else if (stateError != null && stateError.length > 0) {
            errorDescription = stateError![0]!;
          } else if (cityError != null && cityError.length > 0) {
            errorDescription = cityError![0]!;
          } else if (postalCodeError != null && postalCodeError.length > 0) {
            errorDescription = postalCodeError![0]!;
          } else {
            errorDescription = 'Technical error, Please try again later!';
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorDescription!), backgroundColor: Colors.red));
    }
  }

  getBillingDetails() async {
    await Provider.of<ProfileProvider>(context, listen: false)
        .getBillingDetail()
        .then((value) {
      if (value != null) {
        _addressLine1Controller.text = value.addressLine1 ?? "";
        _addressLine2Controller.text = value.addressLine2 ?? "";
        _zipcodeController.text = value.postCode ?? "";
        if (value.country != null) {
          countryData = value.country;
        }
        if (value.state != null) {
          stateData = value.state;
        }
        if (value.city != null) {
          cityData = value.city;
        }
      }
    });
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
                    "Update Billing Details",
                    style: poppinsSemiBold.copyWith(
                        fontSize: 12, color: Colors.black54),
                  )
                ],
              )
            ],
          )),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          _addressLine2Controller.text = profile.userInfoModel?.fName ?? "";

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  children: [
                    const SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: ColorResources.getIconBg(context),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                              topRight: Radius.circular(
                                  Dimensions.MARGIN_SIZE_DEFAULT),
                            )),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            // for Address line 1
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          getTranslated(
                                              'ADDRESS_LINE_1', context),
                                          style: customTextFieldTitle),
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType.name,
                                    focusNode: _addressLine1,
                                    nextNode: _addressLine2,
                                    hintText: profile.userInfoModel?.fName ??
                                        getTranslated(
                                            'hint_address_line1', context),
                                    controller: _addressLine1Controller,
                                  ),
                                ],
                              ),
                            ),

                            // for Address line 2
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          getTranslated(
                                              'ADDRESS_LINE_2', context),
                                          style: customTextFieldTitle),
                                    ],
                                  ),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType.name,
                                    focusNode: _addressLine2,
                                    //nextNode: _addressLine2,
                                    hintText: profile.userInfoModel?.fName ??
                                        getTranslated(
                                            'hint_address_line2', context),
                                    controller: _addressLine2Controller,
                                  ),
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
                                          getTranslated('COUNTRY', context),
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
                                            offset: const Offset(0, 1))
                                        // changes position of shadow
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
                                            countryData!.name!,
                                            style: poppinsRegular.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_DEFAULT,
                                                color: ColorResources
                                                    .BLACK),
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
                                      builder: (_) => const CountryListScreen()));
                              if (result != null) {
                                setState(() {
                                  countryData = result;
                                });
                              }
                            }),

                            // for state or province
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
                                          getTranslated(
                                              'STATE_OR_PROVINCE', context),
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
                                            offset: const Offset(0, 1))
                                        // changes position of shadow
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
                                            stateData!.name!,
                                            style: poppinsRegular.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_DEFAULT,
                                                color: ColorResources
                                                    .BLACK),
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
                                      builder: (_) => StateListScreen(
                                          countryId: countryData?.id)));
                              if (result != null) {
                                setState(() {
                                  stateData = result;
                                });
                              }
                            }),

                            // for city
                            Container(
                              margin: EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          getTranslated('CITY', context),
                                          style: customTextFieldTitle,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
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
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            cityData!.name!,
                                            style: poppinsRegular.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_DEFAULT,
                                                color: ColorResources
                                                    .BLACK),
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
                                      builder: (_) => CityListScreen(stateId: stateData?.id,)));
                              if (result != null) {
                                setState(() {
                                  cityData = result;
                                });
                              }
                            }),

                            // for zip
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          getTranslated(
                                              'ZIP_OR_POSTAL_CODE', context),
                                          style: customTextFieldTitle),
                                    ],
                                  ),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType.name,
                                    focusNode: _zipcode,
                                    hintText: profile.userInfoModel?.fName ??
                                        getTranslated(
                                            'hint_zip_or_postal_code', context),
                                    controller: _zipcodeController,
                                  ),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
