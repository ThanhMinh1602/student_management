import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blooket/app/data/model/student_model.dart';

class StudentService {
  final CollectionReference _studentRef = FirebaseFirestore.instance.collection(
    'students',
  );

  // 1. Lấy TOÀN BỘ danh sách HỌC VIÊN (Bỏ qua Admin)
  Stream<List<StudentModel>> getAllStudentsStream() {
    return _studentRef
        .where('role', isEqualTo: 'student') // 🔥 CHỈ LẤY ROLE STUDENT
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => StudentModel.fromSnapshot(doc))
              .toList(),
        );
  }

  // 2. Lấy danh sách học viên THEO LỚP
  Stream<List<StudentModel>> getStudentsByClassStream(String classId) {
    return _studentRef
        .where('classId', isEqualTo: classId)
        .where('role', isEqualTo: 'student') // 🔥 Đảm bảo chỉ lấy học viên
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => StudentModel.fromSnapshot(doc))
              .toList(),
        );
  }

  // 3. Đếm số học viên trong lớp
  Stream<int> getStudentCountByClassStream(String classId) {
    return _studentRef
        .where('classId', isEqualTo: classId)
        .where('role', isEqualTo: 'student') // 🔥 Chỉ đếm học viên
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  // --- CÁC HÀM GHI DỮ LIỆU (WRITE) GIỮ NGUYÊN ---

  // Gán học viên vào lớp
  Future<bool> assignStudentToClass(String studentId, String classId) async {
    try {
      await _studentRef.doc(studentId).update({'classId': classId});
      return true;
    } catch (e) {
      print("Error assigning student: $e");
      return false;
    }
  }

  // Xóa học viên khỏi lớp
  Future<bool> removeStudentFromClass(String studentId) async {
    try {
      await _studentRef.doc(studentId).update({'classId': ""});
      return true;
    } catch (e) {
      return false;
    }
  }

  // Thêm tài khoản mới
  Future<bool> addStudent({
    required String fullName,
    required String username,
    String role = 'student', 
    String password = '123456',
  }) async {
    try {
      final check = await _studentRef
          .where('username', isEqualTo: username)
          .get();
      
      if (check.docs.isNotEmpty) return false;

      await _studentRef.add({
        'fullName': fullName,
        'username': username,
        'password': password,
        'role': role,
        'classId': '',
        'avgScore': 0.0,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  // Toggle trạng thái
  Future<bool> toggleStatus(String id, bool currentStatus) async {
    try {
      await _studentRef.doc(id).update({'isActive': !currentStatus});
      return true;
    } catch (e) {
      return false;
    }
  }

  // Reset mật khẩu
  Future<bool> resetPassword(String id) async {
    try {
      // Trong thực tế: Update field password thành '123456'
      await _studentRef.doc(id).update({'password': '123456'});
      return true;
    } catch (e) {
      return false;
    }
  }

  // Xóa học viên
  Future<bool> deleteStudent(String id) async {
    try {
      await _studentRef.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}