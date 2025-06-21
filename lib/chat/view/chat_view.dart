import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ern_u/chat/viewmodel/chat_view_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../service/chat_service.dart';
import '../widgets/user_list_view.dart';
import 'chatroom_view.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  ChatViewModel chatViewModel = Get.put(ChatViewModel());
  ChatService chatService = ChatService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    final String currentUserId = chatViewModel.userId;

    return Scaffold(
      appBar: AppBar(
          title: const Text(
              "Chats",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24
            ),
          ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const UserListView(),

            const Padding(
              padding: EdgeInsets.only(bottom: 10.0, top: 20),
              child: Text("Messages", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            StreamBuilder<QuerySnapshot>(
              stream: chatViewModel.getChatRoomsStream(currentUserId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final chats = snapshot.data!.docs;

                if (chats.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("No messages yet."),
                  );
                }

                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final data = chat.data() as Map<String, dynamic>;
                    final userDetails = data['userDetails'] as Map<String, dynamic>;
                    final otherUserId = (data['users'] as List).firstWhere((id) => id != currentUserId);
                    final otherUser = userDetails[otherUserId];
                    final lastMessage = data['lastMessage'] ?? '';
                    final timestamp = data['lastUpdated'] as Timestamp?;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 6),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(otherUser['profileImageUrl'] ?? ''),
                      ),
                      title: Text(otherUser['name'] ?? 'User'),
                      subtitle: Text(
                        lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        timestamp != null
                            ? chatService.formatTimeAgo(timestamp.toDate())
                            : '',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      onTap: () {
                        final roomId = data['users'][0].compareTo(data['users'][1]) < 0
                            ? "${data['users'][0]}_${data['users'][1]}"
                            : "${data['users'][1]}_${data['users'][0]}";

                        Get.to(() => ChatRoomView(roomId: roomId));
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
