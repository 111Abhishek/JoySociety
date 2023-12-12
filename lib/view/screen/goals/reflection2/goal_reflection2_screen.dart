import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/base/error_response.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/provider/goal_provider.dart';
import 'package:joy_society/view/basewidget/button/custom_button_secondary.dart';
import 'package:joy_society/view/screen/goals/reflection3/goal_reflection3_screen.dart';
import 'package:provider/provider.dart';

import '../../../../localization/language_constants.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dimensions.dart';
import '../../../../utill/images.dart';

class GoalReflection2Screen extends StatefulWidget {
  const GoalReflection2Screen({Key? key}) : super(key: key);

  @override
  State<GoalReflection2Screen> createState() => _GoalReflection2ScreenState();
}

class _GoalReflection2ScreenState extends State<GoalReflection2Screen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  List<bool>? _selected = <bool>[];
  List<bool>? _selectedSpheres = <bool>[];

  List<CommonListData>? _spheresList = <CommonListData>[];
  bool _isSelectable = false;
  //List<bool>? _selected = List.generate(8, (i) => false);

  void onItemClick(int index, CommonListData obj) {}

  @override
  void initState() {
    super.initState();
    getSuccessSphere();
  }

  getSuccessSphere() async {
    await Provider.of<GoalProvider>(context, listen: false)
        .getSuccessSphere(getSuccessSphereCallback);
  }

  getSuccessSphereCallback(bool isStatusSuccess,
      AppListingModel? successResponse, ErrorResponse? errorResponse) async {
    if (isStatusSuccess) {
      _spheresList = successResponse?.data;
      //_templateController.text = memberContent?.template ?? "";
    } else {
      String? errorDescription = errorResponse?.errorDescription;
      if (errorResponse?.non_field_errors != null) {
        errorDescription = errorResponse?.non_field_errors![0];
      } else {
        errorDescription ??= 'Technical error, Please try again later!';
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorDescription!), backgroundColor: Colors.red));
    }
  }

  void _onSphereSelection(int index) {
    _selectedSpheres = _selected?.where((i) => i).toList();

    if (_selected![index]) {
      setState(() => _selected![index] = false);
      return;
    }

    if (_selectedSpheres!.length > 1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You can't select more than 2 Spheres"),
          backgroundColor: Colors.red));
    } else {
      setState(() => _selected![index] = !_selected![index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<GoalProvider>(
        builder: (context, goal, child) {
          if (_selected!.isEmpty) {
            _selected = List.generate(
                goal.successSphereResponse!.data!.length, (i) => false);
          }
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 48, left: 8),
                child: Row(children: [
                  CupertinoNavigationBarBackButton(
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors.black,
                  ),
                  Image.asset(Images.logo_with_name_image,
                      height: 40, width: 40),
                  const SizedBox(width: 10),
                  Text(getTranslated('REFLECTION', context),
                      style: poppinsBold.copyWith(
                          fontSize: 20, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 65,
                    width: 65,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(2.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "2",
                                style: poppinsBold.copyWith(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Text(
                                "/6",
                                style: poppinsRegular.copyWith(
                                  fontSize: 12,
                                  color:
                                      ColorResources.CUSTOM_TEXT_BORDER_COLOR,
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ]),
              ),
              Container(
                margin: const EdgeInsets.only(
                    top: Dimensions.MARGIN_SIZE_LARGE,
                    left: Dimensions.MARGIN_SIZE_DEFAULT,
                    right: Dimensions.MARGIN_SIZE_DEFAULT),
                padding: const EdgeInsets.only(top: 90),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                            getTranslated(
                                'identify_your_focus_spheres', context),
                            style: poppinsBold.copyWith(
                                fontSize: 16, color: Colors.black)),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              goal.successSphereResponse?.data?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                const SizedBox(height: 20),
                                CustomButtonSecondary(
                                  buttonText: goal.successSphereResponse
                                          ?.data?[index].name ??
                                      "",
                                  borderColor: Theme.of(context).primaryColor,
                                  bgColor: _selected![index]
                                      ? ColorResources.TEAL_BG_COLOR
                                      : Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  textStyle: poppinsRegular,
                                  fontSize: 16,
                                  isCapital: false,
                                  onTap: () => _onSphereSelection(index),
                                ),
                              ],
                            );
                          },
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: Dimensions.MARGIN_SIZE_LARGE,
                                  bottom: Dimensions.MARGIN_SIZE_LARGE,
                                  right: Dimensions.MARGIN_SIZE_SMALL),
                              alignment: AlignmentDirectional.centerEnd,
                              child: CustomButtonSecondary(
                                buttonText: "SKIP",
                                borderColor:
                                    ColorResources.GRAY_BUTTON_BG_COLOR,
                                bgColor: ColorResources.GRAY_BUTTON_BG_COLOR,
                                textColor: Colors.white,
                                textStyle: poppinsBold,
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const GoalReflection3Screen(
                                              selectedSphere: <CommonListData>[])));
                                },
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 4,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: Dimensions.MARGIN_SIZE_LARGE,
                                    bottom: Dimensions.MARGIN_SIZE_LARGE,
                                    left: Dimensions.MARGIN_SIZE_SMALL),
                                alignment: AlignmentDirectional.centerEnd,
                                child: CustomButtonSecondary(
                                  buttonText: "NEXT",
                                  borderColor: Theme.of(context).primaryColor,
                                  bgColor: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  textStyle: poppinsBold,
                                  onTap: () {
                                    var selectedListToPass = <CommonListData>[];
                                    for (int i = 0;
                                        i < _selected!.length;
                                        i++) {
                                      if (_selected![i]) {
                                        selectedListToPass
                                            .add(_spheresList![i]);
                                      }
                                    }
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                GoalReflection3Screen(
                                                    selectedSphere:
                                                        selectedListToPass)));
                                  },
                                ),
                              )),
                        ],
                      )
                    ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
