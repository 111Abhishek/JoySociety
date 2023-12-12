import 'package:flutter/material.dart';
import 'package:joy_society/utill/color_resources.dart';

import '../../../basewidget/show_custom_snakbar.dart';
import '../widgets/message_feild_widget.dart';
import '../widgets/reciever_message_widget.dart';
import '../widgets/sender_message_widget.dart';

class MessagingScreen extends StatefulWidget {
  MessagingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  late Size size;
  late TextEditingController _messageController;
  List<dynamic> chatMessages = [];

  // String get noInternetMsg => null;

  @override
  void initState() {
    _messageController = TextEditingController();
    // _getMessagesList();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: ColorResources.WHITE,
        resizeToAvoidBottomInset: true,
        // appBar: AppBarWidgetHeading(
        //   titleText: "Messages",
        //   actionIcons: [
        //     IconButton(
        //         tooltip: "Refresh chat",
        //         onPressed: () => _getMessagesList(),
        //         icon: Icon(Icons.refresh_rounded, color: AppColor.darkerBlue))
        //   ],
        // ),
        body: Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: chatMessages.length,
              itemBuilder: ((context, index) {
                if (chatMessages.isNotEmpty) {
                  if (chatMessages[index].isSender!) {
                    return SenderMessageWidget(
                        senderMessage: chatMessages[index].message!);
                  } else {
                    return ReceiverMessageWidget(
                        receiverMessage: chatMessages[index].message!);
                  }
                } else {
                  return const Center(child: Text('No messages found'));
                }
              })),
        ),
        bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: MessageFieldWidget(
              messageController: _messageController,
              onSendBtn: () {
                if (_messageController.text.isNotEmpty)
                  ;
                //  _sendMessage(_messageController.text);
                else
                  showCustomSnackBar(
                      "Please enter some message to send.", context);
              },
            )));
  }

//   _sendMessage(String messageTxt) async {
//     try {
//       SendMsgRequestModel sendMsgRequestModel = SendMsgRequestModel(
//           bookingId: widget.chatData!.bookingId!,
//           quotationId: widget.chatData!.quotationId!,
//           message: messageTxt,
//           receiver: widget.chatData!.receiverId!);

//       CommanResponse messageResponse =
//           await CreateMsgService.sendMsg(sendMsgRequestModel);

//       //Closing the keyboard
//       FocusManager.instance.primaryFocus?.unfocus();
//       //Refreshing the message controller
//       _messageController.clear();

//       switch (messageResponse.apiStatus) {
//         case ApiStatus.NO_INTERNET:
//           Helper.showSnackBar(context, noInternetMsg);
//           break;

//         case ApiStatus.REQUEST_SUCCESS:
//           _getMessagesList();
//           break;

//         case ApiStatus.REQUEST_FAILURE:
//           Helper.showSnackBar(context, messageResponse.message);
//           break;

//         case ApiStatus.NO_DATA_AVAILABLE:
//           Helper.showSnackBar(context, noDataFoundMsg);
//           break;

//         default:
//           break;
//       }
//     } catch (e) {
//       log('Exception occurred in send message API :: $e');
//     }
//   }

//   _getMessagesList() async {
//     try {
//       InboxDetailRequestModel inboxDetailRequestModel = InboxDetailRequestModel(
//           bookingId: widget.chatData!.bookingId!,
//           quotationId: widget.chatData!.quotationId!,
//           bookingName: widget.chatData!.bookingName!);

//       CommanResponse commanResponse = await InboxDetailService.getMessages(
//           inboxDetailRequestModel,
//           pageStart: 0,
//           pageLength: 1000);

//       switch (commanResponse.apiStatus) {
//         case ApiStatus.NO_INTERNET:
//           Helper.showSnackBar(context, noInternetMsg);
//           break;
//         case ApiStatus.REQUEST_SUCCESS:
//           chatMessages = commanResponse.message;
//           chatMessages = chatMessages.reversed.toList();
//           setState(() {});
//           break;
//         case ApiStatus.REQUEST_FAILURE:
//           Helper.showSnackBar(context, commanResponse.message);
//           break;
//         case ApiStatus.NO_DATA_AVAILABLE:
//           Helper.showSnackBar(context, noDataFoundMsg);
//           break;
//         default:
//           break;
//       }
//     } catch (e) {
//       log('Exception occurred in messgae list :: $e');
//     }
//   }
// }
}
