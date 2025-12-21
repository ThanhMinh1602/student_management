import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blooket/app/data/model/question_set_model.dart';
// import model Assignment nếu cần

class QuestionService {
  final _firestore = FirebaseFirestore.instance;
  final CollectionReference _setRef = FirebaseFirestore.instance.collection('question_sets');

  // --- GET ---
  Stream<List<QuestionSetModel>> getQuestionSetsStream() {
    return _setRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => QuestionSetModel.fromSnapshot(doc)).toList());
  }

  // --- ADD (Thêm bộ đề mới) ---
  Future<bool> createQuestionSet(String name) async {
    try {
      await _setRef.add({
        'name': name,
        'questionCount': 0, // Mới tạo thì chưa có câu hỏi nào
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error creating set: $e");
      return false;
    }
  }

  // --- UPDATE (Sửa tên bộ đề) ---
  Future<bool> updateQuestionSet(String id, String newName) async {
    try {
      await _setRef.doc(id).update({
        'name': newName,
      });
      return true;
    } catch (e) {
      print("Error updating set: $e");
      return false;
    }
  }

  // --- DELETE (Xóa bộ đề) ---
  Future<bool> deleteQuestionSet(String id) async {
    try {
      // Lưu ý: Trong thực tế bạn nên xóa cả các câu hỏi con trong sub-collection (nếu có)
      await _setRef.doc(id).delete();
      return true;
    } catch (e) {
      print("Error deleting set: $e");
      return false;
    }
  }
  // --- GIAO BÀI (ASSIGN) ---
  Future<bool> createAssignment(AssignmentModel assignment) async {
    try {
      await _firestore.collection('assignments').add(assignment.toJson());
      return true;
    } catch (e) {
      print("Error assigning task: $e");
      return false;
    }
  }
}