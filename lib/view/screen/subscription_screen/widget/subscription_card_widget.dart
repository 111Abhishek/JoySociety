import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as sp;
import 'package:get/get.dart';
import 'package:joy_society/data/model/response/subscription_model.dart';
import 'package:joy_society/provider/subscription_provider.dart';
import 'package:joy_society/view/basewidget/web_view_screen.dart';
import 'package:joy_society/view/screen/auth/widget/sign_in_widget.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/base/error_response.dart';
import '../../../../data/model/response/stripe_url_response.dart';
import '../../../../utill/app_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../basewidget/button/custom_button_secondary.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../../auth/auth_screen.dart';
import '../payment_gateway/stripe_paymnet.dart';

class SubscriptionCardWidget extends StatefulWidget {
  final SubsOption? subscriptionObj;
  const SubscriptionCardWidget({super.key, this.subscriptionObj});

  @override
  State<SubscriptionCardWidget> createState() => _SubscriptionCardWidgetState();
}

class _SubscriptionCardWidgetState extends State<SubscriptionCardWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: ColorResources.GREY,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            //  alignment: Alignment.center,
            // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: ColorResources.DARK_GREEN_COLOR),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*Text(widget.subscriptionObj!.paymentType,
                        style: poppinsMedium.copyWith(
                            color: ColorResources.WHITE,
                            fontSize: Dimensions.FONT_SIZE_LARGE))
                    .paddingOnly(
                  top: 15,
                  left: 10,
                ),
                Text(widget.subscriptionObj!.salesPitch,
                        style: poppinsMedium.copyWith(
                            color: ColorResources.WHITE,
                            fontSize: Dimensions.FONT_SIZE_DEFAULT))
                    .paddingOnly(
                  top: 5,
                  left: 10,
                  bottom: 15,
                ),*/
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* Text(
                  " \$${widget.subscriptionObj!.displayPrice}",
                  style: poppinsBold.copyWith(
                      color: ColorResources.DARK_GREEN_COLOR,
                      fontSize: Dimensions.FONT_SIZE_OVER_LARGE),
                ),
                Text(
                  "/ ${widget.subscriptionObj!.paymentType}",
                  style: poppinsRegular.copyWith(
                      color: ColorResources.DARK_GREEN_COLOR,
                      fontSize: Dimensions.FONT_SIZE_LARGE),
                ),*/
              ],
            ),
          ).paddingAll(10),
          CustomButtonSecondary(
            bgColor: ColorResources.DARK_GREEN_COLOR,
            textColor: ColorResources.WHITE,
            isCapital: false,
            buttonText: "Coming Soon ",
            //onTap: () => _buySubscription(widget.subscriptionObj!.id),

            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //     content: Text(
            //         "${subscriptionObj!.displayPrice} Button Pressed",
            //         style: TextStyle(color: Colors.white)),
            //     backgroundColor: Colors.red));
          ).paddingAll(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Internal Notes:",
              //   style: poppinsBold.copyWith(
              //       color: ColorResources.BLACK,
              //       fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
              // ),
              const SizedBox(height: 3),
              /*Text(
                widget.subscriptionObj!.internalNote,
                style: poppinsRegular.copyWith(
                    color: ColorResources.BLACK,
                    fontSize: Dimensions.FONT_SIZE_LARGE),
              ),*/
              const Divider(
                thickness: 3,
                color: ColorResources.GREY,
              ),
              // Text(
              //   "Benifits:",
              //   style: poppinsBold.copyWith(
              //       color: ColorResources.BLACK,
              //       fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
              // ),
              const SizedBox(height: 3),
              //  Text(
              //  " \u2022 ${widget.subscriptionObj!.benefits}",
              //  style: poppinsRegular.copyWith(
              //   color: ColorResources.BLACK,
              //  fontSize: Dimensions.FONT_SIZE_LARGE),
              // ),
              // ListView.builder(
              //   shrinkWrap: true,
              //   primary: false,
              //   itemCount: subscriptionObj!.benefits,
              //   itemBuilder: (context, index) {
              //     return Text(
              //     "\u2022 " + subscriptionObj!.benifitsDesp![index],
              //       style: poppinsRegular.copyWith(
              //           color: ColorResources.BLACK,
              //           fontSize: Dimensions.FONT_SIZE_LARGE),
              //     );
              //   },
              // ),
              const Divider(
                thickness: 3,
                color: ColorResources.GREY,
              ),
              // Text(
              //   "Description:",
              //   style: poppinsBold.copyWith(
              //       color: ColorResources.BLACK,
              //       fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
              // ),
              const SizedBox(height: 3),
              /* Text(
                widget.subscriptionObj!.description,
                style: poppinsRegular.copyWith(
                    color: ColorResources.BLACK,
                    fontSize: Dimensions.FONT_SIZE_LARGE),
              ),*/
            ],
          ).paddingAll(10),
        ],
      ),
    );
  }

  Future<void> _buySubscription(int subscriptionId) async {
    await Provider.of<SubscriptionProvider>(context, listen: false)
        .buySubscription(subscriptionId, (bool isStatusSuccess,
            StripeUrlResponse? response, ErrorResponse? errorResponse) async {
      // Perform the mounted check inside the callback

      if (isStatusSuccess) {
        print(response?.data);

        if (mounted) {
          var body = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewScreen(url: response?.data ?? ""),
            ),
          );
          if (body) {
            // ignore: use_build_context_synchronously
            // Navigator.of(context).pushReplacement(MaterialPageRoute(
            //     builder: (BuildContext context) => AuthScreen()));
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        }
      } else {
        Navigator.pop(context);
        _showToast(context, "Was not able to subscribe at the moment.");
      }
    });
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
  // Future<void> makePayment(String cost, String curr) async {
  //   try {
  //     //STEP 1: Create Payment Intent
  //     paymentIntent = await createPaymentIntent(cost, 'INR');
  //     var gpay = const sp.PaymentSheetGooglePay(
  //       merchantCountryCode: "US",
  //       currencyCode: "USD",
  //       testEnv: true,
  //     );

  //     //STEP 2: Initialize Payment Sheet
  //     await sp.Stripe.instance
  //         .initPaymentSheet(
  //             paymentSheetParameters: sp.SetupPaymentSheetParameters(
  //                 paymentIntentClientSecret: paymentIntent![
  //                     'client_secret'], //Gotten from payment intent
  //                 style: ThemeMode.light,
  //                 googlePay: gpay,
  //                 merchantDisplayName: 'Abhishek'))
  //         .then((value) {});

  //     //STEP 3: Display Payment sheet
  //     await displayPaymentSheet();
  //   } catch (err) {
  //     print(err.toString());
  //     throw Exception(err);
  //   }
  // }

  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     //Request body
  //     // Dio dio = Dio();

  //     // Request body
  //     Map<String, dynamic> body = {
  //       'amount': amount,
  //       'currency': currency,
  //     };

  //     // // Dio post request to Stripe
  //     // var response = await dio.post(
  //     //   'https://api.stripe.com/v1/payment_intents',
  //     //   options: Options(
  //     //     headers: {
  //     //       'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
  //     //       'Content-Type': 'application/x-www-form-urlencoded',
  //     //     },
  //     //   ),
  //     //   data: body,
  //     // );

  //     // return json.decode(response.data);

  //     //Make post request to Stripe
  //     var response = await http.post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       body: body,
  //       headers: {
  //         'Authorization': 'Bearer ${AppConstants.secret_key}',
  //         'Content-Type': 'application/x-www-form-urlencoded'
  //       },
  //     );
  //     return json.decode(response.body);
  //   } catch (err) {
  //     throw Exception(err.toString());
  //   }
  // }

  // displayPaymentSheet() async {
  //   try {
  //     await sp.Stripe.instance.presentPaymentSheet().then((value) {
  //       showDialog(
  //           context: context,
  //           builder: (_) => AlertDialog(
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: const [
  //                     Icon(
  //                       Icons.check_circle,
  //                       color: Colors.green,
  //                       size: 100.0,
  //                     ),
  //                     SizedBox(height: 10.0),
  //                     Text("Payment Successful!"),
  //                   ],
  //                 ),
  //               ));

  //       paymentIntent = null;
  //     }).onError((error, stackTrace) {
  //       throw Exception(error);
  //     });
  //   } on sp.StripeException catch (e) {
  //     print('Error is:---> $e');
  //     AlertDialog(
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Row(
  //             children: const [
  //               Icon(
  //                 Icons.cancel,
  //                 color: Colors.red,
  //               ),
  //               Text("Payment Failed"),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   } catch (e) {
  //     print('$e');
  //   }
  // }
}
