import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_society/provider/true_success_question_provider.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/screen/true_success_evaluation/tru_success_part_1.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/base/error_response.dart';
import '../../../data/model/response/trueSuccessQuesResp.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/custom_themes.dart';
import '../../basewidget/button/custom_button_secondary.dart';
import '../../basewidget/loader_widget.dart';

class TrueSuccessQuestionPage extends StatefulWidget {
  bool isSubscribed;
  TrueSuccessQuestionPage({super.key, required this.isSubscribed});

  @override
  State<TrueSuccessQuestionPage> createState() =>
      _TrueSuccessQuestionPageState();
}

class _TrueSuccessQuestionPageState extends State<TrueSuccessQuestionPage> {
  TrueSuccessQuesResp? _trueQuesRespLocal;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isSubscribed) {
        _getSuccessSphereComprehensiveQues();
      } else {
        _getSuccessSphereFreeQues();
      }
    });

    super.initState();
  }

  _getSuccessSphereFreeQues() async {
    _trueQuesRespLocal = await Provider.of<TrueSuccessProvider>(context,
            listen: false)
        .getTrueSuccessQuestion('/goal/success-sphere-question/?search=FREE');

    selectedValue = List<int>.generate(
        _trueQuesRespLocal!.results!.length, (int index) => 0,
        growable: true);
  }

  _getSuccessSphereComprehensiveQues() async {
    _trueQuesRespLocal =
        await Provider.of<TrueSuccessProvider>(context, listen: false)
            .getTrueSuccessQuestion(
                '/goal/success-sphere-question/?search=COMPREHENSIVE');
    selectedValue = List<int>.generate(
        _trueQuesRespLocal!.results!.length, (int index) => 0,
        growable: true);
  }

  List<int> selectedValue = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(color: Color(0xfff4f7fc)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CupertinoNavigationBarBackButton(
                          onPressed: () => Navigator.of(context).pop(),
                          color: Colors.black,
                        ),
                       // const SizedBox(width: 5),
                        Image.asset(
                          "assets/images/logo_with_name.png",
                          scale: 6,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("TRU Success Evaluation",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            Text(
                              widget.isSubscribed ? "Part 2" : "Part 1",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black38),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "The Joy Society Evalualtion is quick and easy to complete. Each Success Sphere has a maxium score of 30",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black38),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(child: Consumer<TrueSuccessProvider>(
                    builder: (context, trueProvider, child) {
              if (trueProvider.isLoading) {
                return Center(
                  child: Loader().visible(trueProvider.isLoading),
                );
              } else if (trueProvider.trueQuesContent!.results!.isEmpty) {
                return Center(
                  child: Text(
                    "No Question Found",
                    style: poppinsBold.copyWith(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                );
              } else {
                return ListView.separated(
                    shrinkWrap: true,
                    primary: true,
                    itemCount: trueProvider.trueQuesContent!.results!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                trueProvider
                                    .trueQuesContent!.results![index].question!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                )),
                            const SizedBox(height: 3),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color(0xfff4f7fc)),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Low",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black38),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await Provider.of<TrueSuccessProvider>(
                                                context,
                                                listen: false)
                                            .successEvaluation(
                                                (bool isStatusSuccess,
                                                    ErrorResponse?
                                                        errorResponse) {
                                          if (isStatusSuccess) {
                                            selectedValue[index] = 1;
                                          } else {
                                            selectedValue[index] = 0;
                                          }
                                        },
                                                trueProvider.trueQuesContent!
                                                    .results![index].id!,
                                                1);
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: selectedValue[index] == 1
                                                ? Colors.green
                                                : Colors.white,
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 1)),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          child: Text(
                                            "1",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black38),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await Provider.of<TrueSuccessProvider>(
                                                context,
                                                listen: false)
                                            .successEvaluation(
                                                (bool isStatusSuccess,
                                                    ErrorResponse?
                                                        errorResponse) {
                                          if (isStatusSuccess) {
                                            selectedValue[index] = 2;
                                          } else {
                                            selectedValue[index] = 0;
                                          }
                                        },
                                                trueProvider.trueQuesContent!
                                                    .results![index].id!,
                                                2);
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: selectedValue[index] == 2
                                                ? Colors.green
                                                : Colors.white,
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 1)),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          child: Text(
                                            "2",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black38),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await Provider.of<TrueSuccessProvider>(
                                                context,
                                                listen: false)
                                            .successEvaluation(
                                                (bool isStatusSuccess,
                                                    ErrorResponse?
                                                        errorResponse) {
                                          if (isStatusSuccess) {
                                            selectedValue[index] = 3;
                                          } else {
                                            selectedValue[index] = 0;
                                          }
                                        },
                                                trueProvider.trueQuesContent!
                                                    .results![index].id!,
                                                3);
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: selectedValue[index] == 3
                                                ? Colors.green
                                                : Colors.white,
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 1)),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          child: Text(
                                            "3",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black38),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await Provider.of<TrueSuccessProvider>(
                                                context,
                                                listen: false)
                                            .successEvaluation(
                                                (bool isStatusSuccess,
                                                    ErrorResponse?
                                                        errorResponse) {
                                          if (isStatusSuccess) {
                                            selectedValue[index] = 4;
                                          } else {
                                            selectedValue[index] = 0;
                                          }
                                        },
                                                trueProvider.trueQuesContent!
                                                    .results![index].id!,
                                                4);
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: selectedValue[index] == 4
                                                ? Colors.green
                                                : Colors.white,
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 1)),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          child: Text(
                                            "4",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black38),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await Provider.of<TrueSuccessProvider>(
                                                context,
                                                listen: false)
                                            .successEvaluation(
                                                (bool isStatusSuccess,
                                                    ErrorResponse?
                                                        errorResponse) {
                                          if (isStatusSuccess) {
                                            selectedValue[index] = 5;
                                          } else {
                                            selectedValue[index] = 0;
                                          }
                                        },
                                                trueProvider.trueQuesContent!
                                                    .results![index].id!,
                                                5);
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: selectedValue[index] == 5
                                                ? Colors.green
                                                : Colors.white,
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 1)),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          child: Text(
                                            "5",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black38),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "High",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black38),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    });
              }
            })
                /*  question(text: "How would you rate your spiritual well-being?"),
            const Divider(
              color: Colors.black26,
            ),
            question(text: "How would you rate your social well-being?"),
            const Divider(
              color: Colors.black26,
            ),
            question(text: "How would you rate your professional (career) well-being?"),
            const Divider(
              color: Colors.black26,
            ),
            question(text: "How would you rate your physical well-being?"),
            const Divider(
              color: Colors.black26,
            ),
            question(text: "How would you rate your spiritual well-being?"),
            const Divider(
              color: Colors.black26,
            ),
            question(text: "How would you rate your spiritual well-being?"),
            const Divider(
              color: Colors.black26,
            ),
            question(text: "How would you rate your spiritual well-being?"),
            const Divider(
              color: Colors.black26,
            ),
            question(text: "How would you rate your spiritual well-being?"),*/
                ),
            const SizedBox(
              height: 30,
            ),
            Visibility(
              visible: !selectedValue.contains(0) && selectedValue.isNotEmpty,
              child: CustomButtonSecondary(
                bgColor: ColorResources.DARK_GREEN_COLOR,
                textColor: ColorResources.WHITE,
                isCapital: false,
                height: 50,
                buttonText: "Next",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return TrueSuccessResultPage(
                        isSubscribed: widget.isSubscribed,
                      );
                    },
                  ));
                },
              ),
            ).paddingSymmetric(horizontal: 10)
          ],
        ),
      ),
    );
  }

  // List<Map<String, dynamic>> data = [
  //   {"text": "How would you rate your spiritual well-being?", "score": 0},
  //   {"text": "How would you rate your romantic well-being?", "score": 0},
  //   {
  //     "text": "How would you rate your professional (career) well-being?",
  //     "score": 0
  //   },
  //   {"text": "How would you rate your physical well-being?", "score": 0},
  //   {"text": "How would you rate your financial well-being?", "score": 0},
  //   {"text": "How would you rate your family well-being?", "score": 0},
  //   {
  //     "text": "How would you rate your emotional/mental well-being?",
  //     "score": 0
  //   },
  // ];

  question({
    String? text = "",
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              )),
          const SizedBox(height: 3),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xfff4f7fc)),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Low",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black38),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black12, width: 1)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Text(
                        "1",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black38),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black12, width: 1)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Text(
                        "2",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black38),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black12, width: 1)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Text(
                        "3",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black38),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black12, width: 1)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Text(
                        "4",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black38),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        border: Border.all(color: Colors.black12, width: 1)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Text(
                        "5",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black38),
                      ),
                    ),
                  ),
                  const Text(
                    "High",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black38),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  scoreContainer({String text = ""}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: Colors.black12, width: 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w500, color: Colors.black38),
        ),
      ),
    );
  }
}
