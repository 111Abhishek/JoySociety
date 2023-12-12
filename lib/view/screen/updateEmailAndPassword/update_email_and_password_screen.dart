import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/user_phone_email_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/textfield/custom_password_textfield.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/screen/auth/widget/code_picker_widget.dart';
import 'package:provider/provider.dart';

class UpdateEmailAndPasswordScreen extends StatefulWidget {
  @override
  _UpdateEmailAndPasswordState createState() => _UpdateEmailAndPasswordState();
}

class _UpdateEmailAndPasswordState extends State<UpdateEmailAndPasswordScreen> {
  String _countryDialCode = "+880";

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _currentPasswordFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  _updateUserAccount() async {
    String _email = _emailController.text.trim();
    String _phone = _phoneController.text.trim();
    String _currentPassword = _currentPasswordController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();

    if (_email.isEmpty &&
        _phone.isEmpty &&
        (_currentPasswordController.text.isEmpty &&
            _passwordController.text.isEmpty &&
            _confirmPasswordController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Change something to update'),
          backgroundColor: ColorResources.RED));
    } else {
      if (_currentPasswordController.text.isEmpty &&
          _passwordController.text.isEmpty &&
          _confirmPasswordController.text.isEmpty) {
        // update phone and email
        _updateUserDetails();
      } else if ((_currentPassword.isEmpty || _currentPassword.length < 6)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Current Password should be at least 6 character'),
            backgroundColor: ColorResources.RED));
      } else if ((_password.isEmpty || _password.length < 6) ||
          (_confirmPassword.isEmpty || _confirmPassword.length < 6)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Password should be at least 6 character'),
            backgroundColor: ColorResources.RED));
      } else if (_password != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(getTranslated(
                'NEW_AND_CONFIRM_PASSWORD_DID_NOT_MATCH', context)),
            backgroundColor: ColorResources.RED));
      } else {
        // update all values
        _updateUserDetails();
      }
    }
  }

  UserPhoneEmailModel getUserDetails() {
    UserPhoneEmailModel userPhoneEmailModel = UserPhoneEmailModel();
    userPhoneEmailModel.email = _emailController.text.trim();
    userPhoneEmailModel.countryCode = _countryDialCode;
    userPhoneEmailModel.phoneNumber = _phoneController.text.trim();
    userPhoneEmailModel.currentPassword =
        _currentPasswordController.text.trim();
    userPhoneEmailModel.newPassword = _confirmPasswordController.text.trim();
    return userPhoneEmailModel;
  }

  _updateUserDetails() async {
    await Provider.of<ProfileProvider>(context, listen: false)
        .updateUserCredentials(getUserDetails(), updateForumCallback);
  }

  updateForumCallback(
      bool isStatusSuccess,
      UserPhoneEmailModel? userPhoneEmailModel,
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
          dynamic emailError = errorResponse?.errorJson["email"];
          dynamic countryCodeError = errorResponse?.errorJson["country_code"];
          dynamic phoneNumberError = errorResponse?.errorJson["phone_number"];

          if (emailError != null && emailError.length > 0) {
            errorDescription = emailError![0]!;
          } else if (countryCodeError != null && countryCodeError.length > 0) {
            errorDescription = countryCodeError![0]!;
          } else if (phoneNumberError != null && phoneNumberError.length > 0) {
            errorDescription = phoneNumberError![0]!;
          } else {
            errorDescription = 'Technical error, Please try again later!';
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorDescription!), backgroundColor: Colors.red));
    }
  }

  getEmailAndPasswordDetails() async {
    await Provider.of<ProfileProvider>(context, listen: false)
        .getUserPhoneAndEmail(userPhoneAndEmailCallback);
  }

  userPhoneAndEmailCallback(
      bool isStatusSuccess,
      UserPhoneEmailModel? userPhoneEmailModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      if (userPhoneEmailModel != null) {
        _emailController.text = userPhoneEmailModel.email ?? "";
        _phoneController.text = userPhoneEmailModel.phoneNumber ?? "";
        String countryCode = userPhoneEmailModel.countryCode ??
            AppConstants.DEFAULT_COUNTRY_CODE;
        if (countryCode.isEmpty) {
          countryCode = AppConstants.DEFAULT_COUNTRY_CODE;
        }
        setState(() {
          _countryDialCode = countryCode;
        });
      }
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        if (errorDescription == null) {
          dynamic emailError = errorResponse?.errorJson["email"];
          dynamic countryCodeError = errorResponse?.errorJson["country_code"];
          dynamic phoneNumberError = errorResponse?.errorJson["phone_number"];

          if (emailError != null && emailError.length > 0) {
            errorDescription = emailError![0]!;
          } else if (countryCodeError != null && countryCodeError.length > 0) {
            errorDescription = countryCodeError![0]!;
          } else if (phoneNumberError != null && phoneNumberError.length > 0) {
            errorDescription = phoneNumberError![0]!;
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
    _countryDialCode = '+91';
    getEmailAndPasswordDetails();
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
                    getTranslated("UPDATE_EMAIL_AND_PASSWORD", context),
                    style: poppinsSemiBold.copyWith(
                        fontSize: 12, color: Colors.black54),
                  )
                ],
              )
            ],
          )),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          _emailController.text = profile.userPhoneEmailModel?.email ?? "";

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 12),
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
                            // for Email
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Email",
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomTextField(
                                    textInputType: TextInputType.emailAddress,
                                    focusNode: _emailFocus,
                                    nextNode: _currentPasswordFocus,
                                    hintText:
                                        getTranslated('hint_email', context),
                                    controller: _emailController,
                                  ),
                                ],
                              ),
                            ),

                            // for Phone No
                            Container(
                              margin: const EdgeInsets.only(
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT,
                                  top: Dimensions.MARGIN_SIZE_SMALL),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Phone number",
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  Row(children: [
                                    Container(
                                      height: 55,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).highlightColor,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: Offset(0, 1))
                                          // changes position of shadow
                                        ],
                                      ),
                                      child: CodePickerWidget(
                                        onChanged: (CountryCode countryCode) {
                                          _countryDialCode =
                                              countryCode.dialCode!;
                                        },
                                        initialSelection: _countryDialCode,
                                        favorite: [_countryDialCode],
                                        showDropDownButton: true,
                                        padding: EdgeInsets.zero,
                                        showFlagMain: true,
                                        textStyle: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline1
                                                ?.color),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        child: CustomTextField(
                                      hintText: getTranslated(
                                          'ENTER_MOBILE_NUMBER', context),
                                      controller: _phoneController,
                                      focusNode: _phoneFocus,
                                      nextNode: _passwordFocus,
                                      isPhoneNumber: true,
                                      textInputAction: TextInputAction.next,
                                      textInputType: TextInputType.phone,
                                    )),
                                  ]),
                                ],
                              ),
                            ),

                            // for Current Password
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      getTranslated(
                                          'CURRENT_PASSWORD', context),
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomPasswordTextField(
                                    controller: _currentPasswordController,
                                    focusNode: _currentPasswordFocus,
                                    nextNode: _passwordFocus,
                                    textInputAction: TextInputAction.next,
                                    hintTxt: getTranslated(
                                        'hint_current_password', context),
                                  ),
                                ],
                              ),
                            ),

                            // for Password
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getTranslated('NEW_PASSWORD', context),
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomPasswordTextField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    nextNode: _confirmPasswordFocus,
                                    textInputAction: TextInputAction.next,
                                    hintTxt: getTranslated(
                                        'hint_new_password', context),
                                  ),
                                ],
                              ),
                            ),

                            // for  re-enter Password
                            Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_DEFAULT,
                                  left: Dimensions.MARGIN_SIZE_DEFAULT,
                                  right: Dimensions.MARGIN_SIZE_DEFAULT),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      getTranslated(
                                          'CONFIRM_NEW_PASSWORD', context),
                                      style: customTextFieldTitle),
                                  const SizedBox(
                                      height: Dimensions.MARGIN_SIZE_SMALL),
                                  CustomPasswordTextField(
                                    controller: _confirmPasswordController,
                                    focusNode: _confirmPasswordFocus,
                                    textInputAction: TextInputAction.done,
                                    hintTxt: getTranslated(
                                        'hint_confirm_password', context),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16,),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: Dimensions.MARGIN_SIZE_DEFAULT,
                                  vertical: Dimensions.MARGIN_SIZE_LARGE),
                              child: !Provider.of<ProfileProvider>(context)
                                      .isLoading
                                  ? CustomButton(
                                      onTap: _updateUserAccount,
                                      buttonText:
                                          getTranslated('SAVE', context))
                                  : Center(
                                      child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Theme.of(context).primaryColor))),
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
