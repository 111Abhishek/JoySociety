import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:joy_society/data/model/response/sent_invtes_list_response_model.dart';
import 'package:joy_society/data/model/response/sent_invtes_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/provider/members_provider.dart';
import 'package:joy_society/utill/app_constants.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/widget_extensions.dart';
import 'package:joy_society/view/basewidget/loader_widget.dart';
import 'package:joy_society/view/basewidget/textfield/custom_textfield.dart';
import 'package:joy_society/view/basewidget/widgets.dart';
import 'package:joy_society/view/screen/members/sentInvites/widget/TopDataSentInviteComponent.dart';
import 'package:provider/provider.dart';


class RequestsToJoinScreen extends StatefulWidget {
  const RequestsToJoinScreen({Key? key}) : super(key: key);

  @override
  State<RequestsToJoinScreen> createState() => _RequestsToJoinScreenState();
}

class _RequestsToJoinScreenState extends State<RequestsToJoinScreen> {
  TextEditingController _searchController = TextEditingController();
  List<SentInvitesModel> data = [];

  bool isLoading = false;
  bool isLastPage = false;

  bool load = false;
  int page = 1;

  int selectedIndex = -1;
  String searchText = '';
  var inputFormatter = new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  var outputFormatter = new DateFormat("EEE, MMM d, yyyy");

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

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: NotificationListener(
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
          child: FutureBuilder<SentInvitesListResponseModel?>(
            future: Provider.of<MembersProvider>(context, listen: false).getRequestsToJoinList(page, searchText, AppConstants.REQUESTS_TO_JOIN_LIST),
            builder: (_, snap) {
              if (snap.hasData) {
                if(snap.data!.data != null) {
                  isLastPage = snap.data!.data!.length != 20;
                } else {
                  isLastPage = true;
                }

                if (page == 1) data.clear();

                SentInvitesModel? matchedDataInList;
                if(data.length > 0 && snap.data!= null && snap.data!.data != null) {
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
                        Text(getTranslated('REQUEST_TO_JOIN', context),
                            style: poppinsBold.copyWith(
                                fontSize: 20, color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ]),
                    ),
                    SizedBox(height: 16),
                    /*TopDataSentInviteComponent(),
                    SizedBox(height: 16),*/
                    /*Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(color: ColorResources.PRIMARY_COLOR, borderRadius: BorderRadius.all(Radius.circular(8))),
                      child: CustomTextField(
                        textInputType: TextInputType.name,
                        hintText: 'Search...',
                        controller: _searchController,
                      ),
                    ),*/
                    ListView.builder(
                      itemCount: data.length,
                      padding: EdgeInsets.only(bottom: 8, top: 8),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var object = data[index];

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(16),
                              margin: const EdgeInsets.only(top: 0, left: 16, right: 16),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("FIRST NAME", style: poppinsRegular.copyWith(fontSize: 12, color: ColorResources.TEXT_FORM_TEXT_COLOR)),
                                              Text(object.first_name ?? "", style: poppinsRegular.copyWith(fontSize: 16, color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("LAST NAME", style: poppinsRegular.copyWith(fontSize: 12, color: ColorResources.TEXT_FORM_TEXT_COLOR)),
                                              Text(object.last_name ?? "", style: poppinsRegular.copyWith(fontSize: 16, color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Image.asset(
                                            Images.icon_menu,
                                            height: 24,
                                            width: 24,
                                          ),
                                        ),
                                      ]),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("EMAIL", style: poppinsRegular.copyWith(fontSize: 12, color: ColorResources.TEXT_FORM_TEXT_COLOR)),
                                            Text(object.email ?? "", style: poppinsRegular.copyWith(fontSize: 16, color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("INVITED BY", style: poppinsRegular.copyWith(fontSize: 12, color: ColorResources.TEXT_FORM_TEXT_COLOR)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width: 24,
                                                      height: 24,
                                                      child: CircleAvatar(
                                                        backgroundImage: AssetImage(object.email!),
                                                      )),
                                                  const SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text('${object.invited_by?.first_name ?? ""} ${object.invited_by?.last_name ?? ""}' , style: poppinsRegular.copyWith(fontSize: 16, color: Colors.black)),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("LAST UPDATED", style: poppinsRegular.copyWith(fontSize: 12, color: ColorResources.TEXT_FORM_TEXT_COLOR)),
                                              Text(getDate(object.created_on), style: poppinsRegular.copyWith(fontSize: 16, color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                      ]),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("STATUS", style: poppinsRegular.copyWith(fontSize: 12, color: ColorResources.TEXT_FORM_TEXT_COLOR)),
                                            Text(object.status ?? "", style: poppinsRegular.copyWith(fontSize: 16, color: Colors.black)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
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
      ),
    );
  }

  getDate(String? created_on) {
    if(created_on != null) {
      DateTime parseDate = inputFormatter.parse(created_on);
      var inputDate = DateTime.parse(parseDate.toString());
      var outputDate = outputFormatter.format(inputDate);
      return outputDate;
    } else {
      return "";
    }
  }
}
