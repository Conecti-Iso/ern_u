import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../viewmodel/chat_view_model.dart';

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    ChatViewModel chatViewModel = Get.put(ChatViewModel());
    return  Container(
      color: Colors.red,
      margin: const EdgeInsets.only(bottom: 20, top: 20),
      width: double.infinity,
      height: height * .1,
      child: Obx(() {
        return ListView.builder(
            itemCount: chatViewModel.users.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (snapshot, index) {

              final user = chatViewModel.users[index];
              final imageUrl = user['profileImageUrl'] ?? '';
              final username = user['firstName'] ?? 'User';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    // Handle user tap
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                        backgroundImage:
                        imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                        child: imageUrl.isEmpty
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        username,
                        style: const TextStyle(
                            fontSize: 12,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      }),
    );
  }
}
