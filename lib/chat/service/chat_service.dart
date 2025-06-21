import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Generates a unique, consistent room ID for any pair of users.
  String getRoomId(String uid1, String uid2) {
    final sortedIds = [uid1, uid2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  /// Sends a text message to a given chat room.
  Future<void> sendMessage({
    required String roomId,
    required String text,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null || text.trim().isEmpty) return;

    final message = {
      'text': text.trim(),
      'senderId': currentUser.uid,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .add(message);
  }

  /// Returns a real-time stream of messages from a chat room.
  Stream<QuerySnapshot> getMessageStream(String roomId) {
    return _firestore
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Optional: Updates last message metadata for room preview lists
  Future<void> updateLastMessage({
    required String roomId,
    required String lastMessage,
  }) async {
    await _firestore.collection('chats').doc(roomId).update({
      'lastMessage': lastMessage,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<void> initRoomIfNeeded({
    required String roomId,
    required Map<String, dynamic> currentUser,
    required Map<String, dynamic> otherUser,
  }) async {
    final roomRef = _firestore.collection('chats').doc(roomId);
    final doc = await roomRef.get();

    if (!doc.exists) {
      await roomRef.set({
        'users': [currentUser['userId'], otherUser['userId']],
        'userDetails': {
          currentUser['userId']: {
            'name': currentUser['firstName'],
            'profileImageUrl': currentUser['profileImageUrl'],
          },
          otherUser['userId']: {
            'name': otherUser['firstName'],
            'profileImageUrl': otherUser['profileImageUrl'],
          },
        },
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }
  }
}
