import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:joy_society/data/model/response/workshop_lesson_section_model.dart';

import '../../../../../utill/color_resources.dart';
import '../../../../../utill/custom_themes.dart';

class LessonSectionWidget extends StatefulWidget {
  const LessonSectionWidget(
      {super.key, required this.workshopLessonSectionModel});

  final WorkshopLessonSectionModel workshopLessonSectionModel;

  @override
  State<LessonSectionWidget> createState() => _LessonSectionWidgetState();
}

class _LessonSectionWidgetState extends State<LessonSectionWidget> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setState(() {
      isExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    dom.Document document =
        htmlparser.parse(widget.workshopLessonSectionModel.detail ?? "<br/>");

    Widget htmlWidget = Html.fromDom(
      document: document,
      style: {
        "img": Style(
            width: Width(MediaQuery.of(context).size.width * 0.8),
            height: Height(MediaQuery.of(context).size.height * 0.55))
      },
    );
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
                color: Colors.white54,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: Offset(0, 1),
                      blurRadius: 1.0,
                      spreadRadius: 0)
                ],
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                              widget.workshopLessonSectionModel.title ?? "",
                              softWrap: true,
                              style: poppinsSemiBold.copyWith(
                                  fontSize: 16, color: Colors.grey.shade900))),
                      AnimatedCrossFade(
                          firstChild: const Icon(Icons.arrow_drop_down_rounded),
                          secondChild: const Icon(Icons.arrow_drop_up_rounded),
                          crossFadeState: !isExpanded
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300))
                    ],
                  ),
                ),
                AnimatedCrossFade(
                    firstChild: Container(
                        child: Column(
                      children: [
                        const Divider(
                          height: 16,
                          color: ColorResources.DIVIDER_COLOR_LIGHT,
                        ),
                        HtmlWidget(
                          widget.workshopLessonSectionModel.detail ?? "",
                          textStyle: const TextStyle(fontFamily: 'poppins'),
                          enableCaching: true,
                        ),
                      ],
                    )),
                    secondChild: Container(),
                    crossFadeState: isExpanded
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300))
              ],
            )),
        const SizedBox(
          height: 8,
        )
      ],
    ));
  }
}
