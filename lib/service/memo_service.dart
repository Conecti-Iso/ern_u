import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/memo_model.dart';

class MemoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // creating a new memo
  Future<String> createMemo({
    required String memoTitle,
    required String from,
    required String memoDescription,
    required String memoFileUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');
      final memoData = Memo(
        id: '',
        memoTitle: memoTitle,
        from: from,
        memoDescription: memoDescription,
        memoFileUrl: memoFileUrl,
        viewCount: 0,
        status: 'not viewed',
        createdBy: user.uid,
        createdAt: DateTime.now()

      ).toMap();

      final docRef = await _firestore.collection('memos').add(memoData);
      return docRef.id;
    } catch (e) {
      print('Error creating memo: $e');
      throw e;
    }
  }

  /// get memos created
  Stream<List<Memo>> getMemos() {
    return _firestore.collection('memos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Memo.fromMap(doc.data(), doc.id)).toList();
    });
  }


  /// increment memo
  Future<void> incrementViewCount(String memoId) async {
    try {
      await _firestore.collection('memos').doc(memoId).update({
        'viewCount': FieldValue.increment(1),
      });
    } catch (e) {
      print("Failed to increment view count: $e");
    }
  }


  /// update memo status
  Future<void> updateMemoStatus(String memoId, String status) async {
    await _firestore.collection('memos').doc(memoId).update({'status': status});
  }

  /// get memos for self
  Stream<List<Memo>> getMyMemos() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('memos')
        .where('createdBy', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Memo.fromMap(doc.data(), doc.id)).toList();
    });
  }

  /// delete memo for self
  Future<void> deleteMemo(String memoId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      await _firestore.collection('memos').doc(memoId).delete();
    } catch (e) {
      print('Error deleting memo: $e');
      throw e;
    }
  }


  /// update memo for self
  Future<void> updateMemo({
    required String memoId,
    required String memoTitle,
    required String from,
    required String memoDescription,
    required String memoFileUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      await _firestore.collection('memos').doc(memoId).update({
        'memoTitle': memoTitle,
        'from': from,
        'memoDescription': memoDescription,
        'memoFileUrl': memoFileUrl,
      });
    } catch (e) {
      print('Error updating memo: $e');
      throw e;
    }
  }

  Future<DocumentSnapshot> getMemoById(String memoId) {
    return _firestore.collection('memos').doc(memoId).get();
  }
}