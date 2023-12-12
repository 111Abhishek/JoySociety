// import 'package:flutter/material.dart';
// import 'package:joy_society/provider/event_provider.dart';
// import 'package:provider/provider.dart';

// import '../../../../data/model/response/event_model.dart';

// class ChatScreen extends StatefulWidget {
//   final EventModel? eventObj;
//   const ChatScreen({super.key , this.eventObj});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {


  
//   List<Message> messages = [
//     Message(sender: "me", text: "hi", time: "5.25", avatar: "ntg"),
//     Message(sender: "client", text: "hi", time: "5.25", avatar: "ntg")
//   ];
//   TextEditingController textEditingController = TextEditingController();

//   @override
//   void initState() {
//       Provider.of<EventProvider>(context, listen: false)
//         .createChatChannel(widget.eventObj!.id);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               reverse: true,
//               // primary: false,
//               physics: const ScrollPhysics(),
//               //  shrinkWrap: true,
//               itemCount: messages.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final message = messages[index];
//                 final isMe = message.sender == 'me';

//                 return Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10.0),
//                   child: Row(
//                     mainAxisAlignment:
//                         isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//                     children: [
//                       if (!isMe) ...[
//                         CircleAvatar(
//                           backgroundImage: AssetImage(message.avatar),
//                         ),
//                         const SizedBox(width: 10.0),
//                       ],
//                       Container(
//                         decoration: BoxDecoration(
//                           color: isMe ? Colors.blue : Colors.grey.shade300,
//                           borderRadius: BorderRadius.only(
//                             topLeft: const Radius.circular(20.0),
//                             topRight: const Radius.circular(20.0),
//                             bottomLeft: isMe
//                                 ? const Radius.circular(20.0)
//                                 : const Radius.circular(0),
//                             bottomRight: isMe
//                                 ? const Radius.circular(0)
//                                 : const Radius.circular(20.0),
//                           ),
//                         ),
//                         padding: const EdgeInsets.all(10.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               message.sender,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: isMe ? Colors.white : Colors.black,
//                               ),
//                             ),
//                             const SizedBox(height: 5.0),
//                             Text(
//                               message.text,
//                               style: TextStyle(
//                                 color: isMe ? Colors.white : Colors.black,
//                               ),
//                             ),
//                             const SizedBox(height: 5.0),
//                             Text(
//                               message.time,
//                               style: TextStyle(
//                                 fontSize: 10.0,
//                                 color: isMe ? Colors.white : Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       if (isMe) ...[
//                         const SizedBox(width: 10.0),
//                         CircleAvatar(
//                           backgroundImage: AssetImage(message.avatar),
//                         ),
//                       ],
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                     controller: textEditingController,
//                     decoration: const InputDecoration(
//                       hintText: 'Type a message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                     icon: const Icon(Icons.emoji_events), onPressed: () {}),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () {
//                     if (textEditingController.text.isNotEmpty) {
//                       setState(() {
//                         final newMessage = Message(
//                           sender: 'me',
//                           text: textEditingController.text,
//                           time: '10:00 AM',
//                           avatar: 'assets/my_avatar.png',
//                         );
//                         messages.insert(0, newMessage);
//                         textEditingController.clear();
//                       });
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Message {
//   final String sender;
//   final String text;
//   final String time;
//   final String avatar;

//   Message({
//     required this.sender,
//     required this.text,
//     required this.time,
//     required this.avatar,
//   });
// }
