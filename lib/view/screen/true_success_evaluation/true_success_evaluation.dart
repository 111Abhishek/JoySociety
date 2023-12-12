import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:joy_society/data/model/response/profile_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/view/screen/true_success_evaluation/tru_success_part_1.dart';
import 'package:joy_society/view/screen/true_success_evaluation/true_success_question.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/true_success_result_model.dart';
import '../../../provider/profile_provider.dart';
import '../../../provider/true_success_question_provider.dart';

class TrueSuccessEvaluation extends StatefulWidget {
  const TrueSuccessEvaluation({Key? key}) : super(key: key);

  @override
  State<TrueSuccessEvaluation> createState() => _TrueSuccessEvaluationState();
}

class _TrueSuccessEvaluationState extends State<TrueSuccessEvaluation> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProfileDetail();
    });

    super.initState();
  }

  bool? isSubscribed;
  ProfileModel? profModel = ProfileModel();

  getProfileDetail() async {
    profModel = await Provider.of<ProfileProvider>(context, listen: false)
        .getProfileData();
    setState(() {
      isSubscribed = profModel!.isSubscribed == "Completed";
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: isSubscribed == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : FutureBuilder<TrueSuccessResultModel>(
                      future: isSubscribed == null
                          ? _getDefaultFuture() // Provide a default future with null value
                          : isSubscribed!
                              ? Provider.of<TrueSuccessProvider>(context,
                                      listen: false)
                                  .getResultEvaluation(
                                      '/goal/success-evaluation-report/?report_type=COMPREHENSIVE&per_page=40')
                              : Provider.of<TrueSuccessProvider>(context,
                                      listen: false)
                                  .getResultEvaluation(
                                      '/goal/success-evaluation-report/'),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          final bool dataFromAPI =
                              snapshot.data!.report!.isNotEmpty;
                          if (dataFromAPI) {
                            // Navigate to the next screen if data is true
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrueSuccessResultPage(
                                    isSubscribed: isSubscribed,
                                  ),
                                ),
                              );
                            });
                          }
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              getTranslated('TRU_SUCCESS_WORKBOOK', context),
                              style: poppinsBold.copyWith(
                                  fontSize: 18, color: Colors.black),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              getTranslated(
                                  'A_GUIDE_REIMAGINING_SUCESS', context),
                              style: poppinsLight.copyWith(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.6)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 7),
                            Image.asset(Images.tru_banner),
                            const SizedBox(height: 25),
                            Expanded(
                                child: SingleChildScrollView(
                                    child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(Images.tru_circle, height: 150),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      child: Text(
                                        getTranslated(
                                            'SUCCESS_DESCRIPTION_1', context),
                                        style: poppinsLight.copyWith(
                                            fontSize: 15,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                        maxLines: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minHeight: 300),
                                  child: Text(
                                    getTranslated(
                                        'SUCCESS_DESCRIPTION_2', context),
                                    style: poppinsLight.copyWith(
                                        fontSize: 15,
                                        color: Colors.black.withOpacity(0.6)),
                                    maxLines: 10,
                                  ),
                                ),
                              ],
                            ))),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 15),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return TrueSuccessQuestionPage(
                                              isSubscribed: isSubscribed!,
                                            );
                                          },
                                        ));
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            getTranslated(
                                                'GET_STARTED', context),
                                            style: poppinsLight.copyWith(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.arrow_forward_sharp,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        );
                      }),
            ),
          ),
        ));
  }

  Future<TrueSuccessResultModel>? _getDefaultFuture() {
    return Future.delayed(Duration.zero, () => TrueSuccessResultModel());
  }
}
