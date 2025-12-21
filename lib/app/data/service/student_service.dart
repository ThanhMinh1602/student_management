import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blooket/app/data/model/student_model.dart';

class StudentService {
  final CollectionReference _studentRef = FirebaseFirestore.instance.collection(
    'students',
  );

  // Lấy TOÀN BỘ danh sách học viên (Sắp xếp mới nhất lên đầu)
  Stream<List<StudentModel>> getAllStudentsStream() {
    return _studentRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => StudentModel.fromSnapshot(doc))
              .toList(),
        );
  }

  // Thêm tài khoản mới
  Future<bool> addStudent({
    required String fullName,
    required String username,
  }) async {
    try {
      // Kiểm tra username đã tồn tại chưa (Optional)
      final check = await _studentRef
          .where('username', isEqualTo: username)
          .get();
      if (check.docs.isNotEmpty) return false; // Username bị trùng

      await _studentRef.add({
        'fullName': fullName,
        'username': username,
        'avgScore': 0.0,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        // Password mặc định 123456 sẽ được xử lý ở Auth Service khi user login lần đầu
      });
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  // Toggle trạng thái (Khóa/Mở)
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
      // Logic gọi Cloud Function hoặc API để reset pass
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Xóa học viên (Nếu cần)
  Future<bool> deleteStudent(String id) async {
    try {
      await _studentRef.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
