import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/utill/color_resources.dart';
import 'package:joy_society/view/basewidget/button/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utill/custom_themes.dart';
import '../../../utill/images.dart';

class TermsAnsConditionPage extends StatefulWidget {
  const TermsAnsConditionPage({super.key});

  @override
  State<TermsAnsConditionPage> createState() => _TermsAnsConditionPageState();
}

class _TermsAnsConditionPageState extends State<TermsAnsConditionPage> {
  
  Future<void>? _launched;

  final String _mail = "info@joysociety.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.of(context).pop(),
                color: Colors.black,
              ),
              Image.asset(Images.logo_with_name_image, height: 40, width: 40),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Terms and Condition",
                      style: poppinsBold.copyWith(
                          fontSize: 16, color: Colors.black)),
                ],
              )
            ],
          )),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "      Terms of Use \n (Governing Bylaws)",
                style: MyTxtStyle().generalStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              const SizedBox(height: 15),
              Text(
                "USE OF CONTENT",
                style: MyTxtStyle().generalStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
              Container(
                //width: Me,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                    color: ColorResources.WHITE,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _descTxtSection(
                        "All content shared in the Joy Society Membership Community is for personal use only. External sharing of member profile information, lead generation materials, or private downloads are forbidden. Selling, plagiarizing, or circumventing security measures to steal content is also forbidden.The Joy Society is protected from legal disputes regarding disagreeable opinions expressed by members within the community. The Digital Millennium Copyright Act expressly protects the Joy Society from legal disputes resulting from third-party user-generated content.Once content is submitted to the Joy Society Membership Community, it becomes property of the community, not solely the member nor the organization, but all those with a vested interest. By contributing content to the Joy Society, members grant a royalty-free and irrevocable right to the Joy Society to publish, distribute or revise that content (with an exception to the disclosure of personal or private information)."),
                    const SizedBox(height: 40),
                    _titleTxtSection("CONTENT MANAGEMENT"),
                    const SizedBox(height: 10),
                    _descTxtSection(
                      "Content largely represents the collective work of individuals with varied backgrounds, viewpoints, and ideologies. In choosing to use the Joy Society Membership Community, members acknowledge that instances of extreme disagreement might arise. While these instances should not be viewed as a personal attack or cause contention between members, grievances can occur. These Terms of Use reinforce that the Joy Society cannot be held liable for disputes resulting from content posted.For more information about appropriate behavior within the community, please see the Joy Society Community Guidelines (above). These Terms of Use emphasize that members are fully responsible for any negative actions resulting from their contributions. The Joy Society has no obligation to review content before it is submitted, but may edit or remove content if it is deemed to violate community guidelines, disobey laws or regulations, or put into question the integrity of the Joy Society or its members.",
                    ),
                    const SizedBox(height: 40),
                    _titleTxtSection("DISPUTES BETWEEN USERS"),
                    const SizedBox(height: 10),
                    _descTxtSection(
                      "The Joy Society has no obligation to mediate or resolve disputes between community members. Joy Society administrators reserve the right to act under their discretion, whether it be taking an active role in a disagreement, modifying or deleting content, or removing the offending individuals’ access to the community altogether.",
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Joy Society Community Guidelines (Code of Conduct for Members)",
                      style: MyTxtStyle().generalStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    _descTxtSection(
                      "Welcome to the Joy Society community! This is a safe space to engage with other professionals seeking wellness.\nThe Joy Society Membership Community is self-moderated, which means that the community moderates itself, with the help of a team of online community moderators. There’s no time lag when community members post, but they can mark certain posts as inappropriate, which notifies admins and temporarily removes the post for moderation.\n\n We want everyone who is part of our community to have their voice heard. We encourage your feedback and aim to respond to your comments as soon as possible. While we do moderate this community, we welcome open discussion. To help everyone enjoy our community, we ask that when you post and engage with other members, you keep in mind the following.",
                    ),
                    const SizedBox(height: 10),
                    _descTxtSection(
                        "1. We don’t allow defamatory, indecent, offensive, profane, discriminatory, misleading, unlawful, or threatening comments."),
                    const SizedBox(height: 10),
                    _descTxtSection(
                        "2. Personal attacks, name-calling, trolling, and abuse will not be tolerated."),
                    const SizedBox(height: 10),
                    _descTxtSection(
                        "3. Messages and posts should not contain promotional material, special offers, job offers, product announcements, or solicitation for services. Joy Society reserves the right to remove such messages and potentially ban sources of those solicitations."),
                    const SizedBox(height: 10),
                    _descTxtSection(
                        "4. We reserve the right to delete comments at our discretion and block any repeat offenders. We will remove content that is fraudulent, deceptive, or misleading."),
                    const SizedBox(height: 10),
                    _descTxtSection(
                        "5. Coordinated group attacks will not be tolerated."),
                    const SizedBox(height: 10),
                    _descTxtSection(
                        "6. Respect that other people in the community have had different life experiences and may have a different perspective than yours. We welcome different viewpoints."),
                    const SizedBox(height: 10),
                    _descTxtSection(
                        "7. Our community is a public place. Don’t post personal information that you would not be comfortable sharing with a stranger. We recommend that you don’t post any information that may identify you or anyone else, such as your address, email address, or phone number."),
                    const SizedBox(height: 10),
                    _descTxtSection(
                      "8. Please be mindful of the content you choose to share. The purpose of this space is to facilitate connections and relationships among members, and allow us to provide information, education, and resources. Please ensure that what you are posting and sharing is relevant to our mission.",
                    ),
                    const SizedBox(height: 40),
                    _descTxtSection(
                        "If you have a question about these guidelines or a service we offer, please get in touch with the “Joy Society Admin” account, or send an email to info@joysociety.com."),
                    // InkWell(
                    //   onTap: () => {
                    //     setState(() {
                    //     _launched =   _openUrl('mailto:$_mail');
                    //     })
                    //   },
                    //   child: Text(
                    //     "info@joysociety.com",
                    //     style: MyTxtStyle().generalStyle(
                    //         fontSize: 16,
                    //         decoration: TextDecoration.underline,
                    //         fontWeight: FontWeight.w400,
                    //         color: const Color.fromARGB(255, 11, 20, 51)),
                    //   ),
                    // ),
                       const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    CustomButton(
                      buttonText: "Agree",
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleTxtSection(String title) => Text(
        title,
        style: MyTxtStyle().generalStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111833)),
      );

  Widget _subTitleTxtSection(String title) => Text(
        title,
        style: MyTxtStyle().generalStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111833)),
      );

  Widget _descTxtSection(String desc, {bool haveTxtHeight = false}) => Text(
        desc,
        style: MyTxtStyle().generalStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF3D476A)),
      );
}

Future<void> _openUrl(String email) async {
  var url = Uri.parse(email);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

class MyTxtStyle {
  TextStyle topMenuItemStyle(
          {color = ColorResources.WHITE,
          fontSize = 14,
          fontWeight = FontWeight.normal}) =>
      TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight);

  TextStyle generalStyle(
          {color = ColorResources.WHITE,
          fontSize = 14.0,
          decoration = TextDecoration.none,
          fontStyle = FontStyle.normal,
          fontWeight = FontWeight.normal}) =>
      TextStyle(
          fontFamily: 'HKGrotesk',
          color: color,
          decoration: decoration,
          fontSize: fontSize.toDouble(),
          fontStyle: fontStyle,
          fontWeight: fontWeight);
}
