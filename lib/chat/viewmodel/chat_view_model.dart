import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ern_u/chat/service/chat_service.dart';
import 'package:ern_u/chat/view/chatroom_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatViewModel extends GetxController {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final ChatService chatService = ChatService();
  final RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[].obs;
  var authUser = <String, dynamic>{}.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _fetchUsers();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _fireStore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        authUser.value = userDoc.data()!;
      }
    }
  }

  Future<void> _fetchUsers() async {
    try {
      final usersSnapshot = await _fireStore.collection('users').get();
      users.value = usersSnapshot.docs.map((doc) => doc.data()).toList();
      Get.log("User details ${users[0]}");
    } catch (e) {
      Get.log('Error fetching users: $e');
    }
  }

  Future<void> openChatroom(Map<String, dynamic> otherUser ) async {
    try {
      String roomId = chatService.getRoomId(authUser["userId"], otherUser["userId"]);
      await chatService.initRoomIfNeeded(roomId: roomId, currentUser: authUser, otherUser: otherUser);
      Get.to(() => ChatRoomView(roomId: roomId));
    } catch (e) {
      Get.log('Error opening chatroom: $e');
    }
  }


}