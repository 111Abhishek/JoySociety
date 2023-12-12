import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/view/screen/cardDetails/formatters/card_formatter.dart';
import 'package:joy_society/view/screen/cardDetails/formatters/expiry_date_formatter.dart';
import 'package:joy_society/view/screen/cardDetails/formatters/no_space_formatter.dart';
import 'package:provider/provider.dart';

import '../../../localization/language_constants.dart';
import '../../../provider/profile_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../../utill/dimensions.dart';
import '../../../utill/images.dart';
import '../../basewidget/button/custom_button.dart';
import '../../basewidget/button/custom_button_secondary.dart';
import '../../basewidget/show_custom_snakbar.dart';
import '../../basewidget/textfield/custom_textfield.dart';

class CardDetails extends StatefulWidget {
  @override
  _CardDetailScreenState createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetails> {
  final String cardSeparator = ' ';
  final int totalCardDigits = 16;
  final int cardSeparatorSpaces = 3;

  final FocusNode _nameCardFocus = FocusNode();
  final FocusNode _cardNumberFocus = FocusNode();
  final FocusNode _cvcFocus = FocusNode();
  final FocusNode _dateFocus = FocusNode();

  final TextEditingController _nameCardController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  File? file;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  void _onAddNewCardClick() async {
    showCustomSnackBar('Add new card Clicked', context, isError: false);
  }

  _saveCardDetail() async {
    String _cardName = _nameCardController.text.trim();
    String _cardNumber = _cardNumberController.text.trim();
    String _cardCvc = _cvcController.text.trim();
    String _expireDate = _dateController.text.trim();

    if (_cardName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated('NAME_FIELD_MUST_BE_REQUIRED', context)),
          backgroundColor: ColorResources.RED));
    } else if (_cardNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              getTranslated('CARD_NUMBER_FIELD_MUST_BE_REQUIRED', context)),
          backgroundColor: ColorResources.RED));
    } else if (_cardCvc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(getTranslated('CARD_CVC_FIELD_MUST_BE_REQUIRED', context)),
          backgroundColor: ColorResources.RED));
    } else if (_expireDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('CARD_EXP_DATA_FIELD_MUST_BE_REQUIRED'),
          backgroundColor: ColorResources.RED));
    }
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
                    "Update Card Details",
                    style: poppinsSemiBold.copyWith(
                        fontSize: 12, color: Colors.black54),
                  )
                ],
              )
            ],
          )),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          //_phoneController.text = profile.userInfoModel?.phone ?? "";
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    const SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                    Expanded(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          // for name
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(getTranslated('NAME_ON_CARD', context),
                                        style: customTextFieldTitle),
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                                CustomTextField(
                                  textInputType: TextInputType.name,
                                  focusNode: _nameCardFocus,
                                  nextNode: _cardNumberFocus,
                                  hintText:
                                      getTranslated('NAME_ON_CARD', context),
                                  controller: _nameCardController,
                                ),
                              ],
                            ),
                          ),
                          //for card number
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(getTranslated('CARD_NUMBER', context),
                                        style: customTextFieldTitle),
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                                CustomTextField(
                                  textInputType: TextInputType.number,
                                  focusNode: _cardNumberFocus,
                                  nextNode: _cvcFocus,
                                  hintText: "xxxx xxxx xxxx xxxx",
                                  inputFormatters: [
                                    CardFormatter(separator: cardSeparator),
                                    LengthLimitingTextInputFormatter(
                                        totalCardDigits +
                                            cardSeparator.length *
                                                cardSeparatorSpaces)
                                  ],
                                  controller: _cardNumberController,
                                ),
                              ],
                            ),
                          ),

                          // for cvc
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(getTranslated('CVC', context),
                                        style: customTextFieldTitle),
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                                CustomTextField(
                                  textInputType: TextInputType.number,
                                  focusNode: _cvcFocus,
                                  nextNode: _dateFocus,
                                  inputFormatters: [LengthLimitingTextInputFormatter(3)],
                                  hintText: getTranslated('CVC', context),
                                  controller: _cvcController,
                                ),
                              ],
                            ),
                          ),

                          //for date
                          Container(
                            margin: const EdgeInsets.only(
                                top: Dimensions.MARGIN_SIZE_DEFAULT,
                                left: Dimensions.MARGIN_SIZE_DEFAULT,
                                right: Dimensions.MARGIN_SIZE_DEFAULT),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(getTranslated('EXP_DATE', context),
                                        style: customTextFieldTitle),
                                  ],
                                ),
                                const SizedBox(
                                    height: Dimensions.MARGIN_SIZE_SMALL),
                                CustomTextField(
                                  textInputType: TextInputType.number,
                                  focusNode: _dateFocus,
                                  nextNode: _dateFocus,
                                  hintText: 'MM/YY',
                                  inputFormatters: [NoSpaceFormatter(), ExpiryDateFormatter()],
                                  controller: _dateController,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.MARGIN_SIZE_LARGE,
                                vertical: Dimensions.MARGIN_SIZE_SMALL),
                            child: !Provider.of<ProfileProvider>(context)
                                    .isLoading
                                ? CustomButton(
                                    onTap: _saveCardDetail,
                                    buttonText: getTranslated('SAVE', context))
                                : Center(
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Theme.of(context).primaryColor))),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: Dimensions.MARGIN_SIZE_LARGE,
                                vertical: Dimensions.MARGIN_SIZE_SMALL),
                            child: !Provider.of<ProfileProvider>(context)
                                    .isLoading
                                ? CustomButtonSecondary(
                                    onTap: _onAddNewCardClick,
                                    buttonText:
                                        getTranslated('ADD_NEW_CARD', context))
                                : Center(
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                                Color>(
                                            Theme.of(context).primaryColor))),
                          )
                        ],
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
