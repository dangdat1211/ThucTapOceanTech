// lib/services/todo_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/work_model.dart';

class WorkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo công việc mới
  Future<void> createWork(WorkModel work) async {
    try {
      await _firestore.collection('works').add(work.toMap());
    } catch (e) {
      throw Exception('Could not create work: $e');
    }
  }

  // Lấy danh sách công việc theo userId
  Stream<List<Map<String, dynamic>>> getWorks(String userId) {
    return _firestore
        .collection('works')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'documentId': doc.id,
          'work': WorkModel.fromMap(doc.data()),
        };
      }).toList();
    });
  }

  // Cập nhật công việc
  Future<void> updateWork(String documentId, WorkModel work) async {
    try {
      await _firestore
          .collection('works')
          .doc(documentId)
          .update(work.toMap());
    } catch (e) {
      throw Exception('Could not update work: $e');
    }
  }

  // Xóa công việc
  Future<void> deleteWork(String workId) async {
    try {
      await _firestore.collection('works').doc(workId).delete();
    } catch (e) {
      throw Exception('Could not delete work: $e');
    }
  }
}