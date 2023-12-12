import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:joy_society/utill/color_resources.dart';

import '../../../utill/custom_themes.dart';
import '../../../utill/images.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                  Text("Invoice Settings",
                      style: poppinsBold.copyWith(
                          fontSize: 16, color: Colors.black)),
                  Text(
                    "Save invoices",
                    style: poppinsSemiBold.copyWith(
                        fontSize: 12, color: Colors.black54),
                  )
                ],
              )
            ],
          )),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Invoices Information',
            style: poppinsMedium.copyWith(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(
            height: 20,
          ),
          Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (){},
                splashColor: ColorResources.DARK_GREEN_COLOR.withOpacity(0.7),
                child: Ink(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: ColorResources.DARK_GREEN_COLOR,
                    ),
                    child: Text(
                      'Save',
                      style: poppinsRegular.copyWith(
                          fontSize: 14, color: Colors.white),
                    )),
              ))
        ],
      )),
    );
  }
}
