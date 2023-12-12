import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/data/model/response/member_model.dart';
import 'package:joy_society/localization/language_constants.dart';
import 'package:joy_society/utill/custom_themes.dart';
import 'package:joy_society/utill/dimensions.dart';
import 'package:joy_society/utill/images.dart';
import 'package:joy_society/utill/js_data_provider.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:joy_society/view/screen/members/manageMembers/manage_members_screen.dart';
import 'package:joy_society/view/screen/members/memberList/adapter/list_member_adapter.dart';
import 'package:joy_society/view/screen/members/memberList/adapter/list_member_filter_adapter.dart';
import 'package:joy_society/view/screen/profile/profile_view_details_screen.dart';

class MembersListScreen extends StatefulWidget {
  @override
  _MembersListScreenState createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  late BuildContext context;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  GlobalKey<ScaffoldMessengerState>();

  void onItemClick(int index, MemberModel obj) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileViewDetailsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    List<MemberModel> items = getPeopleData();

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 48, left: 8),
            child: Row(children: [
              CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              Image.asset(Images.logo_with_name_image,
                  height: 40, width: 40),
              const SizedBox(width: 10),
              Text(getTranslated('MEMBERS', context),
                  style: poppinsBold.copyWith(
                      fontSize: 20, color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded (
            flex: 1,
            child: ListMemberFilterAdapter(items, onItemClick)
                .getView(),
          ),
          Expanded(
            flex: 7,
            child: ListMemberAdapter(items, onItemClick).getView(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Dimensions.MARGIN_SIZE_DEFAULT,
                        vertical: Dimensions.MARGIN_SIZE_SMALL),
                    child: CustomButton(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ManageMembersScreen()));
                        },
                        buttonText: getTranslated('MANAGE', context)),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
