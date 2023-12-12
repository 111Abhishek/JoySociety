import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:joy_society/data/model/response/workshop_lesson.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';

import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:joy_society/view/screen/workshop/workshopDetail/widget/lesson_section_widget.dart';

class LessonWidget extends StatefulWidget {
  const LessonWidget({super.key, required this.lesson});

  final WorkshopLessonModel lesson;

  @override
  State<LessonWidget> createState() => _LessonWidgetState();
}

class _LessonWidgetState extends State<LessonWidget> {
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

  Widget buildSectionsList() {
    if (widget.lesson.sections!.isNotEmpty) {}
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    dom.Document document = htmlparser.parse(widget.lesson.detail ?? "<br/>");

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
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5))),
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
                          child: Text(widget.lesson.title!,
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
                          widget.lesson.detail ?? "",
                          textStyle: const TextStyle(fontFamily: 'poppins'),
                          enableCaching: true,
                        ),
                        if (widget.lesson.sections != null &&
                            widget.lesson.sections!.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: widget.lesson.sections!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return LessonSectionWidget(
                                  workshopLessonSectionModel:
                                      widget.lesson.sections![index]);
                            },
                          )
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
          height: 4,
        )
      ],
    ));
  }
}
