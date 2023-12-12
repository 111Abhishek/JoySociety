import 'package:flutter/material.dart';
import 'package:joy_society/utill/color_resources.dart';

class MessageFieldWidget extends StatelessWidget {
  final TextEditingController messageController;
  final Function onSendBtn;
  const MessageFieldWidget(
      {Key? key, required this.messageController, required this.onSendBtn})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        elevation: 0,
        child: SizedBox(
            height: 70,
            width: 200,
            child: Row(
              children: [
                const Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Icon(
                      Icons.account_circle_sharp,
                      size: 30,
                      color: ColorResources.LIGHT_SKY_BLUE,
                    )),
                Expanded(
                    child: TextFormField(
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                  controller: messageController,
                  maxLines: 100,
                  cursorColor: Colors.black,
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Add message here...',
                    hintStyle:
                        const TextStyle(fontSize: 16, color: Colors.grey),
                    focusColor: Colors.grey.shade300,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 15),
                    border: InputBorder.none,
                  ),
                )),
                Container(
                  height: 50,
                  width: 70,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: const BoxDecoration(
                      color: ColorResources.WHITE,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Row(
                    children: [
                      const InkWell(
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.image,
                              ))),
                      InkWell(
                        child: const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.send,
                            )),
                        onTap: () => onSendBtn(),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
