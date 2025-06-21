import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatViewModel extends GetxController {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final usersSnapshot = await _fireStore.collection('users').get();
      users.value = usersSnapshot.docs.map((doc) => doc.data()).toList();
      print("User 1  ================ ${users[0]}");
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

}