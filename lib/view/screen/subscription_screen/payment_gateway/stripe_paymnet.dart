// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// class PaymentService {
//   Map<String, dynamic>? paymentIntent;
//   Future<void> makePayment(String cost, String curr) async {
//     try {
//       //STEP 1: Create Payment Intent
//       paymentIntent = await createPaymentIntent(cost, 'INR');
//       var gpay = const PaymentSheetGooglePay(
//         merchantCountryCode: "US",
//         currencyCode: "USD",
//         testEnv: true,
//       );

//       //STEP 2: Initialize Payment Sheet
//       await Stripe.instance
//           .initPaymentSheet(
//               paymentSheetParameters:SetupPaymentSheetParameters(
//                   paymentIntentClientSecret: paymentIntent![
//                       'client_secret'], //Gotten from payment intent
//                   style: ThemeMode.light,
//                   googlePay: gpay,
//                   merchantDisplayName: 'Abhishek'))
//           .then((value) {});

//       //STEP 3: Display Payment sheet
//       await displayPaymentSheet();
//     } catch (err) {
//       throw Exception(err);
//     }
//   }

//   createPaymentIntent(String amount, String currency) async {
//     try {
//       //Request body
//       // Dio dio = Dio();

//       // Request body
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//       };

//       // // Dio post request to Stripe
//       // var response = await dio.post(
//       //   'https://api.stripe.com/v1/payment_intents',
//       //   options: Options(
//       //     headers: {
//       //       'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
//       //       'Content-Type': 'application/x-www-form-urlencoded',
//       //     },
//       //   ),
//       //   data: body,
//       // );

//       // return json.decode(response.data);

//       //Make post request to Stripe
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         body: body,
//         headers: {
//           'Authorization':
//               'Bearer sk_test_51NRPhbSCRLE6eWslNuPvft099uKRjW4EvodGBtP1uifewy8mCLqikj2OtxS2RcR7G94T3If8JkWWvTZMModzSIhh00aA4Uq8Fe',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//       );
//       return json.decode(response.body);
//     } catch (err) {
//       throw Exception(err.toString());
//     }
//   }
//   // displayPaymentSheet() async {
//   //   try {
//   //     await sp.Stripe.instance.presentPaymentSheet().then((value) {
//   //       showDialog(
//   //           context: context,
//   //           builder: (_) => AlertDialog(
//   //                 content: Column(
//   //                   mainAxisSize: MainAxisSize.min,
//   //                   children: const [
//   //                     Icon(
//   //                       Icons.check_circle,
//   //                       color: Colors.green,
//   //                       size: 100.0,
//   //                     ),
//   //                     SizedBox(height: 10.0),
//   //                     Text("Payment Successful!"),
//   //                   ],
//   //                 ),
//   //               ));

//   //       paymentIntent = null;
//   //     }).onError((error, stackTrace) {
//   //       throw Exception(error);
//   //     });
//   //   } on sp.StripeException catch (e) {
//   //     print('Error is:---> $e');
//   //     AlertDialog(
//   //       content: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         children: [
//   //           Row(
//   //             children: const [
//   //               Icon(
//   //                 Icons.cancel,
//   //                 color: Colors.red,
//   //               ),
//   //               Text("Payment Failed"),
//   //             ],
//   //           ),
//   //         ],
//   //       ),
//   //     );
//   //   } catch (e) {
//   //     print('$e');
//   //   }
//   // }

//   displayPaymentSheet() async {
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) {
//         //Clear paymentIntent variable after successful payment
//         paymentIntent = null;
//       }).onError((error, stackTrace) {
//         throw Exception(error);
//       });
//     } on StripeException catch (e) {
//       print('Error is:---> $e');
//     } catch (e) {
//       print('$e');
//     }
//   }

//   // displayPaymentSheet() async {
//   //   try {
//   //     await Stripe.instance.presentPaymentSheet().then((value) {
//   //       showDialog(
//   //           context: context,
//   //           builder: (_) => AlertDialog(
//   //                 content: Column(
//   //                   mainAxisSize: MainAxisSize.min,
//   //                   children: const [
//   //                      Icon(
//   //                       Icons.check_circle,
//   //                       color: Colors.green,
//   //                       size: 100.0,
//   //                     ),
//   //                     SizedBox(height: 10.0),
//   //                     Text("Payment Successful!"),
//   //                   ],
//   //                 ),
//   //               ));

//   //       paymentIntent = null;
//   //     }).onError((error, stackTrace) {
//   //       throw Exception(error);
//   //     });
//   //   } on StripeException catch (e) {
//   //     print('Error is:---> $e');
//   //     AlertDialog(
//   //       content: Column(
//   //         mainAxisSize: MainAxisSize.min,
//   //         children: [
//   //           Row(
//   //             children: const [
//   //               Icon(
//   //                 Icons.cancel,
//   //                 color: Colors.red,
//   //               ),
//   //               Text("Payment Failed"),
//   //             ],
//   //           ),
//   //         ],
//   //       ),
//   //     );
//   //   } catch (e) {
//   //     print('$e');
//   //   }
//   // }
// }
