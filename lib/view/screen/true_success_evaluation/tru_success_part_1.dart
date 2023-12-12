import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/screen/subscription_screen/subscription_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/true_success_result_model.dart';
import '../../../provider/true_success_question_provider.dart';
import '../../basewidget/button/custom_button_secondary.dart';
import '../../basewidget/loader_widget.dart';
import 'package:pdf/widgets.dart' as pw;

class TrueSuccessResultPage extends StatefulWidget {
  bool? isSubscribed;
  TrueSuccessResultPage({Key? key, this.isSubscribed}) : super(key: key);

  @override
  State<TrueSuccessResultPage> createState() => _TrueSuccessResultPageState();
}

class _TrueSuccessResultPageState extends State<TrueSuccessResultPage> {
  @override
  void initState() {
    _getSuccessResult();
    super.initState();
  }

  _getSuccessResult() async {
    await Provider.of<TrueSuccessProvider>(context, listen: false)
        .getResultEvaluation(widget.isSubscribed!
            ? "/goal/success-evaluation-report/?report_type=COMPREHENSIVE&per_page=40"
            : '/goal/success-evaluation-report/');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Images.logo_with_name_image,
                      height: 60,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'JoySociety',
                      style: poppinsBold.copyWith(
                          fontSize: 30, color: ColorResources.DARK_GREEN_COLOR),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 60),
                //   child: Text(
                //     getTranslated('PART_1', context),
                //     style:
                //     poppinsBold.copyWith(fontSize: 13, color: Colors.black.withOpacity(0.5)),
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    getTranslated('TRUE_SUCCESS_RESULT', context),
                    style: poppinsMedium.copyWith(
                        fontSize: 13, color: Colors.black),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Consumer<TrueSuccessProvider>(
                    builder: (context, trueProvider, child) {
                  if (trueProvider.isLoading) {
                    return Center(
                      child: Loader().visible(trueProvider.isLoading),
                    );
                  } else if (trueProvider.successResult!.report!.isEmpty) {
                    return Center(
                      child: Text(
                        "Data Not Found",
                        style: poppinsBold.copyWith(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorResources.WHITE,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Score',
                                style: poppinsBold.copyWith(
                                    fontSize: 20, color: ColorResources.BLACK),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: trueProvider
                                      .successResult!.report!.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              trueProvider.successResult!
                                                  .report![index].label!,
                                              style: poppinsRegular.copyWith(
                                                  fontSize: 14,
                                                  color: ColorResources
                                                      .TEXT_BLACK_COLOR),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              ': ${trueProvider.successResult!.report![index].score!}',
                                              style: poppinsRegular.copyWith(
                                                  fontSize: 14,
                                                  color: ColorResources
                                                      .TEXT_BLACK_COLOR),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    );
                                  }),
                              Visibility(
                                visible: !widget.isSubscribed!,
                                child: CustomButtonSecondary(
                                    bgColor: ColorResources.DARK_GREEN_COLOR,
                                    textColor: ColorResources.WHITE,
                                    isCapital: false,
                                    height: 50,
                                    buttonText: "Comprehensive Evaluation",
                                    onTap: () {
                                      _showCustomDialog(context, true);
                                    }),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              CustomButtonSecondary(
                                  bgColor: ColorResources.RED,
                                  textColor: ColorResources.WHITE,
                                  isCapital: false,
                                  borderColor: ColorResources.RED,
                                  height: 50,
                                  buttonText: "Download pdfs",
                                  onTap: () {
                                    _createDownloadedPdf(
                                        trueProvider.successResult!);
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (_) {}));
                                  }),
                              const SizedBox(
                                height: 15,
                              ),
                              CustomButtonSecondary(
                                  bgColor: ColorResources.DARK_GREEN_COLOR,
                                  textColor: ColorResources.WHITE,
                                  isCapital: false,
                                  height: 50,
                                  buttonText: "Start Goal Setting",
                                  onTap: () {
                                    _showCustomDialog(context, false);
                                  })
                            ],
                          ),
                        ));
                  }
                }),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorResources.WHITE,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: 'You perceive your',
                              style: poppinsRegular.copyWith(
                                color: Colors.black,
                                fontSize: 14,
                              )),
                          TextSpan(
                            text: ' highest',
                            style: poppinsBold.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                '  level of satisfaction and happiness to be in the',
                            style: poppinsRegular.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                              text:
                                  'Career,  Emotional/Mental,  Family,  Finance,  Physical,  Romance,  Social and Spiritual,',
                              style: poppinsBold.copyWith(
                                color: Colors.black,
                                fontSize: 14,
                              )),
                          TextSpan(
                            text: '  Success Sphere.',
                            style: poppinsRegular.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ])),
                        const SizedBox(
                          height: 15,
                        ),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                              text: 'You perceive your',
                              style: poppinsRegular.copyWith(
                                color: Colors.black,
                                fontSize: 14,
                              )),
                          TextSpan(
                            text: ' lowest',
                            style: poppinsBold.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                '  level of satisfaction and happiness to be in the',
                            style: poppinsRegular.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                              text:
                                  'Career,  Emotional/Mental,  Family,  Finance,  Physical,  Romance,  Social and Spiritual,',
                              style: poppinsBold.copyWith(
                                color: Colors.black,
                                fontSize: 14,
                              )),
                          TextSpan(
                            text: '  Success Sphere.',
                            style: poppinsRegular.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ])),
                        const SizedBox(
                          height: 15,
                        ),
                        Text.rich(TextSpan(children: [
                          TextSpan(
                            text: ' Your next step:',
                            style: poppinsBold.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text:
                                '  Click the button above to take Part 2 of this evaluation, a deeper dive into your scores in each sphere',
                            style: poppinsRegular.copyWith(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ])),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCustomDialog(BuildContext context, bool isEvalPopUp) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // To prevent dismissing the dialog on tap outside
      builder: (BuildContext context) {
        return CustomDialog(
          isEvalPopUp: isEvalPopUp,
          onYesPressed: () {
            // Perform action for "Yes"
            Navigator.pop(context, true);
            isEvalPopUp
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const SubscriptionScreen()))
                : Navigator.popUntil(context, (route) => route.isFirst);
          },
          onNoPressed: () {
            // Perform action for "No"
            Navigator.pop(context, false);
          },
          onClosePressed: () {
            // Perform action for "Close"
            Navigator.pop(context);
          },
        );
      },
    ).then((value) {
      // You can handle the result returned from the dialog here if needed
      if (value != null && value == true) {
        // User selected "Yes"
        // Do something
      } else if (value != null && value == false) {
        // User selected "No"
        // Do something else
      } else {
        // User closed the dialog
        // Do nothing or handle any other actions
      }
    });
  }

  Future<void> _createDownloadedPdf(TrueSuccessResultModel result) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'JoySociety',
                      style: pw.TextStyle(
                        fontSize: 30,
                        color: const PdfColor.fromInt(0xff1a7368),
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'You are encouraged to use these results in conjunction with our TRU Success Workbook, to guide you through identifying, refreshing, and elevating your goals over a 12-month period.',
                  style: pw.TextStyle(
                    fontSize: 16,
                    color: const PdfColor.fromInt(0xff000000),
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Below are your results. NOTE: Each section has a maximum of 25 points.',
                  style: pw.TextStyle(
                    fontSize: 16,
                    color: const PdfColor.fromInt(0xff000000),
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Scores:',
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(
                    fontSize: 16,
                    color: const PdfColor.fromInt(0xff000000),
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                _itemRowForPdf("Social", '${result.report![0].score}'),
                pw.SizedBox(height: 10),
                _itemRowForPdf("Romance", '${result.report![1].score}'),
                pw.SizedBox(height: 10),
                _itemRowForPdf("Career", '${result.report![2].score}'),
                pw.SizedBox(height: 10),
                _itemRowForPdf("Physical", '${result.report![3].score}'),
                pw.SizedBox(height: 10),
                _itemRowForPdf("Spiritual", '${result.report![4].score}'),
                pw.SizedBox(height: 10),
                _itemRowForPdf(
                    "emotional/Mental", '${result.report![5].score}'),
                pw.SizedBox(height: 10),
                _itemRowForPdf("Family", '${result.report![6].score}'),
                pw.SizedBox(height: 10),
                _itemRowForPdf("Finance", '${result.report![7].score}'),
                pw.SizedBox(height: 30),
                // pw.Text(
                //   'Questions and Responses',
                //   textAlign: pw.TextAlign.right,
                //   style: pw.TextStyle(
                //     fontSize: 30,
                //     color: const PdfColor.fromInt(0xff000000),
                //     fontWeight: pw.FontWeight.bold,
                //   ),
                // ),
                // pw.SizedBox(height: 30),
                // pw.Align(
                //     alignment: pw.Alignment.topLeft,
                //     child: pw.ListView.builder(
                //       itemCount: result.report!.length,
                //       itemBuilder: (context, index) {
                //         return pw.Column(
                //             crossAxisAlignment: pw.CrossAxisAlignment.start,
                //             children: [
                //               pw.Padding(
                //                 padding: const pw.EdgeInsets.symmetric(
                //                     vertical: 8, horizontal: 16),
                //                 child: pw.Column(
                //                   mainAxisAlignment:
                //                       pw.MainAxisAlignment.center,
                //                   children: [
                //                     // pw.SizedBox(
                //                     //   width:
                //                     //
                //                     pw.Container(
                //                       color: const PdfColor.fromInt(
                //                           0xFFF5F6FA), // Adjust the width according to your needs
                //                       child: pw.Text(
                //                         "${result.report![index].label}",
                //                         style: const pw.TextStyle(
                //                           color: PdfColors.grey,
                //                           fontSize: 16,
                //                         ),
                //                       ),
                //                     ),

                //                     pw.Text(
                //                       "    ",
                //                       style: const pw.TextStyle(
                //                         color: PdfColors.grey,
                //                         fontSize: 16,
                //                       ),
                //                     ),
                //                     pw.Text(
                //                       "Your Response:${result.report![index].score}",
                //                       textAlign: pw.TextAlign.right,
                //                       style: pw.TextStyle(
                //                         color:
                //                             const PdfColor.fromInt(0xff000000),
                //                         fontSize: 16,
                //                         fontWeight: pw.FontWeight.bold,
                //                       ),
                //                     ),

                //                     //  pw.SizedBox(height:20),
                //                   ],
                //                 ),
                //               ),
                //               // pw.SizedBox(height: 20),
                //             ]);
                //       },
                //     ))
              ],
            ),
          ),
        ),
      );

      final pdfData = await pdf.save();
      await Printing.layoutPdf(
        onLayout: (_) => pdfData,
      );
    } catch (e) {
      print('Exception in PDF :: $e');
    }
  }

  _itemRowForPdf(String title, String subTitle) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.SizedBox(
            width: 200, // Adjust the width according to your needs
            child: pw.Text(
              "${title}",
              style: const pw.TextStyle(
                color: PdfColors.grey,
                fontSize: 16,
              ),
            ),
          ),
          pw.Text(
            " : ",
            style: const pw.TextStyle(
              color: PdfColors.grey,
              fontSize: 16,
            ),
          ),
          pw.Text(
            "${subTitle}",
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              color: const PdfColor.fromInt(0xff000000),
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.ListView _buildListView(report) {
    return pw.ListView.builder(
      itemCount: report.length,
      itemBuilder: (context, index) {
        return pw.Padding(
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.SizedBox(
                width: 200, // Adjust the width according to your needs
                child: pw.Text(
                  "${report[index].label}",
                  style: const pw.TextStyle(
                    color: PdfColors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
              pw.Text(
                " : ",
                style: const pw.TextStyle(
                  color: PdfColors.grey,
                  fontSize: 16,
                ),
              ),
              pw.Text(
                "${report[index].score}",
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  color: const PdfColor.fromInt(0xff000000),
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomDialog extends StatelessWidget {
  final bool? isEvalPopUp;
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;
  final VoidCallback onClosePressed;

  CustomDialog(
      {required this.onYesPressed,
      required this.onNoPressed,
      required this.onClosePressed,
      this.isEvalPopUp});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClosePressed,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              isEvalPopUp!
                  ? "You're making progress! Upgrade to a premium membership now to take the next step to holistic success."
                  : 'Are you sure want to Visit home page?',
              style: poppinsBold.copyWith(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: isEvalPopUp!
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceEvenly,
            children: [
              Visibility(
                visible: !isEvalPopUp!,
                child: CustomButtonSecondary(
                  bgColor: ColorResources.WHITE,
                  textColor: ColorResources.GRAY_TEXT_COLOR,
                  isCapital: false,
                  height: 45,
                  buttonText: "No",
                  onTap: onClosePressed,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              CustomButtonSecondary(
                  bgColor: ColorResources.DARK_GREEN_COLOR,
                  textColor: ColorResources.WHITE,
                  isCapital: false,
                  height: 45,
                  buttonText: isEvalPopUp! ? "Ok" : "Yes",
                  onTap: onYesPressed),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
