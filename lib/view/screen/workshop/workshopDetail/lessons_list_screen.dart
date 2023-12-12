import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joy_society/view/screen/workshop/workshopDetail/widget/lesson_widget.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/response/workshop_lesson.dart';
import '../../../../data/model/response/workshop_lesson_list_response_model.dart';
import '../../../../provider/workshop_provider.dart';
import '../../../../utill/app_constants.dart';
import '../../../basewidget/widgets.dart';

class LessonListScreen extends StatefulWidget {
  const LessonListScreen({super.key, required this.workshopId});

  final int workshopId;

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  List<WorkshopLessonModel> data = [];

  bool isLoading = false;
  bool isLastPage = false;

  bool load = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
    // setListener();
  }

  init() async {
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 300),
            child: NotificationListener(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification) {
                  if (!isLastPage &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      !load) {
                    page++;
                    load = true;
                    isLoading = true;
                    setState(() {});
                  }
                }
                return isLastPage;
              },
              child: FutureBuilder<WorkshopLessonListResponseModel?>(
                future: Provider.of<WorkshopProvider>(context, listen: false)
                    .getWorkshopLessonList(
                        page, widget.workshopId, AppConstants.WORKSHOP_CONTENT),
                builder: (_, snap) {
                  if (snap.hasData) {
                    if (snap.data!.data != null) {
                      isLastPage = snap.data!.data!.length != 20;
                    } else {
                      isLastPage = true;
                    }

                    if (page == 1) data.clear();

                    WorkshopLessonModel? matchedDataInList;
                    if (data.isNotEmpty &&
                        snap.data != null &&
                        snap.data!.data != null) {
                      for (int i = 0; i < snap.data!.data!.length; i++) {
                        if (snap.data!.data![i].id ==
                            data[data.length - 1].id) {
                          matchedDataInList = data[data.length - 1];
                        }
                      }
                    }
                    if (matchedDataInList == null &&
                        snap.data != null &&
                        snap.data!.data != null) {
                      data.addAll(snap.data!.data!);
                    }
                    load = false;

                    List<WorkshopLessonModel> lessons = data
                        .where((element) =>
                            element.contentType?.toLowerCase() != "overview")
                        .toList();
                    WorkshopLessonModel? overviewSection =
                        data.firstWhereOrNull((lesson) =>
                            lesson.contentType?.toLowerCase() == "overview");

                    return Container(
                        padding:
                            const EdgeInsets.only(top: 16, left: 8, right: 8),
                        child: Column(
                          children: [
                            overviewSection != null
                                ? LessonWidget(lesson: overviewSection)
                                : LessonWidget(
                                    lesson: WorkshopLessonModel(
                                        id: 0, title: 'Overview', detail: '')),
                            ListView.builder(
                              itemCount: lessons.length,
                              padding: const EdgeInsets.only(bottom: 8, top: 8),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                WorkshopLessonModel object = lessons[index];
                                return LessonWidget(lesson: object);
                              },
                            )
                          ],
                        ));
                  }
                  return Center(child: snapWidgetHelper(snap));
                },
              ),
            )));
  }
}
