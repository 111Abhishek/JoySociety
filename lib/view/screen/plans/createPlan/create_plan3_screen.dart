
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/create_plan_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/provider/plan_provider.dart';
import 'package:joy_society/utill/extensions/string_extensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/app_bar.dart';
import 'package:joy_society/view/basewidget/custom_decoration.dart';
import 'package:joy_society/view/basewidget/show_custom_snakbar.dart';
import 'package:joy_society/view/screen/workshop/createWorkshop2/create_workshop2_screen.dart';
import 'package:provider/provider.dart';
import '../../../../localization/language_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../basewidget/button/custom_button.dart';
import '../../../basewidget/textfield/custom_textfield.dart';

class CreatePlan3Screen extends StatefulWidget {

  const CreatePlan3Screen({Key? key})
      : super(key: key);

  @override
  State<CreatePlan3Screen> createState() => _CreatePlan3ScreenState();
}

class _CreatePlan3ScreenState extends State<CreatePlan3Screen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  String paymentCycleValue = 'Weekly';
  var paymentCycleList = ['Weekly', 'Monthly', 'Quarterly', 'Half Yearly', 'Yearly', 'Custom'];
  bool isCustomeDateVisible = false;

  final FocusNode _priceFocus = FocusNode();
  final FocusNode _discountFocus = FocusNode();
  final FocusNode _offerPriceFocus = FocusNode();
  final FocusNode _daysFocus = FocusNode();

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _offerPriceController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  void _updateGoalReflection() async {

    Provider.of<PlanProvider>(context, listen: false)
        .createPlan(updateForumCallback);

  }

  updateForumCallback(
      bool isStatusSuccess,
      CreatePlanModel? topicModel,
      ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Plan Created successfully'),
          backgroundColor: Colors.green));
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
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
            errorDescription = (titleError![0]! as String).replaceAll("This field", "Title");
          } else if (taglineError != null && taglineError.length > 0) {
            errorDescription = (taglineError![0]! as String).replaceAll("This field", "Tagline");
          } else if (descriptionError != null && descriptionError.length > 0) {
            errorDescription = (descriptionError![0]! as String).replaceAll("This field", "Description");
          } else if (privacyError != null && privacyError.length > 0) {
            errorDescription = (privacyError![0]! as String).replaceAll("This field", "Privacy");
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<PlanProvider>(
        builder: (context, plan, child) {

          //  _emailController.text = profile.userPhoneEmailModel?.email ?? "";
          return Scaffold(
              appBar:
                  appBar(context, getTranslated('CREATE_A_NEW_PLAN', context)),
              body: SingleChildScrollView(
                  child: Container(
                      margin: EdgeInsets.all(Dimensions.MARGIN_SIZE_DEFAULT),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Preview Your New Plan',
                                style: poppinsBold.copyWith(
                                    fontSize:
                                        Dimensions.FONT_SIZE_EXTRA_LARGE)),
                            Text(
                                'Plan Card Preview',
                                style: customTextFieldTitle),

                            SizedBox(height: Dimensions.MARGIN_SIZE_SMALL,),

                            Text(
                                'Below is a preview of what your members will see when they have the option to purchase this plan.',
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),

                            Container(
                              decoration: baseWhiteBoxDecoration(context),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: ColorResources.DARK_GREEN_COLOR,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                          Dimensions.MARGIN_SIZE_DEFAULT),
                                        topRight: Radius.circular(
                                            Dimensions.MARGIN_SIZE_DEFAULT),),
                                    ),
                                    child: Column(
                                      children: [
                                        Image.asset(Images.logo_with_name_image,
                                            height: 50, width: 50),
                                        SizedBox(height: Dimensions.MARGIN_SIZE_LARGE),
                                        Text(
                                            'Workshop',
                                            style: customTextFieldTitle.copyWith(fontSize: 22, color: Colors.white)),
                                      ],
                                    ).paddingSymmetric(vertical: 20),
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'Price',
                                                style: poppinsRegular.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                                    color: ColorResources.TEXT_BLACK_COLOR)),

                                            Text(
                                                '\$${plan.createPlanModel?.display_price}',
                                                style: poppinsRegular.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                                    color: ColorResources.TEXT_BLACK_COLOR)),
                                          ],
                                        ),
                                        Divider(color: ColorResources.DIVIDER_COLOR),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'Discount',
                                                style: poppinsRegular.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                                    color: ColorResources.TEXT_BLACK_COLOR)),

                                            Text(
                                                '${plan.createPlanModel?.discount}%',
                                                style: poppinsRegular.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                                    color: ColorResources.TEXT_BLACK_COLOR)),
                                          ],
                                        ),
                                        Divider(color: ColorResources.DIVIDER_COLOR),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                'Offer Price',
                                                style: poppinsRegular.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                                    color: ColorResources.TEXT_BLACK_COLOR)),

                                            Text(
                                                '\$${plan.createPlanModel?.offer_price}',
                                                style: poppinsRegular.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                                    color: ColorResources.TEXT_BLACK_COLOR)),
                                          ],
                                        ),
                                        SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                '\$${plan.createPlanModel?.offer_price} USD',
                                                style: poppinsBold.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,
                                                    color: ColorResources.TEXT_BLACK_COLOR)),

                                            Text(
                                                '/${plan.createPlanModel?.payment_type}',
                                                style: poppinsRegular.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                    color: ColorResources.TEXT_BLACK_COLOR)),
                                          ],
                                        ),
                                        SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                                        CustomButton(
                                            onTap: () {
                                              _updateGoalReflection();
                                            },
                                            buttonText: 'SUBSCRIBE'),
                                      ],
                                    ),
                                  ).paddingAll(20)
                                ],
                              ),
                            ).marginSymmetric(horizontal: 24),

                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),

                            Text(
                                'Create Your Plan',
                                style: customTextFieldTitle.copyWith(fontSize: 16)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            Text(
                                'Finish Plan Creation',
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            Text(
                                'Once you’re happy with the preview above, it’s time to create your new plan! As a next step, you will be able to choose if you want this plan to be visible, which means that members can see and purchase the plan instantly on Web. Apple has a separate approval process for any plans you want to also make available on iOS, and this process may take some extra time.',
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),

                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE),

                            Container(
                              decoration: baseWhiteBoxDecoration(context),
                              child: Text(
                                  'Remember, you can’t edit Payments or Network Access once the plan is created.',
                                  style: poppinsRegular.copyWith(
                                      fontSize: Dimensions.FONT_SIZE_SMALL,
                                      color: ColorResources.RED)).marginSymmetric(horizontal: 16, vertical: 12),
                            ),

                            SizedBox(
                              height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                            ),
                            CustomButton(
                                onTap: () {
                                  _updateGoalReflection();
                                },
                                buttonText: 'Create your plan'),
                          ]))));
        },
      ),
    );
  }
}
