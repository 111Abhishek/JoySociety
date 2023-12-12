import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';
import 'package:joy_society/view/basewidget/show_custom_snakbar.dart';
import 'package:joy_society/view/basewidget/two_text_row_widget.dart';
import 'package:joy_society/view/screen/addBillingDetail/add_billing_detail_screen.dart';
import 'package:joy_society/view/screen/cardDetails/card_details_screen.dart';
import 'package:provider/provider.dart';

class BillingDetailsScreen extends StatefulWidget {
  @override
  _BillingDetailsScreenState createState() => _BillingDetailsScreenState();
}

class _BillingDetailsScreenState extends State<BillingDetailsScreen> {
  bool _isBillingDetailEmpty = true;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
  }

  void _onEditBillingDetailClick() async {
    showCustomSnackBar('Edit Billing Clicked', context, isError: false);
  }

  void _onAddBillingDetailClick() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => AddBillingDetailScreen()));
  }

  void _onAddCreditCardDetailClick() async {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CardDetails()));
  }

  void _onEditCreditCardDetailClick() async {
    showCustomSnackBar('Edit Credit Clicked', context, isError: false);
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
                  Text("Billing Details",
                      style: poppinsBold.copyWith(
                          fontSize: 20, color: Colors.black)),
                ],
              )
            ],
          )),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          return Stack(clipBehavior: Clip.none, children: [
            Visibility(
              visible: !_isBillingDetailEmpty,
              child: Container(
                padding: const EdgeInsets.only(top: 120, left: 16, right: 16),
                child: Column(children: [
                  Column(children: [
                    const SizedBox(width: 10),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getTranslated('BILLING_ADDRESS', context),
                                    style: poppinsBold.copyWith(
                                        fontSize: 16, color: Colors.black),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text('PO BOX 360662, Columbus, Ohio 43236',
                                    style: poppinsRegular.copyWith(
                                        fontSize: 12,
                                        color: ColorResources
                                            .TEXT_FORM_TEXT_COLOR),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: Dimensions.MARGIN_SIZE_DEFAULT,
                          ),
                          ClipOval(
                            child: Material(
                              color: ColorResources.DARK_GREEN_COLOR,
                              // Button color
                              child: InkWell(
                                splashColor: ColorResources.DARK_GREEN_COLOR,
                                // Splash color
                                onTap: () {
                                  _onEditBillingDetailClick();
                                },
                                child: SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Icon(
                                      Icons.add,
                                      color: ColorResources.WHITE,
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getTranslated('CREDIT_CARD', context),
                                    style: poppinsBold.copyWith(
                                        fontSize: 16, color: Colors.black),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                TwoTextRowWidget(
                                    title:
                                        getTranslated('NAME_ON_CARD', context),
                                    value: 'Elizabath Joy'),
                                Divider(color: ColorResources.DIVIDER_COLOR),
                                TwoTextRowWidget(
                                    title:
                                        getTranslated('CARD_NUMBER', context),
                                    value: 'xxxx xxxx xxxx-2117'),
                                Divider(color: ColorResources.DIVIDER_COLOR),
                                TwoTextRowWidget(
                                    title: getTranslated('CVC', context),
                                    value: 'xxx'),
                                Divider(color: ColorResources.DIVIDER_COLOR),
                                TwoTextRowWidget(
                                    title: getTranslated('EXP_DATE', context),
                                    value: '4/2024'),
                                Divider(color: ColorResources.DIVIDER_COLOR),
                                TwoTextRowWidget(
                                    title: getTranslated(
                                        'ZIP_OR_POSTAL_CODE', context),
                                    value: '422306'),
                                Divider(color: ColorResources.DIVIDER_COLOR),
                                TwoTextRowWidget(
                                    title: getTranslated('COUNTRY', context),
                                    value: 'United States'),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          ClipOval(
                            child: Material(
                              color: ColorResources.DARK_GREEN_COLOR,
                              // Button color
                              child: InkWell(
                                splashColor: ColorResources.DARK_GREEN_COLOR,
                                // Splash color
                                onTap: () {
                                  _onEditCreditCardDetailClick();
                                },
                                child: SizedBox(
                                    width: 36,
                                    height: 36,
                                    child: Icon(
                                      Icons.add,
                                      color: ColorResources.WHITE,
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                ]),
              ),
            ),
            Visibility(
                visible: _isBillingDetailEmpty,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.MARGIN_SIZE_LARGE,
                          vertical: Dimensions.MARGIN_SIZE_SMALL),
                      child: !Provider.of<ProfileProvider>(context).isLoading
                          ? CustomButton(
                              onTap: _onAddBillingDetailClick,
                              buttonText:
                                  getTranslated('ADD_BILLING_ADDRESS', context))
                          : Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor))),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.MARGIN_SIZE_LARGE,
                          vertical: Dimensions.MARGIN_SIZE_SMALL),
                      child: !Provider.of<ProfileProvider>(context).isLoading
                          ? CustomButtonSecondary(
                              onTap: _onAddCreditCardDetailClick,
                              buttonText:
                                  getTranslated('ADD_CREDIT_CARD', context))
                          : Center(
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor))),
                    ),
                  ],
                )),
          ]);
        },
      ),
    );
  }
}
