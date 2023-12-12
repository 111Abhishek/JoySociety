import 'package:flutter/material.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/js_data_provider.dart';
import 'package:joy_society/view/screen/members/sentInvites/widget/top_data_send_invites_model.dart';

class TopDataSentInviteComponent extends StatelessWidget {
  List<TopDataSendInvitesModel> topServiceList = getSentInvitesTopData();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1))
                    // changes position of shadow
                  ],
                ),
                child: Column(
                  children: [
                    Text(topServiceList[0].data, style: poppinsBold.copyWith(fontSize: 24, color: Colors.black)),
                    Text(topServiceList[0].title, style: poppinsRegular.copyWith(fontSize: 12, color: Colors.black)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1))
                    // changes position of shadow
                  ],
                ),
                child: Column(
                  children: [
                    Text(topServiceList[0].data, style: poppinsBold.copyWith(fontSize: 24, color: Colors.black)),
                    Text(topServiceList[0].title, style: poppinsRegular.copyWith(fontSize: 12, color: Colors.black)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1))
                    // changes position of shadow
                  ],
                ),
                child: Column(
                  children: [
                    Text(topServiceList[0].data, style: poppinsBold.copyWith(fontSize: 24, color: Colors.black)),
                    Text(topServiceList[0].title, style: poppinsRegular.copyWith(fontSize: 12, color: Colors.black)),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1))
                    // changes position of shadow
                  ],
                ),
                child: Column(
                  children: [
                    Text(topServiceList[0].data, style: poppinsBold.copyWith(fontSize: 24, color: Colors.black)),
                    Text(topServiceList[0].title, style: poppinsRegular.copyWith(fontSize: 12, color: Colors.black)),
                  ],
                ),
              ),
            ),

          ]),
    );
  }
}
