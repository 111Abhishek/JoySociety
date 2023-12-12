
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joy_society/data/model/response/create_plan_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/provider/plan_provider.dart';
import 'package:joy_society/utill/extensions/string_extensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/app_bar.dart';
import 'package:joy_society/view/basewidget/custom_decoration.dart';
import 'package:joy_society/view/basewidget/show_custom_snakbar.dart';
import 'package:joy_society/view/screen/plans/createPlan/create_plan3_screen.dart';
import 'package:joy_society/view/screen/workshop/createWorkshop2/create_workshop2_screen.dart';
import 'package:provider/provider.dart';
import '../../../../localization/language_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../basewidget/button/custom_button.dart';
import '../../../basewidget/textfield/custom_textfield.dart';

class CreatePlan2Screen extends StatefulWidget {

  const CreatePlan2Screen({Key? key})
      : super(key: key);

  @override
  State<CreatePlan2Screen> createState() => _CreatePlan2ScreenState();
}

class _CreatePlan2ScreenState extends State<CreatePlan2Screen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  String paymentCycleValue = 'Weekly';
  var paymentCycleList = ['Weekly', 'Monthly', 'Quarterly', 'Half Yearly', 'Yearly', 'Custom'];
  bool isCustomeDateVisible = false;
  int offerPrice = 0;

  final FocusNode _priceFocus = FocusNode();
  final FocusNode _discountFocus = FocusNode();
  final FocusNode _daysFocus = FocusNode();

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  void _updateGoalReflection() async {
    if (_priceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Price cannot be Empty"),
          backgroundColor: Colors.red));
      return;
    } else if (_discountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Discount cannot be Empty"),
          backgroundColor: Colors.red));
      return;
    } /*else if (_offerPriceController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Offer Price cannot be Empty"),
              backgroundColor: Colors.red));
      return;
    }*/

    if(isCustomeDateVisible) {
      if (_daysController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No. of Days cannot be Empty"),
            backgroundColor: Colors.red));
        return;
      }
    }

    var planModel = Provider.of<PlanProvider>(context, listen: false).createPlanModel;

    int? days = null;
    if(isCustomeDateVisible){
      days = _daysController.text.trim().toInt();
    }

    CreatePlanModel requestModel = CreatePlanModel(
        name : planModel?.name ?? "",
        internal_note : planModel?.internal_note ?? "",
        sales_pitch : planModel?.sales_pitch ?? "",
        description : planModel?.description ?? "",
        benefits : planModel?.benefits ?? "",
        image : planModel?.image ?? "",
        display_price : _priceController.text.trim().toInt(),
        discount : _discountController.text.trim().toInt(),
        offer_price : offerPrice,
        payment_type: paymentCycleValue.toUpperCase(),
        days: days,
        is_active: true
        );

    Provider.of<PlanProvider>(context, listen: false)
        .updateCreatePlan1(requestModel, null);

    Navigator.push(context, MaterialPageRoute(builder: (_) => CreatePlan3Screen()));

  }

  void calcualteOfferPrice(String planPrice, String discountPercentage) {
    if(planPrice.isEmpty){
      setState(() {
        offerPrice = 0;
      });
      return ;
    }
    if(discountPercentage.isEmpty){
      setState(() {
        offerPrice = 0;
      });
      return ;
    }
    setState(() {
      int discount = ((planPrice.toInt()*discountPercentage.toInt())/100).toInt();
      offerPrice = planPrice.toInt() - discount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<GoalProvider>(
        builder: (context, goal, child) {

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
                            Text('Payments Settings',
                                style: poppinsBold.copyWith(
                                    fontSize:
                                        Dimensions.FONT_SIZE_EXTRA_LARGE)),
                            Text(
                                'Is payment required for a existing member to get on this plan? If not, please change the pricing type to “free”.',
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),

                            Text(
                                'Payments cannot be changed once the plan is created.',
                                style: customTextFieldTitle),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                            Text(
                                'Pricing Type',
                                style: customTextFieldTitle.copyWith(fontSize: 16)),
                            Text(
                                'Choose how you want to charge for this new plan.',
                                style: poppinsRegular.copyWith(
                                    fontSize: Dimensions.FONT_SIZE_SMALL,
                                    color: ColorResources.TEXT_BLACK_COLOR)),
                            SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                            CustomTextField(
                              controller: _priceController,
                              focusNode: _priceFocus,
                              nextNode: _discountFocus,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.number,
                              isPhoneNumber: true,
                              hintText: 'Price',
                              onChanged: (v) => {
                                calcualteOfferPrice(v, _discountController.text)
                                },
                            ),


                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),
                            CustomTextField(
                              controller: _discountController,
                              focusNode: _discountFocus,
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.number,
                              isPhoneNumber: true,
                              hintText: 'Discount',
                              maxLine: 1,
                              onChanged: (v) => {
                                calcualteOfferPrice(_priceController.text, v)
                              },
                            ),

                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),

                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: baseWhiteBoxDecoration(context),
                              child: Text(offerPrice.toString(), style: poppinsRegular.copyWith(
                                  fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                  color: ColorResources.TEXT_BLACK_COLOR))
                                  .paddingSymmetric(horizontal: 14, vertical: 15),
                            ),

                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),

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
                                    value: paymentCycleValue,
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down_outlined),
                                    items: paymentCycleList.map((String items) {
                                      return DropdownMenuItem(
                                          value: items, child: Text(items));
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        paymentCycleValue = newValue!;
                                        if(paymentCycleValue == 'Custom') {
                                          isCustomeDateVisible = true;
                                        } else {
                                          isCustomeDateVisible = false;
                                        }
                                      });
                                    }),
                              ),
                            ),

                            SizedBox(height: Dimensions.MARGIN_SIZE_LARGE,),

                            CustomTextField(
                              controller: _daysController,
                              focusNode: _daysFocus,
                              textInputAction: TextInputAction.done,
                              maxLine: 1,
                              textInputType: TextInputType.number,
                              isPhoneNumber: true,
                              hintText: 'Enter no. of Days',
                            ).visible(isCustomeDateVisible),

                            SizedBox(
                              height: Dimensions.MARGIN_SIZE_EXTRA_LARGE,
                            ),
                            CustomButton(
                                onTap: () {
                                  _updateGoalReflection();
                                },
                                buttonText: 'Next'),
                          ]))));
        },
      ),
    );
  }
}
