

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/HomeScreen';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
        children: [
          SizedBox(height: 57),
          Text("Home"),
        ]
      ),
    );
  }

}