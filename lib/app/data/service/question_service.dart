import 'package:blooket/app/data/model/assignment_model.dart';
import 'package:blooket/app/data/model/question_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blooket/app/data/model/question_set_model.dart';

class QuestionService {
  final _firestore = FirebaseFirestore.instance;
  
  // Reference tới collection cha
  final CollectionReference _setRef = FirebaseFirestore.instance.collection('question_sets');

  // --- 1. QUẢN LÝ BỘ ĐỀ (CHA) ---

  // Lấy danh sách bộ đề
  Stream<List<QuestionSetModel>> getQuestionSetsStream() {
    return _setRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => QuestionSetModel.fromSnapshot(doc)).toList());
  }

  // Thêm bộ đề mới
  Future<bool> createQuestionSet(String name) async {
    try {
      await _setRef.add({
        'name': name,
        'questionCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error creating set: $e");
      return false;
    }
  }

  // Sửa tên bộ đề
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

  // Xóa bộ đề
  Future<bool> deleteQuestionSet(String id) async {
    try {
      // Lưu ý: Firestore KHÔNG tự động xóa sub-collection khi xóa doc cha.
      // Tuy nhiên, trên UI app sẽ không thấy nữa.
      // Để xóa sạch hoàn toàn (cả câu hỏi con), bạn cần dùng Cloud Function hoặc xóa thủ công từng câu hỏi trước.
      await _setRef.doc(id).delete();
      return true;
    } catch (e) {
      print("Error deleting set: $e");
      return false;
    }
  }

  // --- 2. GIAO BÀI (ASSIGN) ---
  // (Giữ nguyên vì assignments thường là collection riêng biệt để dễ query)
  Future<bool> createAssignment(AssignmentModel assignment) async {
    try {
      await _firestore.collection('assignments').add(assignment.toJson());
      return true;
    } catch (e) {
      print("Error assigning task: $e");
      return false;
    }
  }

  // --- 3. QUẢN LÝ CÂU HỎI CON (SUB-COLLECTION) ---

  // Lấy danh sách câu hỏi (Đi vào trong doc của bộ đề -> vào collection questions)
  Stream<List<QuestionModel>> getQuestionsStream(String setId) {
    return _setRef
        .doc(setId) // Chọn bộ đề cha
        .collection('questions') // Vào sub-collection
        .orderBy('createdAt', descending: false) // Sắp xếp theo ngày tạo
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => QuestionModel.fromSnapshot(doc)).toList());
  }

  // Thêm câu hỏi vào Sub-collection
  Future<bool> addQuestion(QuestionModel question) async {
    try {
      // 1. Thêm câu hỏi vào sub-collection 'questions' của bộ đề 'setId'
      await _setRef
          .doc(question.setId)
          .collection('questions')
          .add(question.toJson());
      
      // 2. Update lại số lượng câu hỏi ở bộ đề cha (Question Set)
      await _setRef.doc(question.setId).update({
        'questionCount': FieldValue.increment(1)
      });
      
      return true;
    } catch (e) {
      print("Add question error: $e");
      return false;
    }
  }

  // Xóa câu hỏi trong Sub-collection
  Future<bool> deleteQuestion(String questionId, String setId) async {
    try {
      // 1. Tìm đúng đường dẫn để xóa
      await _setRef
          .doc(setId)
          .collection('questions')
          .doc(questionId)
          .delete();
      
      // 2. Giảm số lượng câu hỏi ở bộ đề cha
      await _setRef.doc(setId).update({
        'questionCount': FieldValue.increment(-1)
      });
      
      return true;
    } catch (e) {
      print("Delete question error: $e");
      return false;
    }
  }

  // Cập nhật câu hỏi trong Sub-collection
  Future<bool> updateQuestion(QuestionModel question) async {
    try {
      // Tìm đúng đường dẫn: question_sets -> setId -> questions -> questionId
      await _setRef
          .doc(question.setId)
          .collection('questions')
          .doc(question.id)
          .update(question.toJson());
          
      return true;
    } catch (e) {
      print("Update error: $e");
      return false;
    }
  }
}