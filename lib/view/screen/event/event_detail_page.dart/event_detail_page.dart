import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joy_society/utill/common_helper_fn.dart';
import 'package:provider/provider.dart';
import '../../../../data/model/response/event_model.dart';
import '../../../../provider/event_provider.dart';
import '../../../../utill/color_resources.dart';
import '../../../../utill/custom_themes.dart';
import '../../../../utill/dropdown.dart';
import '../../../../utill/images.dart';
import '../../../basewidget/button/custom_button_secondary.dart';
import '../../../basewidget/web_view_screen.dart';
import '../chat_screeens/chat_ui.dart';
import '../chat_screeens/event_chat_screen.dart';
import '../chat_screeens/messageing_screen.dart';
import 'package:share_plus/share_plus.dart';

class EventDetailPage extends StatefulWidget {
  final EventModel? eventObj;
  const EventDetailPage({super.key, this.eventObj});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int? activeTab = 0;
  late TextEditingController dropDownCtrl;
  List<String> dropdownOptions = ["RSVP", "Maybe", "Going", "NotGoing"];

  @override
  void initState() {
    dropDownCtrl = TextEditingController(text: 'RSVP');
    if (widget.eventObj!.userStatus.isNotEmpty) {
      dropdownOptions.forEach((element) {
        if (element.toUpperCase() == widget.eventObj!.userStatus) {
          dropDownCtrl.text = element;
        }
      });
    }

    _tabController =
        TabController(length: 2, vsync: this, initialIndex: activeTab!);
    _tabController?.addListener(_onTabChanged);
    Future.delayed(Duration.zero, () {});
    super.initState();
  }

  void _onTabChanged() async {
    if (activeTab != _tabController!.index) {
      activeTab = _tabController!.index;

      switch (activeTab) {
        case 0:
          break;
        case 1:
          break;
        case 2:
          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Image.asset(
                Images.logo_with_name_image,
                height: 40,
                width: 40,
              ),
              const SizedBox(width: 10),
              const SizedBox(width: 10),
              Text(
                "Event Details",
                style: poppinsBold.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          elevation: 0.5,
          backgroundColor: ColorResources.WHITE,
        ),
        body: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                    Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                                color: ColorResources.GRAY_BUTTON_BG_COLOR)),
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder,
                          fit: BoxFit.cover,
                          image: widget.eventObj!.event_image!,
                          imageErrorBuilder: (c, o, s) => Image.asset(
                            Images.logo_with_name_image,
                            fit: BoxFit.cover,
                          ),
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Helper.getDateTime(widget.eventObj!.start_datetime),
                          style: poppinsBold.copyWith(
                              fontSize: 12,
                              color: ColorResources.DARK_GREEN_COLOR),
                        ),
                        Text(
                          "-",
                          style: poppinsBold.copyWith(
                              fontSize: 12,
                              color: ColorResources.DARK_GREEN_COLOR),
                        ),
                        Text(
                          Helper.getDateTime(widget.eventObj!.end_datetime),
                          maxLines: 4,
                          style: poppinsBold.copyWith(
                              fontSize: 12,
                              color: ColorResources.DARK_GREEN_COLOR),
                        ),
                      ],
                    ),
                    Text(
                      widget.eventObj!.title!,
                      style: poppinsBold.copyWith(
                          fontSize: 18, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Zoom Meeting",
                      style: poppinsRegular.copyWith(
                          fontSize: 14, color: ColorResources.textPrimaryColor),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Dropdown(
                              height: 50,
                              fontSize: 14,
                              containerColor: ColorResources.DARK_GREEN_COLOR,
                              // height: 35,
                              //width: 50,
                              dropdownValue: dropDownCtrl.text,
                              item: dropdownOptions.map((e) => e).toList(),
                              title: "",
                              onChanged: (newValue) {
                                setState(() {
                                  dropDownCtrl.text = newValue;
                                });
                                Provider.of<EventProvider>(context,
                                        listen: false)
                                    .updateEvent("/event/member/update/",
                                        widget.eventObj!.id, dropDownCtrl.text);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CustomButtonSecondary(
                            bgColor: ColorResources.DARK_GREEN_COLOR,
                            textColor: ColorResources.WHITE,
                            isCapital: false,
                            height: 50,
                            fontSize: 14,
                            buttonText: "Join",
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => WebViewScreen(
                                            url: widget.eventObj!.zoom_link,
                                          )));
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CustomButtonSecondary(
                            bgColor: ColorResources.DARK_GREEN_COLOR,
                            textColor: ColorResources.WHITE,
                            isCapital: false,
                            height: 50,
                            fontSize: 14,
                            buttonText: "Invite",
                            onTap: () async {
                              _onShare(context);
                              await Clipboard.setData(ClipboardData(
                                  text: widget.eventObj!.zoom_link!));

                              // copied successfully
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TabBar(
                      controller: _tabController,
                      labelColor: ColorResources.DARK_GREEN_COLOR,
                      unselectedLabelColor: ColorResources.GRAY_TEXT_COLOR,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: ColorResources.DARK_GREEN_COLOR,
                      tabs: const [
                        Tab(
                          child: Text(
                            'About Event',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Chat',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                      onTap: (index) {
                        // Push the EventChatScreen when the "Chat" tab is tapped
                        if (index == 1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EventChatScreen(
                                isfromEvent: true,
                                eventId: widget.eventObj!.id,
                              ),
                            ),
                          ).then((value) => {_tabController!.index = 0});
                        }
                      },
                    ),
                  ])),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: SingleChildScrollView(
                primary: true,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  margin: const EdgeInsets.only(top: 0, left: 16, right: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  height: MediaQuery.of(context).size.height *
                      1, // Set the desired height for the scrollable area
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.eventObj!.going} Members are going",
                            style: poppinsRegular.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorResources.TEXT_BLACK_COLOR),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${widget.eventObj!.NotGoing} Members are not going",
                            style: poppinsRegular.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorResources.TEXT_BLACK_COLOR),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${widget.eventObj!.going} Members are maybe",
                            style: poppinsRegular.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: ColorResources.TEXT_BLACK_COLOR),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Description",
                            style: poppinsRegular.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: ColorResources.TEXT_BLACK_COLOR),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: Text(
                              removeHtmlTags(widget.eventObj!.description!),
                              style: poppinsRegular.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorResources.TEXT_BLACK_COLOR),
                            ),
                          ),
                        ],
                      ),
                      // ChatScreen()
                      // MessagingScreen(),
                      // EventChatScreen(
                      //   isfromEvent: true,
                      //   eventId: widget.eventObj!.id,
                      // )
                    ],
                  ),
                )),
          )
        ]),
      ),
    );
  }

  _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(
      widget.eventObj!.zoom_link.toString(),
      subject: "Event Link",
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  String removeHtmlTags(String input) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return input.replaceAll(exp, '');
  }
}
