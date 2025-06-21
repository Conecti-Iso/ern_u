import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ern_u/chat/viewmodel/chat_view_model.dart';
import 'package:ern_u/chat/widgets/user_tile.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../widgets/user_list_view.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ChatViewModel chatViewModel = Get.put(ChatViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double size = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            //List Users
            const UserListView(),

            const Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text("Messages"),
            ),

            UserTile(),

            UserTile(),

            UserTile(),


          ],
        ),
      )
    );
  }
}
