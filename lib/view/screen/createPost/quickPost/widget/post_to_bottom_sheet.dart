import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/workshop_list_response_model.dart';
import 'package:joy_society/data/model/response/workshop_model.dart';
import 'package:joy_society/provider/workshop_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/basewidget/widgets.dart';
import 'package:provider/provider.dart';

class PostToBottomSheet extends StatefulWidget/*StatelessWidget*/ {
  const PostToBottomSheet({Key? key}) : super(key: key);

  @override
  State<PostToBottomSheet> createState() => _PostToBottomSheetScreenState();
}

class _PostToBottomSheetScreenState extends State<PostToBottomSheet> {
  TextEditingController _searchController = TextEditingController();
  List<WorkshopModel> data = [];

  bool isLoading = false;
  bool isLastPage = false;

  bool load = false;
  int page = 1;

  int selectedIndex = -1;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    init();
    setListener();
  }

  init() async {
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void setListener() {
    _searchController.addListener(() {
      print(_searchController.text);
      searchText = _searchController.text;
      if (searchText.isNotEmpty) {
        page = 1;
        isLastPage = false;
        data.clear();
        load = true;
        isLoading = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 30.0, top: 50),
      clipBehavior: Clip.none,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(50)),
      ),
      child: _buildHandle(context)
    );
  }

  Widget _buildHandle(BuildContext context) {
    return FractionallySizedBox(
      child: Container(
        margin: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(Images.logo_with_name_image, height: 40, width: 40),
                  const SizedBox(width: 16),
                  Text('Joy Society Post to..',
                      style:
                          poppinsBold.copyWith(fontSize: 20, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
              Container(
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
                  child: FutureBuilder<WorkshopListResponseModel?>(
                    future: Provider.of<WorkshopProvider>(context, listen: false)
                        .getWorkshopList(page, searchText, AppConstants.WORKSHOP),
                    builder: (_, snap) {
                      if (snap.hasData) {
                        if (snap.data!.data != null) {
                          isLastPage = snap.data!.data!.length != 20;
                        } else {
                          isLastPage = true;
                        }

                        if (page == 1) data.clear();

                        WorkshopModel? matchedDataInList;
                        if (data.length > 0 &&
                            snap.data != null &&
                            snap.data!.data != null) {
                          for (int i = 0; i < snap.data!.data!.length; i++) {
                            if (snap.data!.data![i].id == data[data.length - 1].id) {
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

                        return Container(
                          height:MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(8))),
                                child: Row(children: [
                                  Expanded(
                                    child: CustomTextField(
                                      textInputType: TextInputType.name,
                                      hintText: 'Search...',
                                      controller: _searchController,
                                    ),
                                  )
                                ]),
                              ),
                              SizedBox(height: 6),
                              ListView.builder(
                                itemCount: data.length,
                                //padding: EdgeInsets.only(bottom: 8, top: 8),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var object = data[index];

                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                    margin: const EdgeInsets.only(
                                        top: 0, left: 0, right: 16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                                //padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(24)),),
                                                width: 48,
                                                height: 48,
                                                child: FadeInImage.assetNetwork(
                                                  placeholder: Images.placeholder, fit: BoxFit.cover,
                                                  image: object.title!,
                                                  imageErrorBuilder: (c, o, s) => Image.asset(Images.logo_with_name_image,
                                                    fit: BoxFit.cover,),
                                                )),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          object.title!,
                                                          style: poppinsRegular.copyWith(
                                                              fontSize: 14,
                                                              color: Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Divider(
                                            color: ColorResources
                                                .NAVIGATION_DIVIDER_COLOR),

                                      ],
                                    ),
                                  ).onTap(() {
                                    selectedIndex = index;
                                    Navigator.pop(context, data[index]);
                                    //Navigator.pop(context, "###################");
                                  });
                                },
                              ).expand(),
                              Loader().visible(load),
                            ],
                          ),
                        );
                      }
                      return snapWidgetHelper(snap);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
