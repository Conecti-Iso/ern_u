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

      ).toMap();

      final docRef = await _firestore.collection('memos').add(memoData);
      return docRef.id;
    } catch (e) {
      print('Error creating memo: $e');
      throw e;
    }
  }

  Stream<List<Memo>> getMemos() {
    return _firestore.collection('memos').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Memo.fromMap(doc.data(), doc.id)).toList();
    });
  }


  Future<void> incrementViewCount(String memoId) async {
    // await _memosCollection.doc(memoId).update({
    await _firestore.doc(memoId).update({
      'viewCount': FieldValue.increment(1),
    });
  }


  Future<void> updateMemoStatus(String memoId, String status) async {
    await _firestore.collection('memos').doc(memoId).update({'status': status});
  }

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
}