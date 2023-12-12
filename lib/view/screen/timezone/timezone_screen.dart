import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/common_list_model.dart';
import 'package:joy_society/provider/profile_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/extensions/string_extensions.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/basewidget/widgets.dart';
import 'package:provider/provider.dart';


class TimezoneScreen extends StatefulWidget {
  const TimezoneScreen({Key? key}) : super(key: key);

  @override
  State<TimezoneScreen> createState() => _TimezoneScreenState();
}

class _TimezoneScreenState extends State<TimezoneScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CommonListData> data = [];

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
      log(_searchController.text);
      searchText = _searchController.text;
      if(searchText.isNotEmpty) {
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: Row(
          children: [
            CupertinoNavigationBarBackButton(
              onPressed: () => {
                if (selectedIndex != -1)
                  {
                    //Navigator.pop(context, countryList[selectedIndex].id)
                  }
                else
                  {
                    Navigator.of(context).pop(),
                  }
              },
              color: Colors.black,
            ),
            const SizedBox(width: 16),
            Text(
              'Select a timezone',
              style: poppinsBold.copyWith(
                color: ColorResources.BLACK,
                fontSize: 20,
              ),
            ),
          ],
        ),
        elevation: 0.5,
        backgroundColor: ColorResources.WHITE,
      ),
      body:
        NotificationListener(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo is ScrollEndNotification) {
              if (!isLastPage && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !load) {
                page++;
                load = true;
                isLoading = true;
                setState(() {});
              }
            }
            return isLastPage;
          },
          child: FutureBuilder<AppListingModel?>(
            future: Provider.of<ProfileProvider>(context, listen: false).getLocations(page, searchText, AppConstants.TIMEZONE_URI),
            builder: (_, snap) {
              if (snap.hasData) {
                if(snap.data!.data != null) {
                  isLastPage = snap.data!.data!.length != 20;
                } else {
                  isLastPage = true;
                }

                if (page == 1) data.clear();

                CommonListData? matchedDataInList;
                if(data.isNotEmpty && snap.data!= null && snap.data!.data != null) {
                  for(int i = 0; i< snap.data!.data!.length ; i++ ) {
                    if(snap.data!.data![i].id == data[data.length - 1].id){
                      matchedDataInList = data[data.length - 1];
                    }
                  }
                }
                if (matchedDataInList == null && snap.data!= null && snap.data!.data != null) {
                  data.addAll(snap.data!.data!);
                }
                load = false;

                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomTextField(
                        textInputType: TextInputType.name,
                        hintText: 'Search..',
                        controller: _searchController,
                      ),
                    ),
                    ListView.builder(
                      itemCount: data.length,
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var getListData = data[index];

                        return Card(
                          // color: Colors.white70,
                          elevation: 0.3,
                          color: Colors.transparent,
                          // shadowColor: Colors.blueGrey.shade100,
                          child: Material(
                              child: InkWell(
                                  child: ListTile(
                            onTap: () {
                              selectedIndex = index;
                              Navigator.pop(context, data[index]);
                            },
                            title: RichText(
                              text: TextSpan(
                                  text:
                                      getListData.name.validate().toUpperCase(),
                                  style: poppinsRegular.copyWith(
                                      fontSize: 14,
                                      color: ColorResources.BLACK)),
                            ),
                          ))),
                        );


                      },
                    ).expand(),
                    Loader().visible(load),
                  ],
                );
              }
              return snapWidgetHelper(snap);
            },
          ),
        ),
    );
  }
}
